-- Python filetype settings

-- Indentation
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

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
