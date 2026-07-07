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

	-- Indent guides (with scope highlighting)
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		config = function()
			local hl = require("domus.core.highlights")
			local hooks = require("ibl.hooks")
			-- Re-derive on every ibl highlight setup (fires on ColorScheme) so the
			-- scope/indent guides follow the active theme.
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "IblScope", { fg = hl.fg("Function", "#89b4fa") })
				vim.api.nvim_set_hl(0, "IblIndent", { fg = hl.fg("NonText", "#313244") })
			end)
			require("ibl").setup({
				indent = { char = "│", highlight = "IblIndent" },
				scope = { enabled = true, show_start = false, show_end = false },
			})
		end,
	},

	-- Colorizer (inline color preview)
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPost",
		config = function()
			require("nvim-highlight-colors").setup({
				render = "virtual",
				virtual_symbol = "●",
				enable_tailwind = true,
			})
		end,
	},

	-- Headlines (beautiful markdown/asciidoc headers)
	{
		"lukas-reineke/headlines.nvim",
		ft = { "markdown", "asciidoc", "org" },
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			-- Headline1-6 / CodeBlock / Dash are defined (and refreshed on theme
			-- change) by domus.core.highlights. Ensure they exist before render.
			require("domus.core.highlights").apply()
			require("headlines").setup({
				markdown = {
					headline_highlights = {
						"Headline1",
						"Headline2",
						"Headline3",
						"Headline4",
						"Headline5",
						"Headline6",
					},
					codeblock_highlight = "CodeBlock",
					dash_highlight = "Dash",
					fat_headlines = false,
				},
				asciidoc = {
					headline_highlights = {
						"Headline1",
						"Headline2",
						"Headline3",
						"Headline4",
						"Headline5",
						"Headline6",
					},
					codeblock_highlight = "CodeBlock",
					fat_headlines = false,
				},
			})
		end,
	},

	-- Window separators
	{
		"nvim-zh/colorful-winsep.nvim",
		event = "WinNew",
		config = function()
			require("colorful-winsep").setup({
				hi = { fg = require("domus.core.highlights").fg("Function", "#89b4fa") },
				smooth = true,
				exponential_smoothing = true,
				anchor = {
					left = { height = 1, x = -1, y = -1 },
					right = { height = 1, x = -1, y = 0 },
					up = { width = 0, x = -1, y = 0 },
					bottom = { width = 0, x = 1, y = 0 },
				},
				symbols = { "─", "│", "┌", "┐", "└", "┘" },
			})
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

	-- Messages/cmdline: native Neovim handling (noice + nui + nvim-notify removed —
	-- messages were already disabled; fidget covers LSP progress).

	-- Dashboard (minimal, clean)
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Header
			dashboard.section.header.val = {
				"",
				"  domus nvim",
				"",
			}
			dashboard.section.header.opts.hl = "AlphaHeader"

			-- Buttons
			dashboard.section.buttons.val = {
				dashboard.button("f", "  find file", ":Telescope find_files<CR>"),
				dashboard.button("g", "  grep", ":Telescope live_grep<CR>"),
				dashboard.button("r", "  recent", ":Telescope oldfiles<CR>"),
				dashboard.button("e", "  new", ":ene<CR>"),
				dashboard.button("q", "  quit", ":qa<CR>"),
			}

			for _, btn in ipairs(dashboard.section.buttons.val) do
				btn.opts.hl = "AlphaButtons"
				btn.opts.hl_shortcut = "AlphaShortcut"
			end

			-- Footer
			dashboard.section.footer.val = ""
			dashboard.section.footer.opts.hl = "AlphaFooter"

			-- Layout
			dashboard.config.layout = {
				{ type = "padding", val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }) },
				dashboard.section.header,
				{ type = "padding", val = 2 },
				dashboard.section.buttons,
				{ type = "padding", val = 1 },
				dashboard.section.footer,
			}

			-- Alpha* highlight groups are theme-derived and refreshed on
			-- ColorScheme by domus.core.highlights; ensure they exist now.
			require("domus.core.highlights").apply()

			alpha.setup(dashboard.config)

			-- Hide statusline on dashboard
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					vim.opt.laststatus = 0
				end,
			})
			vim.api.nvim_create_autocmd("BufUnload", {
				buffer = 0,
				callback = function()
					vim.opt.laststatus = 3
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
