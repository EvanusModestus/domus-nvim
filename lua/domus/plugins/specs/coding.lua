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
        end,
    },

    -- Completion (blink.cmp)
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "*",  -- Use latest release with prebuilt binaries
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
            { "gD", "<cmd>Glance definitions<CR>", desc = "Glance definitions" },
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

    -- Inline diagnostics
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_lines").setup()
            -- Toggle between virtual text and lines
            vim.keymap.set("n", "<leader>vl", function()
                local lines_enabled = vim.diagnostic.config().virtual_lines
                vim.diagnostic.config({
                    virtual_lines = not lines_enabled,
                    virtual_text = lines_enabled,
                })
            end, { desc = "Toggle diagnostic lines" })
            -- Start with lines disabled
            vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
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

    -- Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        config = function()
            vim.g.copilot_filetypes = { ["*"] = true }
            vim.g.copilot_no_tab_map = false
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
}
