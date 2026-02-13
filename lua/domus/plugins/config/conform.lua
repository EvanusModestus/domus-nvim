-- Conform (Formatting) Configuration

local M = {}

function M.setup()
    local ok, conform = pcall(require, "conform")
    if not ok then return end

    conform.setup({
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format", "ruff_fix" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            zsh = { "shfmt" },
            rust = { "rustfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            sql = { "sqlfluff" },
            toml = { "taplo" },
        },

        format_on_save = function(bufnr)
            -- Disable for certain filetypes
            local ignore_filetypes = { "sql", "markdown" }
            if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                return
            end
            return {
                timeout_ms = 500,
                lsp_fallback = true,
            }
        end,
    })

    -- Manual format keymap
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({ async = true, lsp_fallback = true })
    end, { desc = "Format buffer" })
end

return M
