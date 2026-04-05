-- Markdown filetype settings

-- Spell checking
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- Text wrapping
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- Fix formatoptions (prevent double-dash in checkboxes)
vim.opt_local.formatoptions:remove({ "r", "o" })

-- Follow markdown links with gf
vim.keymap.set("n", "gf", function()
    local line = vim.api.nvim_get_current_line()
    local path = line:match("%[.-%]%((.-)%)")
    if path then
        vim.cmd.edit(vim.fn.fnameescape(path))
    else
        vim.cmd("normal! gf")
    end
end, { buffer = true, desc = "Follow markdown link" })
