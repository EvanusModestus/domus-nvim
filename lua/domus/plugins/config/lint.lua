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
        lua = { "luacheck" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
        go = { "golangci-lint" },
        terraform = { "tflint" },
    }

    -- Auto-lint on save and insert leave
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
            lint.try_lint()
        end,
    })
end

return M
