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
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                condition = function(bufnr)
                    -- Disable for vim: treesitter produces nil nodes in
                    -- regex-heavy syntax files, crashing local strategy
                    if vim.bo[bufnr].ft == "vim" then return false end
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
                -- Derive from the theme's parameter color instead of a fixed hex
                color = require("domus.core.highlights").fg("@variable.parameter", "#f2cdcd"),
                paint_arg_declarations = true,
                paint_arg_usages = true,
            })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        -- Pin master: this config uses the legacy `nvim-treesitter.configs` API,
        -- which the default `main` branch (the rewrite) deleted. Without this pin
        -- setup() errors silently (swallowed by pcall) and highlighting/textobjects
        -- are inert. See docs appendix-issues #1.
        branch = "master",
        priority = 1000,
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("domus.plugins.config.treesitter").setup()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "master", -- match nvim-treesitter (legacy API)
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        -- Disabled: the latest release (can't update further) crashes on
        -- Neovim 0.12's core treesitter API — `languagetree.lua: attempt to
        -- call method 'range' (a nil value)` during injection parse, on every
        -- cursor move. Re-enable once upstream ships a 0.12-compatible fix.
        enabled = false,
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

    -- Commenting: Neovim 0.10+ ships native gc/gcc/gbc mappings, no plugin needed.

    -- Surround (mini.ai for text objects)
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        config = function()
            require("domus.plugins.config.mini-ai").setup()
        end,
    },

    -- Illuminate (highlight word under cursor)
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        config = function()
            require("illuminate").configure({
                -- Drop the "treesitter" provider: it calls nvim-treesitter.locals,
                -- which errors ("attempt to call method 'parent' (a nil value)")
                -- on the frozen master branch this config pins. LSP document-
                -- highlight + regex cover word-under-cursor with no crash.
                providers = { "lsp", "regex" },
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

    -- Surround (add/delete/replace surroundings)
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({})
        end,
    },

    -- Flash (labeled jumps and treesitter selection)
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
        },
        opts = {},
    },
}
