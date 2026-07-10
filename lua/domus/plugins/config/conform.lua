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
            terraform = { "terraform_fmt" }, -- needs `terraform` CLI (no-ops if absent)
            hcl = { "terraform_fmt" },
            d2 = { "d2" }, -- `d2 fmt` (builtin conform formatter); needs `.d2` ft (see autocmds.lua)
            -- PowerShell (ps1) formats via powershell_es LSP through lsp_format="fallback".
        },

        formatters = {
            shfmt = {
                prepend_args = { "-i", "2", "-ci", "-bn" },
            },
            -- Mirror the lint dialect logic: project .sqlfluff wins, else postgres.
            sqlfluff = {
                args = function(_, ctx)
                    local args = { "format" }
                    local has_cfg = ctx.filename ~= ""
                        and vim.fs.find(".sqlfluff", { upward = true, path = vim.fs.dirname(ctx.filename) })[1] ~= nil
                    if not has_cfg then
                        vim.list_extend(args, { "--dialect=postgres" })
                    end
                    vim.list_extend(args, { "-" })
                    return args
                end,
            },
        },

        format_on_save = function(bufnr)
            -- Disable for certain filetypes
            local ignore_filetypes = { "sql", "markdown" }
            if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                return
            end
            -- Skip formatting when the buffer has errors — avoids popup on broken syntax
            local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
            if #diagnostics > 0 then
                return
            end
            return {
                timeout_ms = 500,
                lsp_format = "fallback",
                quiet = true,
            }
        end,
    })

    -- Manual format keymap
    vim.keymap.set({ "n", "v" }, "<leader>cF", function()
        conform.format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer" })
end

return M
