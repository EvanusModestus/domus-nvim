-- Telescope Configuration

local M = {}

function M.setup()
    local ok, telescope = pcall(require, "telescope")
    if not ok then return end

    local actions = require("telescope.actions")

    telescope.setup({
        defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
            layout_strategy = "flex",
            layout_config = {
                flex = { flip_columns = 120 },
                horizontal = { preview_width = 0.55 },
                vertical = { preview_height = 0.55 },
            },
            path_display = { "truncate" },
            vimgrep_arguments = {
                "rg", "--no-config", "--color=never", "--no-heading",
                "--with-filename", "--line-number", "--column",
                "--smart-case", "--hidden", "-g", "!.git/",
            },
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-x>"] = actions.select_horizontal,
                },
                n = {
                    ["q"] = actions.close,
                    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                },
            },
        },
        pickers = {
            find_files = {
                find_command = { "rg", "--files", "--no-config", "--color=never", "--hidden", "-g", "!.git/" },
                hidden = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    })

    -- Load extensions
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "file_browser")
    pcall(telescope.load_extension, "project")
    pcall(telescope.load_extension, "undo")

    -- Setup keymaps
    M.keymaps()
end

function M.keymaps()
    local builtin = require("telescope.builtin")
    local map = vim.keymap.set

    -- Find
    map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
    map("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
    map("n", "<leader>fr", builtin.resume, { desc = "Resume search" })
    map("n", "<leader>fw", builtin.grep_string, { desc = "Find word" })
    map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
    map("n", "<leader>fc", builtin.commands, { desc = "Commands" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })

    -- Git
    map("n", "<C-p>", builtin.git_files, { desc = "Git files" })
    map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
    map("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })

    -- LSP
    map("n", "<leader>lr", builtin.lsp_references, { desc = "LSP references" })
    map("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "LSP symbols" })
    map("n", "<leader>lw", builtin.lsp_workspace_symbols, { desc = "LSP workspace" })

    -- Extensions
    map("n", "<leader>fe", "<cmd>Telescope file_browser<CR>", { desc = "File browser" })
    map("n", "<leader>fp", "<cmd>Telescope project<CR>", { desc = "Projects" })
    map("n", "<leader>fu", "<cmd>Telescope undo<CR>", { desc = "Undo tree" })
end

return M
