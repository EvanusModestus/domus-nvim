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

-- ============================================================================
-- List continuation
-- ----------------------------------------------------------------------------
-- formatoptions r/o were stripped above to stop *comment* auto-continuation;
-- that also disabled *list* continuation. Restore it for lists only, AsciiDoc-
-- aware: repeat the marker on <CR>/o/O, increment numbered lists, carry the
-- checklist box, and terminate the list when you press Enter on an empty item.
-- Markers handled: "*"/"**"/... unordered, "-" dash, "."/".."/... ordered,
-- "N." numbered, "* [ ]" checklists. blink.cmp maps <CR> to "fallback" (accept
-- is <C-y>/<Tab>), so this never fights completion.
-- ============================================================================

local _tc = function(s) return vim.api.nvim_replace_termcodes(s, true, false, true) end

-- Returns indent, continuation-marker (with trailing space), rest-after-marker
-- when `line` is a list item; nil otherwise.
local function adoc_list_item(line)
    local ind, stars, rest = line:match("^(%s*)(%*+)%s+%[[ xX]%]%s+(.*)$") -- checklist
    if ind then return ind, stars .. " [ ] ", rest end
    local i2, num, r2 = line:match("^(%s*)(%d+)%.%s+(.*)$")               -- numbered
    if i2 then return i2, tostring(tonumber(num) + 1) .. ". ", r2 end
    local i3, mk, r3 = line:match("^(%s*)([%*%-]+)%s+(.*)$")              -- * ** or -
    if i3 then return i3, mk .. " ", r3 end
    local i4, dots, r4 = line:match("^(%s*)(%.+)%s+(.*)$")                -- . .. ordered
    if i4 then return i4, dots .. " ", r4 end
    return nil
end

-- <CR>: continue the list, or terminate on an empty item, else a plain newline.
vim.keymap.set("i", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local ind, cont, rest = adoc_list_item(line)
    if not ind then
        -- "ni": no-remap + insert at FRONT of typeahead so the newline lands before
        -- any keys still queued behind it (and never recurses into this mapping).
        vim.api.nvim_feedkeys(_tc("<CR>"), "ni", false)
        return
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col = pos[1], pos[2]
    if rest == "" then
        -- empty item -> leave the list: blank this line, stay on it
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "" })
        vim.api.nvim_win_set_cursor(0, { row, 0 })
        return
    end
    -- split at the cursor; text after the cursor rides onto the new item
    local before, after = line:sub(1, col), line:sub(col + 1)
    local lead = ind .. cont
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { before, lead .. after })
    vim.api.nvim_win_set_cursor(0, { row + 1, #lead })
end, { buffer = true, desc = "AsciiDoc: continue list on Enter" })

-- o / O: open a sibling list item (falls back to the native motion off-list).
local function adoc_open(default_key, above)
    local line = vim.api.nvim_get_current_line()
    local ind, cont, rest = adoc_list_item(line)
    if not ind or rest == "" then
        vim.api.nvim_feedkeys(_tc(default_key), "ni", false)
        return
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lead = ind .. cont
    local at = above and (row - 1) or row
    vim.api.nvim_buf_set_lines(0, at, at, false, { lead })
    vim.api.nvim_win_set_cursor(0, { at + 1, #lead })
    vim.cmd("startinsert!")
end
vim.keymap.set("n", "o", function() adoc_open("o", false) end,
    { buffer = true, desc = "AsciiDoc: new list item below" })
vim.keymap.set("n", "O", function() adoc_open("O", true) end,
    { buffer = true, desc = "AsciiDoc: new list item above" })
