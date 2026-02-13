-- AsciiDoc filetype settings

-- Spell checking
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- Text wrapping (soft wrap, no hard breaks)
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 0

-- Disable comment auto-continuation
vim.opt_local.formatoptions:remove({ "r", "o", "c" })
vim.opt_local.comments = ""

-- Concealment
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""

-- Folding (indent-based, no treesitter parser for AsciiDoc)
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldenable = false

-- Follow AsciiDoc xrefs with gf
vim.keymap.set("n", "gf", function()
    local line = vim.api.nvim_get_current_line()

    -- xref:page.adoc[]
    local xref = line:match("xref:([^%[]+)")
    if xref then
        vim.cmd("edit " .. xref:gsub("#.*", ""))
        return
    end

    -- include::path[]
    local include = line:match("include::([^%[]+)")
    if include then
        vim.cmd("edit " .. include)
        return
    end

    -- Fallback
    vim.cmd("normal! gf")
end, { buffer = true, desc = "Follow AsciiDoc xref/include" })
