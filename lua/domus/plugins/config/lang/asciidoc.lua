-- AsciiDoc Language Configuration
-- Comprehensive AsciiDoc editing: snippets, navigation, keymaps, commands

local M = {}

-- ============================================================================
-- SNIPPET SETUP
-- ============================================================================

function M.setup()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node

    ls.add_snippets("asciidoc", {
        -- Code blocks
        s("code", { t("[source,"), i(1, "bash"), t({"]", "----", ""}), i(2), t({"", "----"}) }),
        s("codea", { t("[source,"), i(1, "bash"), t({",subs=attributes+]", "----", ""}), i(2), t({"", "----"}) }),
        s("bash", { t({"[source,bash]", "----", ""}), i(1), t({"", "----"}) }),
        s("python", { t({"[source,python]", "----", ""}), i(1), t({"", "----"}) }),
        s("lua", { t({"[source,lua]", "----", ""}), i(1), t({"", "----"}) }),
        s("yaml", { t({"[source,yaml]", "----", ""}), i(1), t({"", "----"}) }),
        s("json", { t({"[source,json]", "----", ""}), i(1), t({"", "----"}) }),

        -- Admonitions
        s("note", { t("NOTE: "), i(1) }),
        s("tip", { t("TIP: "), i(1) }),
        s("warning", { t("WARNING: "), i(1) }),
        s("caution", { t("CAUTION: "), i(1) }),
        s("important", { t("IMPORTANT: "), i(1) }),

        -- Block admonitions
        s("noteb", { t({"[NOTE]", "====", ""}), i(1), t({"", "===="}) }),
        s("tipb", { t({"[TIP]", "====", ""}), i(1), t({"", "===="}) }),
        s("warnb", { t({"[WARNING]", "====", ""}), i(1), t({"", "===="}) }),

        -- Headers
        s("h1", { t("= "), i(1, "Title") }),
        s("h2", { t("== "), i(1, "Section") }),
        s("h3", { t("=== "), i(1, "Subsection") }),
        s("h4", { t("==== "), i(1, "Sub-subsection") }),

        -- Cross-references (Antora)
        s("xref", { t("xref:"), i(1, "page.adoc"), t("["), i(2, "Link text"), t("]") }),
        s("xrefc", { t("xref:"), i(1, "component"), t("::"), i(2, "page.adoc"), t("["), i(3, "text"), t("]") }),
        s("include", { t("include::"), i(1, "path/file.adoc"), t("[]") }),
        s("partial", { t("include::partial$"), i(1, "file.adoc"), t("[]") }),

        -- Links and images
        s("link", { t("link:"), i(1, "https://"), t("["), i(2, "text"), t("]") }),
        s("image", { t("image::"), i(1, "path.png"), t("["), i(2, "alt"), t("]") }),

        -- Tables
        s("table", { t({"|===", "| "}), i(1, "H1"), t(" | "), i(2, "H2"), t({"", "", "| "}), i(3), t(" | "), i(4), t({"", "|==="}) }),

        -- Lists
        s("ul", { t("* "), i(1) }),
        s("ol", { t(". "), i(1) }),
        s("dl", { i(1, "Term"), t(":: "), i(2, "Definition") }),
        s("check", { t("* ["), c(1, { t(" "), t("x") }), t("] "), i(2) }),

        -- Formatting
        s("bold", { t("*"), i(1), t("*") }),
        s("italic", { t("_"), i(1), t("_") }),
        s("mono", { t("`"), i(1), t("`") }),
        s("mark", { t("#"), i(1), t("#") }),

        -- Attributes
        s("attr", { t("{"), i(1, "attribute"), t("}") }),
        s("attrd", { t(":"), i(1, "attr"), t(": "), i(2, "value") }),

        -- Document header
        s("docheader", {
            t("= "), i(1, "Title"),
            t({"", ":description: "}), i(2, "Description"),
            t({"", ":navtitle: "}), i(3, "Nav"),
            t({"", ":icons: font", ""}),
        }),

        -- Date/time
        s("date", { f(function() return os.date("%Y-%m-%d") end) }),
        s("datetime", { f(function() return os.date("%Y-%m-%d %H:%M") end) }),

        -- Keyboard/UI
        s("kbd", { t("kbd:["), i(1, "Ctrl+C"), t("]") }),
        s("btn", { t("btn:["), i(1, "Submit"), t("]") }),
        s("menu", { t("menu:"), i(1, "File"), t("["), i(2, "Save"), t("]") }),

        -- Collapsible blocks
        s("collapse", { t({"."}), i(1, "Click to expand"), t({"", "[%collapsible]", "====", ""}), i(2), t({"", "===="}) }),
        s("collapseo", { t({"."}), i(1, "Click to expand"), t({"", "[%collapsible%open]", "====", ""}), i(2), t({"", "===="}) }),

        -- Sidebar block
        s("sidebar", { t({"."}), i(1, "Sidebar Title"), t({"", "****", ""}), i(2), t({"", "****"}) }),

        -- Quote block
        s("quote", { t({"[quote, "}), i(1, "Author"), t({", "}), i(2, "Source"), t({"]", "____", ""}), i(3), t({"", "____"}) }),

        -- Code callout block
        s("callout", { t({"[source,"}), i(1, "bash"), t({"]", "----", ""}), i(2, "command  <1>"), t({"", "----", ""}), t("<1> "), i(3, "Explanation") }),

        -- Table: AsciiDoc cell
        s("atable", { t({'[cols="'}), i(1, "1h,3a"), t({'"]', "|===", "| "}), i(2, "Header"), t(" | "), i(3, "Header"), t({"", "", "| "}), i(4), t({"", "| "}), i(5), t({"", "|==="}) }),

        -- CSV table
        s("csvtable", { t({"[%header,format=csv]", "|===", ""}), i(1, "Col1,Col2,Col3"), t({"", ""}), i(2, "a,b,c"), t({"", "|==="}) }),

        -- Description list (horizontal)
        s("dlh", { t({"[horizontal]", ""}), i(1, "Term"), t(":: "), i(2, "Definition") }),

        -- Q&A list
        s("qanda", { t({"[qanda]", ""}), i(1, "Question"), t({"::"}), t({"", ""}), i(2, "Answer") }),

        -- Discrete heading
        s("discrete", { t({"[discrete]", "==== "}), i(1, "Heading (not in TOC)") }),

        -- Lead paragraph
        s("lead", { t({"[.lead]", ""}), i(1, "Lead paragraph text") }),

        -- Footnote
        s("fn", { t("footnote:["), i(1, "Footnote text"), t("]") }),

        -- Counter
        s("counter", { t("{counter:"), i(1, "step"), t("}") }),

        -- Conditional (ifdef)
        s("ifdef", { t("ifdef::"), i(1, "attribute"), t({"[]", ""}), i(2), t({"", "endif::[]"}) }),

        -- Literal block
        s("literal", { t({"....", ""}), i(1), t({"", "...."}) }),
    })

    ls.filetype_extend("asciidoctor", { "asciidoc" })

    -- Set up navigation and commands
    M.navigation()
    M.commands()
