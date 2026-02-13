-- Mini.ai Configuration (text objects)

local M = {}

function M.setup()
    local ok, ai = pcall(require, "mini.ai")
    if not ok then return end

    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            -- AsciiDoc text objects
            ["-"] = { "^=+ .+$", "^=+ .+$" },  -- Sections
            ["/"] = { "//(.-)//", "^//(.-)//$/m" },  -- Italic
            ["*"] = { "%*%*(.-)%*%*", "^%*%*(.-)%*%*$" },  -- Bold
            ["`"] = { "`(.-)`", "^`(.-)`$" },  -- Monospace
        },
        mappings = {
            around = "a",
            inside = "i",
            around_next = "an",
            inside_next = "in",
            around_last = "al",
            inside_last = "il",
            goto_left = "g[",
            goto_right = "g]",
        },
    })
end

return M
