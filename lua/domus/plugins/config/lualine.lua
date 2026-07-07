-- Lualine Configuration
-- Clean, informative statusline

local M = {}

function M.setup()
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    -- Read a foreground color from a highlight group so custom components
    -- follow the ACTIVE colorscheme (theme-agnostic; supports theme switching).
    local function hl_fg(group, fallback)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok and hl and hl.fg then
            return string.format("#%06x", hl.fg)
        end
        return fallback
    end

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
            -- "auto" derives the statusline palette from the active colorscheme,
            -- so it follows whatever theme is loaded (no per-theme config needed).
            theme = "auto",
            component_separators = { left = "│", right = "│" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
            disabled_filetypes = {
                statusline = { "alpha", "dashboard", "lazy" },
            },
        },
        sections = {
            lualine_a = {
                { "mode" },
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
                    fmt = function(str)
                        -- Handle oil:// buffers
                        local bufname = vim.fn.bufname()
                        if bufname:match("^oil://") then
                            local path = bufname:gsub("^oil://", "")
                            path = path:gsub(vim.env.HOME, "~")
                            local parts = vim.split(path, "/")
                            if #parts > 3 then
                                return " …/" .. parts[#parts - 1] .. "/" .. parts[#parts]
                            end
                            return " " .. path
                        end
                        return str
                    end,
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
                { macro_recording, color = function() return { fg = hl_fg("DiagnosticError", "#f38ba8") } end },
            },
            lualine_x = {
                { lsp_clients, color = function() return { fg = hl_fg("Function", "#89b4fa") } end },
                { "filetype" },
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
                { "location" },
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
        extensions = { "lazy", "oil", "quickfix" },
    })
end

return M
