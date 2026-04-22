-- Tools Specs
-- Navigation and productivity tools

return {
    -- Plenary (dependency for many plugins)
    { "nvim-lua/plenary.nvim", lazy = true },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        lazy = false,
        priority = 900,
        config = function()
            require("domus.plugins.config.telescope").setup()
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = true,
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    {
        "nvim-telescope/telescope-project.nvim",
        lazy = true,
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    {
        "debugloop/telescope-undo.nvim",
        lazy = true,
        dependencies = { "nvim-telescope/telescope.nvim" },
    },

    -- Harpoon (quick file switching)
    {
        "theprimeagen/harpoon",
        keys = {
            { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon add" },
            { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon 1" },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon 2" },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon 3" },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon 4" },
        },
        config = function()
            require("harpoon").setup({
                menu = { width = math.max(40, vim.api.nvim_win_get_width(0) - 20) },
            })
        end,
    },

    -- Oil (file browser)
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Oil file browser" },
            { "<leader>e", "<cmd>Oil<CR>", desc = "Oil file browser" },
        },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                view_options = { show_hidden = false },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                },
            })
        end,
    },

    -- Toggleterm
    {
        "akinsho/toggleterm.nvim",
        keys = {
            { "<C-\\>", desc = "Toggle terminal" },
            { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
            { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
            { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Vertical terminal" },
        },
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                open_mapping = [[<C-\>]],
                direction = "float",
                float_opts = { border = "rounded" },
            })
        end,
    },

    -- Session management
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Downloads", "/tmp" },
                bypass_session_save_file_types = { "alpha", "dashboard", "neo-tree" },
            })
        end,
    },

    -- Vim skill games
    { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
    { "vuciv/golf", cmd = { "Golf", "GolfToday" } },
}
