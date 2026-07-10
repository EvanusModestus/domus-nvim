-- Blink.cmp Configuration

local M = {}

function M.setup()
    local ok, blink = pcall(require, "blink.cmp")
    if not ok then return end

    blink.setup({
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<Esc>"] = { "hide", "fallback" },
            ["<C-y>"] = { "select_and_accept" },
            ["<CR>"] = { "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },

        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
        },

        snippets = { preset = "luasnip" },

        sources = {
            default = { "lsp", "path", "snippets", "buffer", "lazydev" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                -- Buffer (word) completion. v0.14.2 hard-capped at 500KB and had no
                -- word cache — it re-tokenized the whole buffer on every keystroke, so
                -- large docs (>500KB) returned nothing and mid-size ones lagged. v1.x
                -- keeps a per-buffer cache (default use_cache=true), invalidated only on
                -- modify. These limits let a multi-thousand-line doc stay fully indexed.
                -- Invariant: max_total > max_async > max_sync (blink validates this).
                buffer = {
                    opts = {
                        max_sync_buffer_size  = 40000,    -- <=40KB: tokenize inline (instant)
                        max_async_buffer_size = 2000000,  -- <=2MB per buffer: async, non-blocking
                        max_total_buffer_size = 4000000,  -- <=4MB across buffers (must exceed async)
                    },
                },
            },
        },

        completion = {
            accept = { auto_brackets = { enabled = true } },
            trigger = {
                -- PowerShell Editor Services advertises space (' ') as a completion
                -- trigger character because PS completion is space/parameter-driven
                -- (`Get-Process | `, `-Path `, `Set-Cl`). blink blocks space globally
                -- by default, so the pipeline/parameter menu never auto-opened after a
                -- pipe. Unblock space ONLY for PowerShell buffers — matching VS Code —
                -- while keeping it blocked elsewhere (prose, other langs).
                show_on_blocked_trigger_characters = function()
                    local ft = vim.bo.filetype
                    if ft == "ps1" or ft == "psm1" or ft == "psd1" then
                        return { "\n", "\t" }
                    end
                    return { " ", "\n", "\t" }
                end,
            },
            menu = {
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind" },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },

        signature = { enabled = true },
    })
end

return M
