-- nvim-lint Configuration

local M = {}

function M.setup()
    local ok, lint = pcall(require, "lint")
    if not ok then return end

    lint.linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        lua = { "selene" },
        -- sh/bash: bashls already runs shellcheck via LSP — no nvim-lint entry needed
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        dockerfile = { "hadolint" },
        go = { "golangci-lint" },
        terraform = { "tflint" },
        asciidoc = { "asciidoctor" },
        sql = { "sqlfluff" },
        -- PowerShell diagnostics come from powershell_es (PSScriptAnalyzer) via LSP,
        -- so no nvim-lint entry — same pattern as sh/bash (bashls → shellcheck).
    }

    -- sqlfluff refuses to run without a dialect. Honor a project .sqlfluff (its
    -- dialect wins); otherwise fall back to postgres (the default across repos).
    -- For a T-SQL / MySQL repo drop a .sqlfluff with the right dialect.
    local sqlfluff = require("lint.linters.sqlfluff")
    sqlfluff.args = function()
        local args = { "lint", "--format=json" }
        local buf = vim.api.nvim_buf_get_name(0)
        local has_cfg = buf ~= ""
            and vim.fs.find(".sqlfluff", { upward = true, path = vim.fs.dirname(buf) })[1] ~= nil
        if not has_cfg then
            table.insert(args, "--dialect=postgres")
        end
        table.insert(args, "-")
        return args
    end

    -- Custom linter: asciidoctor
    -- Parses stderr warnings/errors into buffer diagnostics
    lint.linters.asciidoctor = {
        name = "asciidoctor",
        cmd = "asciidoctor",
        args = { "-o", "/dev/null", "-" },
        stdin = true,
        stream = "stderr",
        ignore_exitcode = true,
        parser = function(output, bufnr)
            local diagnostics = {}
            for line in output:gmatch("[^\n]+") do
                -- asciidoctor: WARNING: <stdin>: line 5: ...
                -- asciidoctor: ERROR: <stdin>: line 5: ...
                local severity_str, lnum, msg = line:match("asciidoctor: (%u+):.-line (%d+): (.+)")
                if severity_str and lnum then
                    local severity = severity_str == "ERROR"
                        and vim.diagnostic.severity.ERROR
                        or vim.diagnostic.severity.WARN
                    table.insert(diagnostics, {
                        lnum = tonumber(lnum) - 1,
                        col = 0,
                        severity = severity,
                        message = msg,
                        source = "asciidoctor",
                    })
                end
            end
            return diagnostics
        end,
    }

    -- Auto-lint on save and insert leave
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
            lint.try_lint()
        end,
    })
end

return M
