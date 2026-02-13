-- AsciiDoc Language Specs

return {
    -- AsciiDoc support (snippets, navigation, keymaps)
    {
        dir = vim.fn.stdpath("config"),
        name = "asciidoc-support",
        ft = { "asciidoc", "asciidoctor" },
        config = function()
            require("domus.plugins.config.lang.asciidoc").setup()
        end,
    },
}
