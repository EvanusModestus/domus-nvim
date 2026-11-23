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

    -- Curated to the languages actually used in nvim (see journal 2026-11-23). Reinstall anything
    -- dropped on demand with `:MasonInstall <name>` + a one-line add here.
    local ensure = {
        -- Formatters
        "ruff",
        "stylua",
        "shfmt",
        "clang-format",
        "taplo",

        -- Linters
        "shellcheck",
        "markdownlint",   -- Markdown (used heavily at work)
        "yamllint",
    }

    -- Go tools are built via the Go toolchain; only enqueue them when `go` is on PATH, else
    -- mason-tool-installer retries the failing build on every startup (run_on_start = true).
    if vim.fn.executable("go") == 1 then
        vim.list_extend(ensure, {
            "goimports",     -- Go import management (conform)
            "gofumpt",       -- Go stricter gofmt (conform)
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
