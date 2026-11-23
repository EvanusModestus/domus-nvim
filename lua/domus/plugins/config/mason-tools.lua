-- Mason Tool Installer Configuration

local M = {}
local util = require("domus.core.util")

function M.setup()
    local ok, mti = pcall(require, "mason-tool-installer")
    if not ok then return end

    -- Skip ensure_installed on Termux - use system packages instead
    if util.is_termux() then
        mti.setup({
            ensure_installed = {},
            auto_update = false,
            run_on_start = false,
        })
        return
    end

    local ensure = {
        -- Formatters
        "ruff",
        "prettier",
        "stylua",
        "shfmt",
        "clang-format",
        "rubocop",   -- Ruby format + lint (conform + nvim-lint)
        "sqlfluff",
        "taplo",

        -- DAP Adapters
        "debugpy",
        "codelldb",

        -- Linters
        "eslint_d",
        "jsonlint",
        "shellcheck",
        "selene",
        "markdownlint",
        "yamllint",
        "hadolint",
        "tflint",
    }

    -- Go tools are built via the Go toolchain; only enqueue them when `go` is on PATH, else
    -- mason-tool-installer retries the failing build on every startup (run_on_start = true).
    if vim.fn.executable("go") == 1 then
        vim.list_extend(ensure, {
            "goimports",     -- Go import management (conform)
            "gofumpt",       -- Go stricter gofmt (conform)
            "delve",         -- Go debugger (dlv) for nvim-dap
            "golangci-lint", -- Go linter (nvim-lint)
        })
    end

    mti.setup({
        ensure_installed = ensure,

        auto_update = false,
        run_on_start = true,
        start_delay = 3000,

        integrations = {
            ["mason-lspconfig"] = true,
            ["mason-nvim-dap"] = true,
        },
    })
end

return M
