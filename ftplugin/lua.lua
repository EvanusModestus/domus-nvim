-- Lua filetype settings
-- Indentation matches config/options.lua's global default (4/4/expandtab) —
-- not repeated here to avoid drifting if that default ever changes.

-- Run current file
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    vim.cmd("luafile %")
end, { buffer = true, desc = "Run Lua file" })
