-- Colorscheme Configuration
-- Catppuccin Mocha with full integrations

local M = {}

function M.setup()
	local ok, catppuccin = pcall(require, "catppuccin")
	if not ok then
		return
	end

	catppuccin.setup({
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		background = {
			light = "latte",
			dark = "mocha",
		},
		transparent_background = false,
		show_end_of_buffer = false,
		term_colors = true,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		no_italic = false,
		no_bold = false,
		no_underline = false,
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = { "bold" },
			keywords = { "italic" },
			strings = {},
			variables = {},
			numbers = {},
			booleans = { "bold" },
			properties = {},
			types = { "bold" },
			operators = {},
			miscs = {},
		},
		color_overrides = {
			mocha = {
				-- Refined palette for better blending
				base = "#1a1a26", -- Slightly deeper, more blue-tinted
				mantle = "#151520", -- Darker mantle
				crust = "#0f0f17", -- Deep crust
				surface0 = "#242435", -- Lifted surface
				surface1 = "#2e2e42", -- More visible surface
				surface2 = "#3a3a50", -- Even more visible
				overlay0 = "#5a5a72", -- Softer overlay
				overlay1 = "#6e6e88",
				overlay2 = "#82829e",
				blue = "#7aa2f7", -- Softer, more blended blue (tokyo-night inspired)
				sapphire = "#5eacd3", -- Cyan-tinted sapphire
				lavender = "#b4befe", -- Softer lavender
				sky = "#7dcfff", -- Bright sky
			},
		},
		custom_highlights = function(colors)
			return {
				-- Cursor and line highlights
				CursorLine = { bg = colors.surface0 },
				CursorLineNr = { fg = colors.mauve, bold = true },
				LineNr = { fg = colors.overlay0 },

				-- Visual selection
				Visual = {
					bg = "#454025",
					bold = true,
					-- fg = colors.text,
				},

				-- Search highlights
				Search = { bg = colors.yellow, fg = colors.base },
				IncSearch = { bg = colors.peach, fg = colors.base },

				-- Matching parens
				MatchParen = { fg = colors.peach, bg = colors.surface1, bold = true },

				-- Floating windows
				NormalFloat = { bg = colors.mantle },
				FloatBorder = { fg = colors.mauve, bg = colors.mantle },

				-- Telescope
				TelescopeBorder = { fg = colors.mauve },
				TelescopePromptBorder = { fg = colors.mauve },
				TelescopeResultsBorder = { fg = colors.surface0 },
				TelescopePreviewBorder = { fg = colors.surface0 },
				TelescopePromptTitle = { fg = colors.base, bg = colors.mauve, bold = true },
				TelescopeResultsTitle = { fg = colors.base, bg = colors.green, bold = true },
				TelescopePreviewTitle = { fg = colors.base, bg = colors.blue, bold = true },
				TelescopeSelection = { bg = colors.surface0, bold = true },

				-- Git signs
				GitSignsAdd = { fg = colors.green },
				GitSignsChange = { fg = colors.yellow },
				GitSignsDelete = { fg = colors.red },

				-- Diagnostics
				DiagnosticVirtualTextError = { fg = colors.red, bg = colors.surface0, italic = true },
				DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.surface0, italic = true },
				DiagnosticVirtualTextInfo = { fg = colors.sky, bg = colors.surface0, italic = true },
				DiagnosticVirtualTextHint = { fg = colors.teal, bg = colors.surface0, italic = true },

				-- Indent guides
				IblIndent = { fg = colors.surface0 },
				IblScope = { fg = colors.mauve },

				-- Treesitter context
				TreesitterContext = { bg = colors.mantle },

				-- LSP
				LspReferenceText = { bg = colors.surface1 },
				LspReferenceRead = { bg = colors.surface1 },
				LspReferenceWrite = { bg = colors.surface1 },

				-- Which-key
				WhichKey = { fg = colors.mauve },
				WhichKeyGroup = { fg = colors.blue },
				WhichKeyDesc = { fg = colors.text },
				WhichKeySeparator = { fg = colors.overlay0 },

				-- Mini.animate cursor
				MiniAnimateCursor = { bg = colors.mauve, blend = 0 },

				-- Rainbow delimiters (vibrant bracket colors)
				RainbowDelimiterRed = { fg = colors.red },
				RainbowDelimiterYellow = { fg = colors.yellow },
				RainbowDelimiterBlue = { fg = colors.blue },
				RainbowDelimiterOrange = { fg = colors.peach },
				RainbowDelimiterGreen = { fg = colors.green },
				RainbowDelimiterViolet = { fg = colors.mauve },
				RainbowDelimiterCyan = { fg = colors.teal },

				-- Illuminate (word under cursor)
				IlluminatedWordText = { bg = colors.surface1 },
				IlluminatedWordRead = { bg = colors.surface1 },
				IlluminatedWordWrite = { bg = colors.surface1, underline = true },

				-- Syntax enhancements (vibrant, distinct colors)
				["@variable"] = { fg = colors.text },
				["@variable.builtin"] = { fg = colors.red, italic = true },
				["@variable.parameter"] = { fg = colors.flamingo, italic = true },
				["@variable.member"] = { fg = colors.rosewater },
				["@constant"] = { fg = colors.peach, bold = true },
				["@constant.builtin"] = { fg = colors.peach, bold = true, italic = true },
				["@module"] = { fg = colors.lavender, italic = true },
				["@label"] = { fg = colors.sapphire, bold = true },
				["@string"] = { fg = colors.green },
				["@string.documentation"] = { fg = colors.teal, italic = true },
				["@string.regexp"] = { fg = colors.pink, bold = true },
				["@string.escape"] = { fg = colors.pink, bold = true },
				["@string.special"] = { fg = colors.pink },
				["@string.special.url"] = { fg = colors.sky, underline = true },
				["@character"] = { fg = colors.teal },
				["@character.special"] = { fg = colors.pink },
				["@boolean"] = { fg = colors.peach, bold = true, italic = true },
				["@number"] = { fg = colors.peach },
				["@number.float"] = { fg = colors.peach },
				["@type"] = { fg = colors.yellow, bold = true },
				["@type.builtin"] = { fg = colors.yellow, bold = true, italic = true },
				["@type.definition"] = { fg = colors.yellow, bold = true },
				["@type.qualifier"] = { fg = colors.mauve, italic = true },
				["@attribute"] = { fg = colors.teal },
				["@attribute.builtin"] = { fg = colors.teal, italic = true },
				["@property"] = { fg = colors.lavender },
				["@function"] = { fg = colors.blue, bold = true },
				["@function.builtin"] = { fg = colors.sapphire, bold = true, italic = true },
				["@function.call"] = { fg = colors.blue },
				["@function.macro"] = { fg = colors.teal, bold = true },
				["@function.method"] = { fg = colors.blue, bold = true },
				["@function.method.call"] = { fg = colors.blue },
				["@constructor"] = { fg = colors.sapphire, bold = true },
				["@operator"] = { fg = colors.sky, bold = true },
				["@keyword"] = { fg = colors.mauve, italic = true },
				["@keyword.coroutine"] = { fg = colors.mauve, bold = true, italic = true },
				["@keyword.function"] = { fg = colors.mauve, italic = true },
				["@keyword.operator"] = { fg = colors.mauve, bold = true },
				["@keyword.import"] = { fg = colors.pink, italic = true },
				["@keyword.type"] = { fg = colors.mauve, italic = true },
				["@keyword.modifier"] = { fg = colors.mauve, italic = true },
				["@keyword.repeat"] = { fg = colors.mauve, italic = true },
				["@keyword.return"] = { fg = colors.pink, italic = true, bold = true },
				["@keyword.exception"] = { fg = colors.maroon, italic = true, bold = true },
				["@keyword.conditional"] = { fg = colors.mauve, italic = true },
				["@keyword.conditional.ternary"] = { fg = colors.mauve },
				["@punctuation.delimiter"] = { fg = colors.overlay2 },
				["@punctuation.bracket"] = { fg = colors.subtext0 },
				["@punctuation.special"] = { fg = colors.sky, bold = true },
				["@comment"] = { fg = colors.overlay1, italic = true },
				["@comment.documentation"] = { fg = colors.overlay2, italic = true },
				["@comment.error"] = { fg = colors.base, bg = colors.red, bold = true },
				["@comment.warning"] = { fg = colors.base, bg = colors.yellow, bold = true },
				["@comment.todo"] = { fg = colors.base, bg = colors.blue, bold = true },
				["@comment.note"] = { fg = colors.base, bg = colors.teal, bold = true },
				["@tag"] = { fg = colors.mauve, bold = true },
				["@tag.builtin"] = { fg = colors.mauve, bold = true },
				["@tag.attribute"] = { fg = colors.teal, italic = true },
				["@tag.delimiter"] = { fg = colors.sky },

				-- Markup (markdown, asciidoc)
				["@markup.heading"] = { fg = colors.blue, bold = true },
				["@markup.heading.1"] = { fg = colors.red, bold = true },
				["@markup.heading.2"] = { fg = colors.peach, bold = true },
				["@markup.heading.3"] = { fg = colors.yellow, bold = true },
				["@markup.heading.4"] = { fg = colors.green, bold = true },
				["@markup.heading.5"] = { fg = colors.sapphire, bold = true },
				["@markup.heading.6"] = { fg = colors.lavender, bold = true },
				["@markup.quote"] = { fg = colors.overlay1, italic = true },
				["@markup.strong"] = { fg = colors.text, bold = true },
				["@markup.italic"] = { fg = colors.text, italic = true },
				["@markup.strikethrough"] = { fg = colors.overlay0, strikethrough = true },
				["@markup.underline"] = { underline = true },
				["@markup.link"] = { fg = colors.blue },
				["@markup.link.label"] = { fg = colors.sapphire, underline = true },
				["@markup.link.url"] = { fg = colors.sky, underline = true },
				["@markup.raw"] = { fg = colors.rosewater },
				["@markup.raw.block"] = { fg = colors.text },
				["@markup.list"] = { fg = colors.mauve, bold = true },
				["@markup.list.checked"] = { fg = colors.green },
				["@markup.list.unchecked"] = { fg = colors.overlay1 },

				-- Diff
				["@diff.plus"] = { fg = colors.green },
				["@diff.minus"] = { fg = colors.red },
				["@diff.delta"] = { fg = colors.yellow },
			}
		end,
		integrations = {
			cmp = false,
			blink_cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			treesitter_context = true,
			telescope = { enabled = true },
			indent_blankline = { enabled = true, colored_indent_levels = false },
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
				inlay_hints = { background = true },
			},
			dap = true,
			dap_ui = true,
			fidget = true,
			harpoon = true,
			lsp_trouble = true,
			mason = true,
			mini = { enabled = true },
			notify = true,
			rainbow_delimiters = true,
			semantic_tokens = true,
			which_key = true,
			illuminate = { enabled = true, lsp = false },
			headlines = true,
			flash = true,
		},
	})

	vim.cmd.colorscheme("catppuccin")
end

return M
