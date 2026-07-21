-- Autocmds
-- Autocommands that don't belong to specific plugins

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Filetype registration: Neovim core doesn't detect .d2, so conform/lint never
-- fire on it. Map the extension to the `d2` filetype (Terrastruct diagrams).
vim.filetype.add({ extension = { d2 = "d2" } })

-- Big-file guard: legacy syntax (syntax/asciidoc.vim has no treesitter parser),
-- indent folding, and spell each re-scan the whole buffer, so a 500k-line file
-- stalls the UI and can raise E363. Detect size at BufReadPre (before filetype /
-- syntax / ftplugin) and strip the expensive machinery. b:bigfile lets ftplugins
-- skip their own heavy settings (see ftplugin/asciidoc.lua).
local bigfile = augroup("DomusBigFile", { clear = true })
autocmd("BufReadPre", {
    group = bigfile,
    callback = function(ev)
        local ok, stat = pcall((vim.uv or vim.loop).fs_stat, ev.match)
        local size = (ok and stat) and stat.size or 0
        if size < 1.5 * 1024 * 1024 then -- 1.5 MB
            return
        end
        vim.b[ev.buf].bigfile = true
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.undolevels = -1
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.foldenable = false
        vim.opt_local.spell = false
        vim.opt_local.list = false
        -- Filetype turns syntax on after this hook; kill it once the buffer loads.
        autocmd("BufReadPost", {
            buffer = ev.buf,
            once = true,
            callback = function()
                vim.bo[ev.buf].syntax = "off"
                vim.notify("Big file (" .. math.floor(size / 1024 / 1024) ..
                    " MB): syntax/fold/spell disabled", vim.log.levels.WARN)
            end,
        })
    end,
})

-- General augroup
local general = augroup("DomusGeneral", { clear = true })

-- Highlight yanked text
autocmd("TextYankPost", {
    group = general,
    callback = function()
        -- vim.hl on 0.11+, vim.highlight on older
        (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 200 })
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
        -- Skip special buffers (dashboard, terminal, etc.)
        if vim.bo.binary or vim.bo.filetype == "diff" or not vim.bo.modifiable or vim.bo.buftype ~= "" then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Auto-create directories when saving
autocmd("BufWritePre", {
    group = general,
    callback = function()
        -- Skip special buffers
        if vim.bo.buftype ~= "" then
            return
        end
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

-- Secrets-safe editing: `sops <file>` decrypts to a temp that KEEPS the original
-- name (e.g. foo.sops.yaml) and opens it here. Neovim would otherwise spill that
-- plaintext to persistent disk via undofile (~/.local/share/nvim/undo/), the swap
-- file, and backups — long after the file is re-encrypted. Strip every on-disk
-- trace for any *.sops.* / *.age buffer (the temp inherits that name). Residual:
-- shada can still record a yanked secret line; add `:set shadafile=NONE` if paranoid.
local secrets = augroup("DomusSecrets", { clear = true })
autocmd({ "BufReadPre", "BufNewFile" }, {
    group = secrets,
    pattern = { "*.sops.yaml", "*.sops.yml", "*.sops.json", "*.sops.env", "*.age" },
    callback = function()
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.undolevels = -1 -- no in-memory undo history either
        vim.opt_local.backup = false
        vim.opt_local.writebackup = false
    end,
})

-- Note: Filetype-specific autocmds moved to ftplugin/ directory
-- See: ftplugin/markdown.lua, ftplugin/asciidoc.lua
