-- Python Language Specs

return {
    -- REPL integration
    {
        "Vigemus/iron.nvim",
        ft = { "python" },
        config = function()
            require("iron.core").setup({
                config = {
                    scratch_repl = true,
                    repl_definition = {
                        python = { command = { "ipython", "--no-autoindent" } },
                    },
                    repl_open_cmd = "vertical botright 80 split",
                },
                keymaps = {
                    send_motion = "<leader>sc",
                    visual_send = "<leader>sc",
                    send_file = "<leader>sf",
                    send_line = "<leader>sl",
                    cr = "<leader>s<cr>",
                    interrupt = "<leader>s<space>",
                    exit = "<leader>sq",
                    clear = "<leader>cl",
                },
            })
        end,
    },
}
