-- Utilities
-- Shared helper functions

local M = {}

-- Check if running in Termux (used by the LSP native-API fallback)
function M.is_termux()
    return vim.fn.getenv("TERMUX_VERSION") ~= vim.NIL
        or vim.fn.isdirectory("/data/data/com.termux") == 1
end

-- True on native Windows. WSL reports as linux, so this is only real win32.
function M.is_windows()
    return vim.fn.has("win32") == 1
end

-- Absolute path to a Mason-installed executable, with the right suffix per
-- platform: Mason writes .cmd launcher shims into mason/bin on Windows, bare
-- names elsewhere. Use for any hardcoded mason/bin/<tool> path.
function M.mason_bin(name)
    local ext = M.is_windows() and ".cmd" or ""
    return vim.fn.stdpath("data") .. "/mason/bin/" .. name .. ext
end

return M
