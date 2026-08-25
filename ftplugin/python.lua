-- Python filetype settings
-- Indentation matches config/options.lua's global default (4/4/expandtab) —
-- not repeated here to avoid drifting if that default ever changes.

-- Run current file
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    vim.cmd("!python3 %")
end, { buffer = true, desc = "Run Python file" })

-- Run with debugpy
vim.keymap.set("n", "<leader>cd", function()
    vim.cmd("w")
    vim.cmd("!python3 -m debugpy --listen 5678 --wait-for-client %")
end, { buffer = true, desc = "Run with debugpy" })
