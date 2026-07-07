-- Utilities
-- Shared helper functions

local M = {}

-- Check if running in Termux (used by the LSP native-API fallback)
function M.is_termux()
    return vim.fn.getenv("TERMUX_VERSION") ~= vim.NIL
        or vim.fn.isdirectory("/data/data/com.termux") == 1
end

return M
