-- AsciiDoc filetype settings

-- Big files: the guard in config/autocmds.lua already stripped syntax/fold/spell.
-- Skip the expensive re-enables below; keep only cheap nav (gf) at the bottom.
local bigfile = vim.b.bigfile

-- Spell checking
if not bigfile then
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
end

-- Text wrapping (soft wrap, no hard breaks)
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 0

-- Disable comment auto-continuation
vim.opt_local.formatoptions:remove({ "r", "o", "c" })
vim.opt_local.comments = ""

if not bigfile then
    -- Concealment
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = ""

    -- Folding (indent-based, no treesitter parser for AsciiDoc)
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldenable = false

    -- Syntax perf: built-in syntax/asciidoc.vim runs expensive multi-line regexes.
    -- Cap highlighting past column 400 so a single long line (base64 data-URI,
    -- wide table row, long URL) can't trigger E363. 400 clears normal wrapped prose.
    vim.opt_local.synmaxcol = 400
end

-- Follow AsciiDoc xrefs with gf
vim.keymap.set("n", "gf", function()
    local line = vim.api.nvim_get_current_line()

    -- xref:page.adoc[]
    local xref = line:match("xref:([^%[]+)")
    if xref then
        local path = xref:gsub("#.*", "")
        if vim.fn.filereadable(path) == 0 then
            vim.notify("File not found: " .. path, vim.log.levels.WARN)
            return
        end
        vim.cmd.edit(vim.fn.fnameescape(path))
        return
    end

    -- include::path[]
    local include = line:match("include::([^%[]+)")
    if include then
        if vim.fn.filereadable(include) == 0 then
            vim.notify("File not found: " .. include, vim.log.levels.WARN)
            return
        end
        vim.cmd.edit(vim.fn.fnameescape(include))
        return
    end

    -- Fallback
    vim.cmd("normal! gf")
end, { buffer = true, desc = "Follow AsciiDoc xref/include" })
