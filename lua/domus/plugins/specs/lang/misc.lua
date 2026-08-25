-- Miscellaneous Language Specs
-- Cisco, Jinja2, CSV, SQL, etc.

return {
    -- Cisco/Junos configs
    { "momota/cisco.vim", ft = { "cisco" } },
    { "momota/junos.vim", ft = { "junos" } },

    -- CSV (rainbow_csv)
    {
        "cameron-wags/rainbow_csv.nvim",
        ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe" },
        cmd = { "RainbowDelim", "RainbowDelimSimple", "RainbowDelimQuoted" },
        config = true,
    },

    -- Database
    {
        "tpope/vim-dadbod",
        cmd = "DB",
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
        dependencies = { "tpope/vim-dadbod" },
    },
    -- vim-dadbod-completion removed: it's an nvim-cmp source, and this config's
    -- completion engine is blink.cmp with no compat shim registered — it loaded
    -- on every SQL buffer and fed zero completions.
}
