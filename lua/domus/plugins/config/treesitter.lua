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

    -- Fetch grammars via git, not curl. This workstation's hardened AppArmor
    -- curl profile denies writes to ~/.local/share/nvim (stdpath data), so the
    -- default `curl --output <lang>.tar.gz` path fails with curl (23). git is
    -- unconfined and already the transport lazy.nvim uses for every plugin, so
    -- no sudo and the curl profile stays fully locked. Default is win32-only.
    require("nvim-treesitter.install").prefer_git = true

    configs.setup({
        ensure_installed = ensure_installed,
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            -- Skip parsing on big buffers (same class of stall as legacy syntax;
            -- mirrors the 1.5 MB cutoff in config/autocmds.lua's big-file guard).
            disable = function(_, buf)
                local ok, stat = pcall((vim.uv or vim.loop).fs_stat,
                    vim.api.nvim_buf_get_name(buf))
                return ok and stat and stat.size > 1.5 * 1024 * 1024
            end,
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
                    -- ]C not ]c: ]c/[c belong to Gitsigns hunk nav (Vim diff
                    -- convention). Reactivating treesitter reintroduced the clash.
                    ["]C"] = "@class.outer",
                    ["]b"] = "@block.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[C"] = "@class.outer",
                    ["[b"] = "@block.outer",
                },
            },
        },
    })
end

return M