end

-- ============================================================================
-- NAVIGATION KEYMAPS
-- ============================================================================

function M.navigation()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "asciidoc", "asciidoctor" },
        callback = function()
            local opts = { buffer = true, silent = true }
            local map = vim.keymap.set

            -- Block navigation
            map("n", "]-", function() vim.fn.search("^----", "W") end, vim.tbl_extend("force", opts, { desc = "Next ---- block" }))
            map("n", "[-", function() vim.fn.search("^----", "bW") end, vim.tbl_extend("force", opts, { desc = "Prev ---- block" }))
            map("n", "]=", function() vim.fn.search("^====", "W") end, vim.tbl_extend("force", opts, { desc = "Next ==== block" }))
            map("n", "[=", function() vim.fn.search("^====", "bW") end, vim.tbl_extend("force", opts, { desc = "Prev ==== block" }))
            map("n", "]]", function() vim.fn.search("^=\\+ ", "W") end, vim.tbl_extend("force", opts, { desc = "Next section" }))
            map("n", "[[", function() vim.fn.search("^=\\+ ", "bW") end, vim.tbl_extend("force", opts, { desc = "Prev section" }))

            -- Header insertion
            map("n", "<leader>a1", "I= <Esc>", vim.tbl_extend("force", opts, { desc = "H1" }))
            map("n", "<leader>a2", "I== <Esc>", vim.tbl_extend("force", opts, { desc = "H2" }))
            map("n", "<leader>a3", "I=== <Esc>", vim.tbl_extend("force", opts, { desc = "H3" }))
            map("n", "<leader>a4", "I==== <Esc>", vim.tbl_extend("force", opts, { desc = "H4" }))

            -- Formatting
            map("n", "<leader>ab", "viw<Esc>a*<Esc>bi*<Esc>", vim.tbl_extend("force", opts, { desc = "Bold word" }))
            map("v", "<leader>ab", "<Esc>`>a*<Esc>`<i*<Esc>", vim.tbl_extend("force", opts, { desc = "Bold selection" }))
            map("n", "<leader>ai", "viw<Esc>a_<Esc>bi_<Esc>", vim.tbl_extend("force", opts, { desc = "Italic word" }))
            map("v", "<leader>ai", "<Esc>`>a_<Esc>`<i_<Esc>", vim.tbl_extend("force", opts, { desc = "Italic selection" }))
            map("n", "<leader>ac", "viw<Esc>a`<Esc>bi`<Esc>", vim.tbl_extend("force", opts, { desc = "Monospace word" }))
            map("v", "<leader>ac", "<Esc>`>a`<Esc>`<i`<Esc>", vim.tbl_extend("force", opts, { desc = "Monospace selection" }))

            -- Lists
            map("n", "<leader>al", "I* <Esc>", vim.tbl_extend("force", opts, { desc = "Bullet list" }))
            map("n", "<leader>an", "I. <Esc>", vim.tbl_extend("force", opts, { desc = "Numbered list" }))
            map("n", "<leader>at", "I* [ ] <Esc>", vim.tbl_extend("force", opts, { desc = "Checklist" }))

            -- Admonitions
            map("n", "<leader>aN", "INOTE: <Esc>", vim.tbl_extend("force", opts, { desc = "NOTE:" }))
            map("n", "<leader>aT", "ITIP: <Esc>", vim.tbl_extend("force", opts, { desc = "TIP:" }))
            map("n", "<leader>aW", "IWARNING: <Esc>", vim.tbl_extend("force", opts, { desc = "WARNING:" }))

            -- Insert attribute braces
            map("i", "<C-a>", "{}<Left>", vim.tbl_extend("force", opts, { desc = "Insert {}" }))
        end,
    })
