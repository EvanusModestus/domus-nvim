-- Colorscheme Configuration
-- Catppuccin Mocha with full integrations

local M = {}

function M.setup()
    local ok, catppuccin = pcall(require, "catppuccin")
    if not ok then return end

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
                -- Slightly warmer background
                base = "#1e1e2e",
                mantle = "#181825",
                crust = "#11111b",
            },
        },
        custom_highlights = function(colors)
            return {
                -- Cursor and line highlights
                CursorLine = { bg = colors.surface0 },
                CursorLineNr = { fg = colors.mauve, bold = true },
                LineNr = { fg = colors.overlay0 },

                -- Visual selection
                Visual = { bg = colors.surface1, bold = true },

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

                -- Syntax enhancements
                ["@variable"] = { fg = colors.text },
                ["@variable.builtin"] = { fg = colors.red, italic = true },
                ["@variable.parameter"] = { fg = colors.maroon, italic = true },
                ["@variable.member"] = { fg = colors.lavender },
                ["@constant"] = { fg = colors.peach },
                ["@constant.builtin"] = { fg = colors.peach, bold = true },
                ["@module"] = { fg = colors.blue, italic = true },
                ["@label"] = { fg = colors.sapphire },
                ["@string"] = { fg = colors.green },
                ["@string.documentation"] = { fg = colors.green, italic = true },
                ["@string.regexp"] = { fg = colors.pink },
                ["@string.escape"] = { fg = colors.pink, bold = true },
                ["@character"] = { fg = colors.teal },
                ["@boolean"] = { fg = colors.peach, bold = true },
                ["@number"] = { fg = colors.peach },
                ["@number.float"] = { fg = colors.peach },
                ["@type"] = { fg = colors.yellow, bold = true },
                ["@type.builtin"] = { fg = colors.yellow, bold = true, italic = true },
                ["@type.definition"] = { fg = colors.yellow },
                ["@attribute"] = { fg = colors.blue },
                ["@property"] = { fg = colors.lavender },
                ["@function"] = { fg = colors.blue, bold = true },
                ["@function.builtin"] = { fg = colors.blue, bold = true, italic = true },
                ["@function.call"] = { fg = colors.blue },
                ["@function.macro"] = { fg = colors.teal },
                ["@function.method"] = { fg = colors.blue },
                ["@function.method.call"] = { fg = colors.blue },
                ["@constructor"] = { fg = colors.sapphire },
                ["@operator"] = { fg = colors.sky },
                ["@keyword"] = { fg = colors.mauve, italic = true },
                ["@keyword.coroutine"] = { fg = colors.mauve, bold = true },
                ["@keyword.function"] = { fg = colors.mauve, italic = true },
                ["@keyword.operator"] = { fg = colors.mauve },
                ["@keyword.import"] = { fg = colors.mauve, italic = true },
                ["@keyword.repeat"] = { fg = colors.mauve, italic = true },
                ["@keyword.return"] = { fg = colors.mauve, italic = true },
                ["@keyword.exception"] = { fg = colors.mauve, italic = true },
                ["@keyword.conditional"] = { fg = colors.mauve, italic = true },
                ["@punctuation.delimiter"] = { fg = colors.overlay2 },
                ["@punctuation.bracket"] = { fg = colors.overlay2 },
                ["@punctuation.special"] = { fg = colors.sky },
                ["@comment"] = { fg = colors.overlay0, italic = true },
                ["@comment.documentation"] = { fg = colors.overlay1, italic = true },
                ["@comment.error"] = { fg = colors.red, bg = colors.surface0, bold = true },
                ["@comment.warning"] = { fg = colors.yellow, bg = colors.surface0, bold = true },
                ["@comment.todo"] = { fg = colors.blue, bg = colors.surface0, bold = true },
                ["@comment.note"] = { fg = colors.teal, bg = colors.surface0, bold = true },
                ["@tag"] = { fg = colors.mauve },
                ["@tag.attribute"] = { fg = colors.teal, italic = true },
                ["@tag.delimiter"] = { fg = colors.overlay2 },
            }
        end,
        integrations = {
            cmp = true,
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
            semantic_tokens = true,
            which_key = true,
        },
    })

    vim.cmd.colorscheme("catppuccin")
end

return M
