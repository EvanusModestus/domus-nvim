-- Debug Specs
-- DAP (Debug Adapter Protocol) plugins

return {
    -- nvim-dap core
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            -- DAP UI
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
            },
            -- Virtual text
            "theHamsta/nvim-dap-virtual-text",
            -- Mason integration
            "jay-babu/mason-nvim-dap.nvim",
        },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue" },
            { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step over" },
            { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step into" },
            { "<F12>", function() require("dap").step_out() end, desc = "DAP: Step out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP: Conditional breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "DAP: Continue" },
            { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP: REPL" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "DAP: Terminate" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },
        },
        config = function()
            require("domus.plugins.config.dap").setup()
        end,
    },
}
