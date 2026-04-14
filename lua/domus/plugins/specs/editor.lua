-- Editor Specs
-- Core editing plugins: treesitter, autopairs, comment, etc.

return {
    -- Rainbow delimiters (colored brackets)
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "BufReadPost",
        init = function()
            -- Set before plugin loads to prevent nil parser crash (Neovim 0.11+)
            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = "rainbow-delimiters.strategy.global",
                    vim = "rainbow-delimiters.strategy.local",
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                condition = function(bufnr)
                    local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].ft)
                    if not lang then return false end
                    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
                    return ok and parser ~= nil
                end,
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterCyan",
                },
            }
        end,
    },

    -- Todo comments (highlight TODO, FIXME, etc)
    {
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
            { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find todos" },
        },
        config = function()
            require("todo-comments").setup({
                signs = true,
                keywords = {
                    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                },
            })
        end,
    },

    -- Highlight function arguments
    {
        "m-demare/hlargs.nvim",
        event = "BufReadPost",
        config = function()
            require("hlargs").setup({
                color = "#f2cdcd", -- flamingo
                paint_arg_declarations = true,
                paint_arg_usages = true,
            })
        end,
    },

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
