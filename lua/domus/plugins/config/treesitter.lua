-- Treesitter Configuration

local M = {}

local ensure_installed = {
    "javascript", "typescript", "c", "lua", "rust", "vim", "vimdoc", "query",
    "markdown", "markdown_inline", "yaml", "xml", "json", "toml", "bash",
    "python", "dockerfile", "sql", "css", "html", "regex", "http", "csv",
    "htmldjango",  -- Jinja2/Django templates
    -- Note: AsciiDoc has no official treesitter parser
}

function M.setup()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
        return
    end

    configs.setup({
        ensure_installed = ensure_installed,
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["ai"] = "@conditional.outer",
                    ["ii"] = "@conditional.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["a/"] = "@comment.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = { ["<leader>sn"] = "@parameter.inner" },
                swap_previous = { ["<leader>sp"] = "@parameter.inner" },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                    ["]b"] = "@block.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                    ["[b"] = "@block.outer",
                },
            },
        },
    })
end

return M
