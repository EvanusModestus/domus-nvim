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

    -- Neutralize markdown injection queries. nvim-treesitter's frozen master
    -- ships a markdown/markdown_inline injections query that hands Neovim 0.12's
    -- reworked core a nil node -> "attempt to call method 'range' (a nil value)"
    -- on every fenced code block, crashing the highlighter. Set at setup (before
    -- any markdown buffer parses) so the empty query wins. Markdown still gets
    -- block-level treesitter highlighting; fenced-code/inline injection
    -- highlighting is dropped until the main branch is adopted. Other languages'
    -- injections (html, lua, ...) are unaffected.
    pcall(vim.treesitter.query.set, "markdown", "injections", "")
    pcall(vim.treesitter.query.set, "markdown_inline", "injections", "")

    -- Neutralize only the crashing bash heredoc injection. nvim-treesitter's
    -- frozen master ships a `heredoc_redirect` injection that applies
    -- `#downcase!` to a language *node* capture (the heredoc_end tag). Neovim
    -- 0.12's reworked core mishandles a directive on a language node and hands
    -- the highlighter a nil node -> "attempt to call method 'range'/'start' (a
    -- nil value)" on every shell buffer containing a heredoc. Rather than nuke
    -- every bash injection like markdown above, read the shipped query and
    -- strip ONLY that one stanza, so printf/regex/comment/bind injections
    -- survive. Heredoc-body language highlighting is dropped until the main
    -- branch (which parses clean on 0.12) is adopted. Runs at setup, before any
    -- bash buffer parses, so the set query wins.
    do
        local files = vim.api.nvim_get_runtime_file(
            "queries/bash/injections.scm", true)
        local raw = ""
        for _, f in ipairs(files) do
            local fh = io.open(f, "r")
            if fh then
                raw = raw .. fh:read("*a") .. "\n"
                fh:close()
            end
        end
        -- Lua patterns treat `.` as any char incl. newline; `.-` is non-greedy,
        -- so this matches the stanza from `((heredoc_redirect` to its first `))`.
        local stripped, removed = raw:gsub("%(%(heredoc_redirect.-%)%)", "")
        -- Only install when we actually removed the crashing stanza. If a future
        -- query drops it upstream (removed == 0), the shipped query is already
        -- safe and we leave Neovim's default in place.
        if removed > 0 then
            pcall(vim.treesitter.query.set, "bash", "injections", stripped)
        end
    end
end

return M
