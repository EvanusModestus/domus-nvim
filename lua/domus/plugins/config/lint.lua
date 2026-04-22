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
    }

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
