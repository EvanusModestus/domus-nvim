-- Git Specs
-- Git integration plugins

return {
    -- Git front-end: lazygit (below) + gitsigns (hunks) + diffview (diffs/history).
    -- vim-fugitive was removed — its status/push role is covered by lazygit.

    -- Gitsigns (git decorations)
    {
        "lewis6991/gitsigns.nvim",
        event = "User FilePost",
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
                    local gs = require("gitsigns")
                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end

                    -- Navigation (expr = true so return values are processed)
                    vim.keymap.set("n", "]c", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(function() gs.nav_hunk("next") end)
                        return "<Ignore>"
                    end, { buffer = bufnr, expr = true, desc = "Next hunk" })
                    vim.keymap.set("n", "[c", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(function() gs.nav_hunk("prev") end)
                        return "<Ignore>"
                    end, { buffer = bufnr, expr = true, desc = "Previous hunk" })

                    -- Actions
                    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
                    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
                    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                    map("n", "<leader>hu", gs.stage_hunk, "Undo stage hunk (toggle)")
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
