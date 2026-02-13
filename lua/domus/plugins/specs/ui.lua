-- UI Specs
-- Visual plugins: colorscheme, statusline, icons

return {
    -- Catppuccin (primary colorscheme)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("domus.plugins.config.colorscheme").setup()
        end,
    },

    -- Alternative colorschemes (lazy loaded)
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    { "sainnhe/gruvbox-material", lazy = true },
    { "EdenEast/nightfox.nvim", lazy = true },

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

    -- Noice (command line, messages, popupmenu)
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    signature = { enabled = false }, -- using lsp_signature
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = true,
                },
                routes = {
                    -- Skip "written" messages
                    { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
                    -- Skip search count messages
                    { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
                },
                views = {
                    cmdline_popup = {
                        position = { row = "40%", col = "50%" },
                        size = { width = 60, height = "auto" },
                        border = { style = "rounded", padding = { 0, 1 } },
                    },
                    popupmenu = {
                        relative = "editor",
                        position = { row = "45%", col = "50%" },
                        size = { width = 60, height = 10 },
                        border = { style = "rounded", padding = { 0, 1 } },
                    },
                },
            })
            -- Notifications theme
            require("notify").setup({
                background_colour = "#1e1e2e",
                fps = 60,
                render = "compact",
                stages = "fade",
                timeout = 3000,
                top_down = true,
            })
        end,
    },

    -- Better UI for vim.ui.select and vim.ui.input (fallback)
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            require("dressing").setup({
                select = { enabled = false }, -- noice handles this
                input = { enabled = true, default_prompt = "> " },
            })
        end,
    },

    -- Dashboard
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                     ",
                "          D O M U S   I N S T R U M E N T U M        ",
                "                                                     ",
            }
            dashboard.section.header.opts.hl = "AlphaHeader"

            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
                dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
                dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
                dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
                dashboard.button("c", "  Config", ":e ~/.config/nvim-domus/lua/domus/init.lua<CR>"),
                dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }

            dashboard.section.footer.val = "Hierarchical. Modular. Documented."
            dashboard.section.footer.opts.hl = "AlphaFooter"

            -- Custom highlights
            vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#cba6f7" }) -- mauve
            vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6c7086", italic = true }) -- overlay0

            alpha.setup(dashboard.opts)

            -- Disable statusline on dashboard
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    vim.opt.laststatus = 0
                    vim.opt.showtabline = 0
                end,
            })
            vim.api.nvim_create_autocmd("BufUnload", {
                buffer = 0,
                callback = function()
                    vim.opt.laststatus = 3
                    vim.opt.showtabline = 2
                end,
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
