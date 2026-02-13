-- Lualine Configuration
-- Clean, informative statusline

local M = {}

function M.setup()
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    -- Custom components
    local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local names = {}
        for _, client in ipairs(clients) do
            table.insert(names, client.name)
        end
        return " " .. table.concat(names, ", ")
    end

    local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
            return "󰑋 @" .. reg
        end
        return ""
    end

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "catppuccin",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
            disabled_filetypes = {
                statusline = { "alpha", "dashboard", "lazy" },
            },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    fmt = function(str)
                        return str:sub(1, 3)
                    end,
                },
            },
            lualine_b = {
                { "branch", icon = "" },
                {
                    "diff",
                    symbols = { added = " ", modified = " ", removed = " " },
                    colored = true,
                },
            },
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = {
                        modified = " ●",
                        readonly = " ",
                        unnamed = "[No Name]",
                        newfile = " [New]",
                    },
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    colored = true,
                },
                { macro_recording, color = { fg = "#f38ba8" } },
            },
            lualine_x = {
                { lsp_clients, color = { fg = "#89b4fa" } },
                { "filetype", icon_only = true, padding = { left = 1, right = 1 } },
            },
            lualine_y = {
                { "encoding", fmt = string.upper },
                {
                    "fileformat",
                    symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
                },
            },
            lualine_z = {
                { "progress" },
                { "location", padding = { left = 0, right = 1 } },
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                { "filename", path = 1 },
            },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = { "fugitive", "lazy", "oil", "quickfix" },
    })
end

return M
