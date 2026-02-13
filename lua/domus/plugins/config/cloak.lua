-- Cloak Configuration (hide secrets)

local M = {}

function M.setup()
    local ok, cloak = pcall(require, "cloak")
    if not ok then return end

    cloak.setup({
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        cloak_length = nil,  -- Use actual length
        try_all_patterns = true,
        patterns = {
            {
                file_pattern = {
                    ".env*",
                    "*.env",
                    ".envrc",
                    "credentials*",
                    "*secret*",
                    "*password*",
                    "*token*",
                },
                cloak_pattern = "=.+",
                replace = nil,
            },
            {
                file_pattern = "*.yaml",
                cloak_pattern = {
                    "(password%s*:%s*)(.+)",
                    "(secret%s*:%s*)(.+)",
                    "(token%s*:%s*)(.+)",
                    "(api_key%s*:%s*)(.+)",
                },
            },
        },
    })
end

return M
