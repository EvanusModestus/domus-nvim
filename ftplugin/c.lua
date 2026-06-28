-- C filetype settings

-- Indentation (kernel style: tabs, 8-wide; override per-project with .editorconfig)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- Compile and run current file
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    local file = vim.fn.expand("%")
    local out = vim.fn.expand("%:r")
    vim.cmd("!" .. "gcc -Wall -Wextra -std=c11 -g -o " .. out .. " " .. file .. " && ./" .. out)
end, { buffer = true, desc = "Compile & run C" })

-- Compile only (populate quickfix on errors)
vim.keymap.set("n", "<leader>cm", function()
    vim.cmd("w")
    vim.opt_local.makeprg = "gcc -Wall -Wextra -std=c11 -g -o " .. vim.fn.expand("%:r") .. " " .. vim.fn.expand("%")
    vim.cmd("make!")
    vim.cmd("copen")
end, { buffer = true, desc = "Compile C (quickfix)" })

-- Man page for word under cursor (syscalls, libc)
vim.keymap.set("n", "K", function()
    local word = vim.fn.expand("<cword>")
    -- Try section 2 (syscalls) first, fall back to section 3 (libc), then general
    local sections = { "2", "3", "" }
    for _, sec in ipairs(sections) do
        local cmd = sec ~= "" and ("Man " .. sec .. " " .. word) or ("Man " .. word)
        local ok = pcall(vim.cmd, cmd)
        if ok then return end
    end
    -- Fall back to LSP hover if no man page
    vim.lsp.buf.hover()
end, { buffer = true, desc = "Man page / hover" })
