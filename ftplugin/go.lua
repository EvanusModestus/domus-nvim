-- Go filetype settings

-- Go is tab-indented by convention (gofmt enforces it); show tabs 4 wide.
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Run current file (mirrors ftplugin/c.lua's <leader>cr)
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    vim.cmd("!go run " .. vim.fn.shellescape(vim.fn.expand("%")))
end, { buffer = true, desc = "Run Go file" })

-- Test the current package (quickfix on failure)
vim.keymap.set("n", "<leader>ct", function()
    vim.cmd("w")
    vim.opt_local.makeprg = "go test ./..."
    vim.cmd("make!")
    vim.cmd("copen")
end, { buffer = true, desc = "Go test (quickfix)" })

-- Build the current package (quickfix on errors)
vim.keymap.set("n", "<leader>cm", function()
    vim.cmd("w")
    vim.opt_local.makeprg = "go build ./..."
    vim.cmd("make!")
    vim.cmd("copen")
end, { buffer = true, desc = "Go build (quickfix)" })
