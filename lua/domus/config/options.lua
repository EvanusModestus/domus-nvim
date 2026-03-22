-- Options
-- Core vim.opt settings

-- Leader key (set early)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable MOTD popup on startup
vim.g.disable_motd = true

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Text wrapping
vim.opt.wrap = false

-- File management
vim.opt.swapfile = true
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 50

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Visual
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.isfname:append("@-@")

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

-- Netrw (backup file browser)
vim.g.netrw_bufsettings = "noma nomod rnu nobl nowrap ro"

-- Clipboard (auto-detect environment)
if vim.fn.executable("win32yank.exe") == 1 then
    -- WSL: use win32yank
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end
-- Native Linux: neovim auto-detects xclip/xsel
vim.opt.clipboard = "unnamedplus"
