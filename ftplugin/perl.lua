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

-- ---------------------------------------------------------------------------
-- Native-CLI Perl workflow (no plugins), in the spirit of Damian Conway's
-- "VIM as a Perl IDE" talk (YAPC::NA 2016) -- the keep-it-in-the-terminal,
-- composable-tools philosophy, not his exact mappings. (Conway's own vimrc
-- uses ALE for `perl -c -w`, perltidy via `;p`, sub/package folding, and
-- `??` perldoc; it has no Deparse/perlcritic/scratch bindings -- those below
-- are our additions on top of what PerlNavigator + conform already cover.)
-- PerlNavigator (LSP) gives live `perl -c` + perlcritic diagnostics and conform
-- runs perltidy on save; these add tools LSP does NOT: Deparse (reveal how Perl
-- *actually* parses the code), a scratch-buffer runner (selection or whole
-- file), perlcritic-at-brutal on demand, and a POD preview. All output lands in
-- a throwaway scratch buffer (press q to close) instead of a blocking shell.
-- ---------------------------------------------------------------------------

-- Open lines in a throwaway scratch split (q closes). ft tags it for highlight.
local function scratch(lines, ft)
    vim.cmd("botright new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.modifiable = false
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    if ft then vim.bo.filetype = ft end
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
end

-- Deparse the whole saved file: `-p` parenthesizes everything so operator
-- precedence and context become visible. The standard "see what perl thinks
-- the code is" idiom (B::Deparse; cf. brian d foy, Effective Perl) -- exposes
-- precedence traps, implicit returns, list vs scalar context.
-- Always whole-file: a deparsed fragment usually will not compile on its own.
vim.api.nvim_buf_create_user_command(0, "PerlDeparse", function()
    vim.cmd("silent write")
    local file = vim.fn.expand("%")
    local out = vim.fn.systemlist("perl -MO=Deparse,-p " .. vim.fn.shellescape(file) .. " 2>&1")
    scratch(out, "perl")
end, { desc = "Deparse current file (B::Deparse -p)" })

-- Run perl over a range (visual: `:'<,'>PerlRun`) or the whole file, output to
-- a scratch buffer -- non-blocking, re-runnable, unlike the ftplugin's `!perl`.
vim.api.nvim_buf_create_user_command(0, "PerlRun", function(opts)
    local src = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
    local out = vim.fn.systemlist("perl", src) -- feed the lines on stdin
    scratch(out, nil)
end, { range = "%", desc = "Run file/selection through perl -> scratch" })

-- perlcritic at --brutal (severity 1: every policy fires) into the quickfix.
-- The LSP runs perlcritic (Thalhammer's Perl::Critic, which encodes Conway's
-- Perl Best Practices rules) at its default gentle level; this is the "show me
-- EVERYTHING, even the pedantic policies" pass. PBP's own advice is to start
-- gentle and work toward brutal as code is cleaned up. Needs Perl::Critic on
-- PATH (cpan Perl::Critic); no-ops with a message if absent.
vim.api.nvim_buf_create_user_command(0, "PerlCritic", function()
    if vim.fn.executable("perlcritic") == 0 then
        vim.notify("perlcritic not found (cpan Perl::Critic)", vim.log.levels.WARN)
        return
    end
    vim.cmd("silent write")
    vim.opt_local.makeprg = "perlcritic --brutal --verbose '%f:%l:%c: %m [%p, sev %s]\\n' %"
    vim.opt_local.errorformat = "%f:%l:%c: %m"
    vim.cmd("make!")
    vim.cmd("copen")
end, { desc = "perlcritic --brutal -> quickfix" })

-- Render the current file's POD as formatted text (perldoc of the file itself).
vim.api.nvim_buf_create_user_command(0, "PerlPod", function()
    vim.cmd("silent write")
    local out = vim.fn.systemlist("perldoc -To text " .. vim.fn.shellescape(vim.fn.expand("%")) .. " 2>&1")
    scratch(out, "man")
end, { desc = "Preview this file's POD" })

-- Normal-mode leader keys (buffer-local). Visual selections use the range
-- commands directly: select, then `:PerlRun` (Vim prefills the '<,'> range).
local kopts = { buffer = true, silent = true }
vim.keymap.set("n", "<leader>pd", "<cmd>PerlDeparse<CR>", vim.tbl_extend("force", kopts, { desc = "Perl: deparse file" }))
vim.keymap.set("n", "<leader>pr", "<cmd>PerlRun<CR>",     vim.tbl_extend("force", kopts, { desc = "Perl: run file -> scratch" }))
vim.keymap.set("n", "<leader>pc", "<cmd>PerlCritic<CR>",  vim.tbl_extend("force", kopts, { desc = "Perl: perlcritic brutal" }))
vim.keymap.set("n", "<leader>pp", "<cmd>PerlPod<CR>",     vim.tbl_extend("force", kopts, { desc = "Perl: preview POD" }))

-- New-file skeleton. `use v5.36` (Perl 5.36, 2022) turns on strict, warnings,
-- say, and subroutine signatures in one line -- the modern-Perl boilerplate.
-- Only fires on a genuinely empty, never-saved buffer.
if vim.fn.filereadable(vim.fn.expand("%")) == 0
    and vim.api.nvim_buf_line_count(0) == 1
    and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
    local ext = vim.fn.expand("%:e")
    local skel
    if ext == "pm" then
        local pkg = vim.fn.expand("%:t:r")
        skel = { "package " .. pkg .. ";", "use v5.36;", "", "", "1;" }
    else
        skel = { "#!/usr/bin/env perl", "use v5.36;", "", "" }
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, skel)
    vim.api.nvim_win_set_cursor(0, { #skel, 0 })
end
