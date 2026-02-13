-- MOTD (Message of the Day)
-- Simplified version - expand as needed

local M = {}

function M.init()
    -- Skip if disabled
    if vim.g.disable_motd then
        return
    end

    -- Create commands
    vim.api.nvim_create_user_command("Motd", function()
        M.show()
    end, { desc = "Show MOTD" })

    -- Show on startup (after delay)
    vim.defer_fn(function()
        if vim.fn.argc() == 0 and vim.bo.filetype == "" then
            M.show()
        end
    end, 100)
end

function M.show()
    local lines = {
        "",
        "  Domus Instrumentum",
        "  -------------------",
        "",
        "  Quick Keys:",
        "    <Space>ff  Find files",
        "    <Space>fg  Live grep",
        "    <Space>e   File browser (Oil)",
        "    <C-p>      Git files",
        "    <C-e>      Harpoon menu",
        "",
        "  :Motd to show this again",
        "",
    }

    vim.api.nvim_echo({{table.concat(lines, "\n"), "Normal"}}, false, {})
end

return M
