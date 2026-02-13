-- Colorscheme Configuration

local M = {}

function M.setup()
    local ok, rose_pine = pcall(require, "rose-pine")
    if not ok then return end

    rose_pine.setup({
        variant = "auto",
        dark_variant = "main",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        styles = {
            bold = true,
            italic = true,
            transparency = false,
        },

        highlight_groups = {
            ColorColumn = { bg = "rose" },
            CursorLine = { bg = "foam", blend = 10 },
            StatusLine = { fg = "love", bg = "love", blend = 10 },
        },
    })

    vim.cmd("colorscheme rose-pine")
end

return M
