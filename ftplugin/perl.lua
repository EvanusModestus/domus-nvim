-- Perl filetype settings

-- Indentation (4-space, expandtab -- the perlstyle default)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- Run current file
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("w")
    vim.cmd("!perl " .. vim.fn.shellescape(vim.fn.expand("%")))
end, { buffer = true, desc = "Run Perl file" })

-- Syntax check (perl -c) into the quickfix list -- the fast "does it compile" loop
vim.keymap.set("n", "<leader>cm", function()
    vim.cmd("w")
    vim.opt_local.makeprg = "perl -c %"
    -- perl -c emits "<msg> at <file> line <N>." -- teach :make that shape
    vim.opt_local.errorformat = "%m at %f line %l%.%#"
    vim.cmd("make!")
    vim.cmd("copen")
end, { buffer = true, desc = "Perl syntax check (quickfix)" })

-- perldoc for the word under cursor: builtin function (-f) first, then module/general,
-- then fall back to LSP hover. Mirrors ftplugin/c.lua's man-page K. lsp/init.lua skips
-- binding K for perl so this richer lookup wins.
vim.keymap.set("n", "K", function()
    local word = vim.fn.expand("<cword>")
    for _, args in ipairs({ "-f " .. word, word }) do
        local out = vim.fn.systemlist("perldoc -To text " .. args .. " 2>/dev/null")
        if vim.v.shell_error == 0 and #out > 0 then
            vim.cmd("botright new")
            vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
            vim.bo.modifiable = false
            vim.bo.buftype = "nofile"
            vim.bo.bufhidden = "wipe"
            vim.bo.filetype = "man"
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
            return
        end
    end
    vim.lsp.buf.hover()
end, { buffer = true, desc = "perldoc / hover" })
