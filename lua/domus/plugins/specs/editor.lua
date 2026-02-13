-- Editor Specs
-- Core editing plugins: treesitter, autopairs, comment, etc.

return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        priority = 1000,
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("domus.plugins.config.treesitter").setup()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
                disable_filetype = { "TelescopePrompt", "vim" },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "javascript", "typescript", "jsx", "tsx", "vue", "svelte", "xml", "markdown" },
    },

    -- Comment
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("Comment").setup()
        end,
    },

    -- Surround (mini.ai for text objects)
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        config = function()
            require("domus.plugins.config.mini-ai").setup()
        end,
    },

    -- Highlighted yank
    {
        "machakann/vim-highlightedyank",
        event = "TextYankPost",
        config = function()
            vim.g.highlightedyank_highlight_duration = 200
        end,
    },

    -- Illuminate (highlight word under cursor)
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        config = function()
            require("illuminate").configure({
                delay = 200,
                large_file_cutoff = 2000,
            })
        end,
    },

    -- Folding
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "BufReadPost",
        config = function()
            require("domus.plugins.config.ufo").setup()
        end,
    },

    -- Undotree
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
        },
    },
}
