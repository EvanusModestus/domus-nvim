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
                -- Bracketed per letter for case-insensitivity: Lua patterns have no
                -- inline case-insensitive flag, and a plain lowercase pattern misses
                -- `Password:` / `API_KEY:` (common in Helm/CI yaml) — a real leak of
                -- exactly what this plugin exists to hide.
                file_pattern = "*.yaml",
                cloak_pattern = {
                    "([Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]%s*:%s*)(.+)",
                    "([Ss][Ee][Cc][Rr][Ee][Tt]%s*:%s*)(.+)",
                    "([Tt][Oo][Kk][Ee][Nn]%s*:%s*)(.+)",
                    "([Aa][Pp][Ii]_[Kk][Ee][Yy]%s*:%s*)(.+)",
                },
            },
        },
    })
end

return M
