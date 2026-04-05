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

    mti.setup({
        ensure_installed = {
            -- Formatters
            "ruff",
            "prettier",
            "stylua",
            "shfmt",
            "clang-format",
            "sqlfluff",
            "taplo",

            -- DAP Adapters
            "debugpy",
            "codelldb",

            -- Linters
            "eslint_d",
            "shellcheck",
            "selene",
            "markdownlint",
            "yamllint",
            "hadolint",
            "golangci-lint",
            "tflint",
        },

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
