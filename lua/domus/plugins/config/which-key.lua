-- Which-Key Configuration

local M = {}

function M.setup()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end

    wk.setup({
        plugins = {
            marks = true,
            registers = true,
            spelling = { enabled = true },
        },
        win = {
            border = "rounded",
        },
    })

    -- Register key groups
    wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Terminal" },
        { "<leader>h", group = "Hunk" },
        { "<leader>c", group = "Code" },
        { "<leader>v", group = "Vim/LSP" },
        { "<leader>j", group = "JavaScript" },
    })
end

return M
