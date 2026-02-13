-- Autocmds
-- Autocommands that don't belong to specific plugins

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General augroup
local general = augroup("DomusGeneral", { clear = true })

-- Highlight yanked text
autocmd("TextYankPost", {
    group = general,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Auto-resize splits
autocmd("VimResized", {
    group = general,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
    group = general,
    pattern = "*",
    callback = function()
        if vim.bo.binary or vim.bo.filetype == "diff" or not vim.bo.modifiable then
            return
        end
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Auto-create directories when saving
autocmd("BufWritePre", {
    group = general,
    callback = function()
        local dir = vim.fn.expand("<afile>:p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Terminal keymaps
autocmd("TermOpen", {
    group = general,
    pattern = "term://*",
    callback = function()
        local opts = { noremap = true, buffer = true }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    end,
})

-- Note: Filetype-specific autocmds moved to ftplugin/ directory
-- See: ftplugin/markdown.lua, ftplugin/asciidoc.lua
