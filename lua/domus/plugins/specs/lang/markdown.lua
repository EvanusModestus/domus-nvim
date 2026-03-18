-- Markdown Language Specs

return {
	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		config = function()
			local is_wsl = vim.fn.system("uname -r"):match("[Mm]icrosoft") ~= nil
			vim.g.mkdp_browser = is_wsl and "wsl-open" or "firefox"
		end,
	},

	-- Glow (terminal markdown viewer)
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		config = true,
	},

	-- vim-markdown
	{
		"preservim/vim-markdown",
		ft = "markdown",
		config = function()
			vim.g.vim_markdown_folding_disabled = 1
			vim.g.vim_markdown_conceal = 0
			vim.g.vim_markdown_frontmatter = 1
		end,
	},

	-- Bullets (auto lists)
	{
		"bullets-vim/bullets.vim",
		ft = { "markdown", "text" },
		config = function()
			vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
			vim.g.bullets_set_mappings = 1
			vim.g.bullets_enable_in_empty_buffers = 0
			vim.g.bullets_renumber_on_change = 1
			vim.g.bullets_checkbox_markers = " .oOX"
		end,
	},

	-- Table mode
	{
		"dhruvasagar/vim-table-mode",
		ft = "markdown",
		config = function()
			vim.g.table_mode_corner = "|"
			vim.g.table_mode_header_fillchar = "-"
			vim.g.table_mode_map_prefix = "<Leader>t"
			vim.g.table_mode_toggle_map = "m"
			vim.g.table_mode_auto_align = 1
		end,
	},

	-- Obsidian integration
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		cond = vim.fn.isdirectory("/data/data/com.termux") == 0, -- disable on Termux
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{ name = "Aethelred-Codex", path = "~/.Aethelred-Codex" },
			},
			completion = { nvim_cmp = false, min_chars = 2 },
			disable_frontmatter = true,
		},
	},
}
