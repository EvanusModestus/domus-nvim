-- Coding Specs
-- LSP, completion, snippets, formatting, linting

return {
    -- Mason (LSP/tool installer)
    {
        "williamboman/mason.nvim",
        lazy = false,
        priority = 100,
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        priority = 99,
        dependencies = { "williamboman/mason.nvim" },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        priority = 98,
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("domus.plugins.config.mason-tools").setup()
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        priority = 97,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("domus.plugins.config.lsp").setup()
        end,
    },

    -- Lazydev (Lua dev for Neovim)
    {
        "folke/lazydev.nvim",
        lazy = false,
        priority = 97,
        dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
        config = function()
            require("lazydev").setup({
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            })
        end,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Hand-written snippet libraries (single source of truth)
            require("domus.snippets.c")(require("luasnip"))
        end,
    },

    -- Completion (blink.cmp)
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "1.*",  -- Track latest v1.x (prebuilt binaries); v0.14.2 lacked the buffer word-cache
        dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
        config = function()
            require("domus.plugins.config.completion.blink").setup()
        end,
    },

    -- Formatting (conform.nvim)
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("domus.plugins.config.conform").setup()
        end,
    },

    -- Linting (nvim-lint)
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("domus.plugins.config.lint").setup()
        end,
    },

    -- Glance (LSP peek)
    {
        "dnlhc/glance.nvim",
        cmd = "Glance",
        keys = {
            { "gP", "<cmd>Glance definitions<CR>", desc = "Glance peek definitions" },
            { "gR", "<cmd>Glance references<CR>", desc = "Glance references" },
            { "gY", "<cmd>Glance type_definitions<CR>", desc = "Glance types" },
            { "gM", "<cmd>Glance implementations<CR>", desc = "Glance implementations" },
        },
        config = function()
            require("glance").setup({
                border = { enable = true },
                theme = { enable = true, mode = "auto" },
            })
        end,
    },

    -- Refactoring
    {
        "theprimeagen/refactoring.nvim",
        keys = {
            { "<leader>re", mode = { "n", "x" }, desc = "Refactor" },
        },
        config = function()
            require("refactoring").setup()
        end,
    },

    -- Copilot (Lua-native with chat)
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-l>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<M-h>",
                    },
                },
                panel = { enabled = false },
                filetypes = {
                    ["*"] = true,
                    gitcommit = false,
                    noice = false,
                },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
        cmd = "CopilotChat",
        keys = {
            { "<leader>cc", "<cmd>CopilotChat<CR>", mode = { "n", "v" }, desc = "Copilot chat" },
            { "<leader>ce", "<cmd>CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "Explain code" },
            { "<leader>ct", "<cmd>CopilotChatTests<CR>", mode = { "n", "v" }, desc = "Generate tests" },
            { "<leader>cf", "<cmd>CopilotChatFix<CR>", mode = { "n", "v" }, desc = "Fix code" },
            { "<leader>cr", "<cmd>CopilotChatReview<CR>", mode = { "n", "v" }, desc = "Review code" },
            { "<leader>cd", "<cmd>CopilotChatDocs<CR>", mode = { "n", "v" }, desc = "Generate docs" },
        },
        config = function()
            require("CopilotChat").setup({
                window = {
                    layout = "vertical",
                    width = 0.4,
                },
            })
        end,
    },

    -- Cloak (hide secrets)
    {
        "laytan/cloak.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("domus.plugins.config.cloak").setup()
        end,
    },

    -- SchemaStore (JSON schemas)
    {
        "b0o/schemastore.nvim",
        lazy = true,
    },

    -- Trouble (structured diagnostics, todos, quickfix)
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
            { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Todos (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix (Trouble)" },
        },
        opts = {},
    },
}
