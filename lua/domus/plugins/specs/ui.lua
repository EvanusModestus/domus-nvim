-- UI Specs
-- Visual plugins: colorscheme, statusline, icons

return {
    -- Rose Pine (primary colorscheme)
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("domus.plugins.config.colorscheme").setup()
        end,
    },

    -- Alternative colorschemes (lazy loaded)
    { "catppuccin/nvim", name = "catppuccin", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    { "sainnhe/gruvbox-material", lazy = true },
    { "shaunsingh/nord.nvim", lazy = true },

    -- Icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("domus.plugins.config.lualine").setup()
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPost",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope = { enabled = false },
            })
        end,
    },

    -- Colorizer (hex colors)
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPost",
        config = function()
            require("colorizer").setup()
        end,
    },

    -- Zen mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen mode" },
        },
    },

    -- Better UI for vim.ui.select and vim.ui.input
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            require("dressing").setup({
                select = { enabled = true, backend = { "telescope", "builtin" } },
                input = { enabled = true, default_prompt = "> " },
            })
        end,
    },

    -- LSP progress indicator
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        config = function()
            require("fidget").setup({
                notification = { window = { winblend = 0 } },
            })
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("domus.plugins.config.which-key").setup()
        end,
    },

    -- Motion visualization (teaching/presentations)
    {
        "NStefan002/screenkey.nvim",
        cmd = "Screenkey",
        version = "*",
        config = function()
            require("screenkey").setup({
                win_opts = { relative = "editor", anchor = "SE", width = 40, height = 3, border = "rounded" },
            })
        end,
    },

    -- Cursor animation
    {
        "echasnovski/mini.animate",
        event = "VeryLazy",
        config = function()
            local animate = require("mini.animate")
            animate.setup({
                cursor = { enable = true, timing = animate.gen_timing.linear({ duration = 50, unit = "total" }) },
                scroll = { enable = false },
                resize = { enable = false },
                open = { enable = false },
                close = { enable = false },
            })
        end,
    },
}
