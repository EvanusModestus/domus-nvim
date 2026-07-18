-- Options
-- Core vim.opt settings

-- Leader key (set early)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Regex memory ceiling (global-only option). Default 1000 KB is too low for
-- Vim's built-in syntax/asciidoc.vim multi-line region patterns, which raise
-- E363 on long lines (URLs, base64 data-URIs, wide table rows). AsciiDoc has no
-- treesitter parser, so those regexes are unavoidable — give them headroom.
vim.opt.maxmempattern = 5000

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

-- Floating window border (nvim 0.11+). One global option styles every otherwise
-- borderless core float — LSP hover, signature help, the diagnostic float,
-- vim.ui.input (rename) and vim.ui.select. Plugins that pass their own border
-- (blink.cmp, telescope, which-key, lazy.nvim) override it, so this only touches
-- the built-in floats that previously rendered with no border at all.
if vim.fn.has("nvim-0.11") == 1 then
    vim.o.winborder = "rounded"
end

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
else
    -- Native Linux: neovim auto-detects xclip/xsel
    vim.opt.clipboard = "unnamedplus"
end
