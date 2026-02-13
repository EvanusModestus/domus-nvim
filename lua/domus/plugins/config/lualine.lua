-- Lualine Configuration

local M = {}

function M.setup()
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = {
                { "filename", path = 1 },  -- Relative path
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
