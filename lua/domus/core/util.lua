-- Utilities
-- Shared helper functions

local M = {}

-- Create keymap with defaults
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Create augroup with Domus_ prefix
function M.augroup(name)
    return vim.api.nvim_create_augroup("Domus_" .. name, { clear = true })
end

-- Check if running in WSL
function M.is_wsl()
    if vim.fn.has("unix") == 0 then return false end
    local ok, result = pcall(vim.fn.system, "uname -r")
    if not ok or type(result) ~= "string" then return false end
    return result:match("[Mm]icrosoft") ~= nil
end

-- Check if running in Termux
function M.is_termux()
    return vim.fn.getenv("TERMUX_VERSION") ~= vim.NIL
        or vim.fn.isdirectory("/data/data/com.termux") == 1
end

-- Safe require (returns nil on failure)
function M.safe_require(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    end
    return nil
end

return M