end

-- ============================================================================
-- COMMANDS
-- ============================================================================

function M.commands()
    -- Outline command
    vim.api.nvim_create_user_command("AsciidocOutline", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local outline = {}

        for i, line in ipairs(lines) do
            local level, title = line:match("^(=+)%s+(.+)$")
            if level and title then
                local indent = string.rep("  ", #level - 1)
                table.insert(outline, string.format("%s%d: %s %s", indent, i, level, title))
            end
        end

        if #outline == 0 then
            vim.notify("No headers found", vim.log.levels.WARN)
            return
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, outline)

        local width = math.min(80, vim.o.columns - 10)
        local height = math.min(#outline + 2, vim.o.lines - 10)

        local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = (vim.o.lines - height) / 2,
            col = (vim.o.columns - width) / 2,
            style = "minimal",
            border = "rounded",
            title = " Outline ",
            title_pos = "center",
        })

        vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<CR>", function()
            local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
            local line_text = outline[cursor_line]
            local line_num = tonumber(line_text:match("^%s*(%d+):"))
            if line_num then
                vim.api.nvim_win_close(win, true)
                vim.api.nvim_win_set_cursor(0, { line_num, 0 })
                vim.cmd("normal! zz")
            end
        end, { buffer = buf, silent = true })
    end, { desc = "Show AsciiDoc outline" })

    -- Attribute checker
    vim.api.nvim_create_user_command("AsciidocCheckAttrs", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local defined = {}
        local used = {}

        for i, line in ipairs(lines) do
            for attr in line:gmatch(":([%w%-_]+):") do
                defined[attr] = true
            end
            for attr in line:gmatch("{([%w%-_]+)}") do
                if not used[attr] then used[attr] = {} end
                table.insert(used[attr], i)
            end
        end

        local undefined = {}
        local builtins = { "nbsp", "zwsp", "apos", "quot", "ldquo", "rdquo", "deg", "plus", "amp", "lt", "gt" }
        for attr, lines_used in pairs(used) do
            if not defined[attr] and not vim.tbl_contains(builtins, attr) then
                table.insert(undefined, string.format("{%s} on lines: %s", attr, table.concat(lines_used, ", ")))
            end
        end

        if #undefined == 0 then
            vim.notify("All attributes defined", vim.log.levels.INFO)
        else
            vim.notify("Undefined:\n" .. table.concat(undefined, "\n"), vim.log.levels.WARN)
        end
    end, { desc = "Check undefined attributes" })
end

return M
