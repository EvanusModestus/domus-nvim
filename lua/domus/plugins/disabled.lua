-- Central disable registry (single source of truth for trial-disabled plugins)
--
-- Keyed by the repo tail (the part after the last "/", or an explicit spec `name`).
-- The aggregator in init.lua stamps `enabled = false` on any matching spec, so lazy.nvim
-- skips BOTH install and load -- a true trial removal. Revert = delete the line.
-- The value is the reason it went dark (shown here, greppable, self-documenting).
--
-- Audit + tiers: tabularium journal 2026-11-22-nvim-plugin-audit-disable-registry.
-- NOTE: lockfile-only orphans (copilot.lua, CopilotChat.nvim) are NOT declared specs,
-- so the registry cannot act on them -- reclaim those with `:Lazy clean`.

return {
    -- Tier 2 -- games / drills (cmd-lazy; declutter only)
    ["vim-be-good"] = "motion drill game; unused",
    ["golf"] = "golf challenge game; unused",

    -- Tier 3 -- unused colorschemes (active scheme is catppuccin)
    ["gruvbox-material"] = "unused colorscheme (active: catppuccin)",
    ["kanagawa.nvim"] = "unused colorscheme (active: catppuccin)",
    ["tokyonight.nvim"] = "unused colorscheme (active: catppuccin)",
    ["rose-pine"] = "unused colorscheme (active: catppuccin)",
    ["nightfox.nvim"] = "unused colorscheme (active: catppuccin)",

    -- Tier 4 -- niche language tooling (ft-gated; disable if those filetypes unused)
    ["cisco.vim"] = "Cisco IOS syntax; niche ft",
    ["junos.vim"] = "Junos syntax; niche ft",
    ["rainbow_csv.nvim"] = "CSV column rainbow; niche ft",
    ["vim-markdown"] = "markdown stack; niche (treesitter covers most)",
    ["bullets.vim"] = "markdown bullet autolist; niche ft",
    ["vim-table-mode"] = "markdown/asciidoc table mode; niche ft",
    ["iron.nvim"] = "Python REPL send; niche",
    ["vim-dadbod"] = "SQL client core; niche",
    ["vim-dadbod-ui"] = "SQL client UI; niche",
    ["vim-dadbod-completion"] = "SQL completion; niche",

    -- Tier 5 -- eye-candy / startup cost (the real latency wins)
    ["mini.animate"] = "scroll/resize animation; redraw cost",
    ["colorful-winsep.nvim"] = "colored window separators; eye-candy",
    ["screenkey.nvim"] = "on-screen keystrokes; recording tool only",
    ["headlines.nvim"] = "markdown/org header highlight; eye-candy",
    ["alpha-nvim"] = "start dashboard; startup cost",
    ["zen-mode.nvim"] = "distraction-free mode; keys-lazy, cheap",
    ["auto-session"] = "session auto-restore reopens last file on startup; trial-disabled",
}
