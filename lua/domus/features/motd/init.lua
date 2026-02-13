-- MOTD (Message of the Day)
-- Shows as notification popup on startup

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

    -- Auto-show on startup (after plugins load)
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.defer_fn(function()
                M.show()
            end, 100)
        end,
    })
end

function M.show()
    local lines = {
        "Quick Keys:",
        "  <Space>ff  Find files",
        "  <Space>fg  Live grep",
        "  <Space>e   File browser",
        "  <C-p>      Git files",
        "  <C-e>      Harpoon menu",
    }

    -- Use notify if available, otherwise echo
    local ok, notify = pcall(require, "notify")
    if ok then
        notify(table.concat(lines, "\n"), "info", {
            title = "Domus Instrumentum",
            timeout = 5000,
        })
    else
        vim.api.nvim_echo({{table.concat(lines, "\n"), "Normal"}}, false, {})
    end
end

return M
