-- Lua filetype settings

-- Indentation
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- Run current file
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    vim.cmd("luafile %")
end, { buffer = true, desc = "Run Lua file" })
