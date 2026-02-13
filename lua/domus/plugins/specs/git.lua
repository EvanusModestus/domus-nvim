-- Git Specs
-- Git integration plugins

return {
    -- Fugitive (Git commands)
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
        keys = {
            { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
            { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
        },
    },

    -- Gitsigns (git decorations)
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(function() gs.next_hunk() end)
                        return "<Ignore>"
                    end, "Next hunk")
                    map("n", "[c", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(function() gs.prev_hunk() end)
                        return "<Ignore>"
                    end, "Previous hunk")

                    -- Actions
                    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
                    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
                    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                    map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                    map("n", "<leader>hd", gs.diffthis, "Diff this")
                end,
            })
        end,
    },

    -- LazyGit
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        keys = {
            { "<leader>lg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Diffview
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
        },
        config = function()
            require("diffview").setup({
                use_icons = true,
            })
        end,
    },
}
