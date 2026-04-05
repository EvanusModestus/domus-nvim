-- Which-Key Configuration

local M = {}

function M.setup()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end

    wk.setup({
        plugins = {
            marks = true,
            registers = true,
            spelling = { enabled = true },
        },
        win = {
            border = "rounded",
        },
    })

    -- Register key groups and sub-keys
    wk.add({
        -- Find (Telescope) — telescope.lua
        { "<leader>f", group = "Find" },
        { "<leader>ff", desc = "Files" },
        { "<leader>fg", desc = "Grep" },
        { "<leader>fb", desc = "Buffers" },
        { "<leader>fh", desc = "Help" },
        { "<leader>fo", desc = "Old files" },
        { "<leader>fr", desc = "Resume" },
        { "<leader>fw", desc = "Word" },
        { "<leader>fd", desc = "Diagnostics" },
        { "<leader>fc", desc = "Commands" },
        { "<leader>fk", desc = "Keymaps" },
        { "<leader>fe", desc = "File browser" },
        { "<leader>fp", desc = "Projects" },
        { "<leader>fu", desc = "Undo tree" },
        { "<leader>ft", desc = "Todos" },

        -- Git — git.lua, telescope.lua
        { "<leader>g", group = "Git" },
        { "<leader>gs", desc = "Status (fugitive)" },
        { "<leader>gp", desc = "Push" },
        { "<leader>gc", desc = "Commits" },
        { "<leader>gb", desc = "Branches" },
        { "<leader>gd", desc = "Diffview" },
        { "<leader>gh", desc = "File history" },

        -- Hunks — gitsigns on_attach
        { "<leader>h", group = "Hunk" },
        { "<leader>hs", desc = "Stage" },
        { "<leader>hr", desc = "Reset" },
        { "<leader>hS", desc = "Stage buffer" },
        { "<leader>hu", desc = "Undo stage" },
        { "<leader>hR", desc = "Reset buffer" },
        { "<leader>hp", desc = "Preview" },
        { "<leader>hb", desc = "Blame line" },
        { "<leader>hd", desc = "Diff" },

        -- LSP — telescope.lua, lsp/init.lua
        { "<leader>l", group = "LSP" },
        { "<leader>lr", desc = "References" },
        { "<leader>ls", desc = "Symbols" },
        { "<leader>lw", desc = "Workspace symbols" },

        -- Code — conform.lua, lsp/init.lua
        { "<leader>c", group = "Code" },
        { "<leader>ca", desc = "Action" },
        { "<leader>cf", desc = "Format" },

        -- Debug — debug.lua
        { "<leader>d", group = "Debug" },

        -- Terminal — tools.lua
        { "<leader>t", group = "Terminal" },
        { "<leader>tt", desc = "Toggle" },
        { "<leader>tf", desc = "Float" },
        { "<leader>th", desc = "Horizontal" },
        { "<leader>tv", desc = "Vertical" },

        -- Vim/LSP diagnostics — lsp/init.lua
        { "<leader>v", group = "Vim/LSP" },
        { "<leader>vd", desc = "Diagnostic float" },

        -- JavaScript — keymaps.lua
        { "<leader>j", group = "JavaScript" },
        { "<leader>jd", desc = "npm dev" },
        { "<leader>js", desc = "npm start" },
        { "<leader>ji", desc = "npm install" },
        { "<leader>jb", desc = "npm build" },

        -- AsciiDoc — lang/asciidoc.lua (buffer-local, ft=asciidoc)
        { "<leader>a", group = "AsciiDoc" },

        -- Standalone keys
        { "<leader>rn", desc = "Rename symbol" },
        { "<leader>re", desc = "Refactor" },
        { "<leader>ih", desc = "Inlay hints toggle" },
        { "<leader>u", desc = "Undotree" },
        { "<leader>z", desc = "Zen mode" },
        { "<leader>lg", desc = "LazyGit" },
    })
end

return M
