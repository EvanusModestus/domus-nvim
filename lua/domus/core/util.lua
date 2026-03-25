-- Utilities
-- Shared helper functions

local M = {}

-- Create keymap with defaults
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Check if plugin is available
function M.has(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

-- Get plugin if available
function M.get_plugin(plugin)
    return require("lazy.core.config").spec.plugins[plugin]
end

-- Defer execution
function M.defer(fn, ms)
    vim.defer_fn(fn, ms or 0)
end

-- Create augroup
function M.augroup(name)
    return vim.api.nvim_create_augroup("Domus_" .. name, { clear = true })
end

-- Execute on filetype
function M.on_ft(ft, callback)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = callback,
    })
end

-- Check if running in VSCode
function M.is_vscode()
    return vim.g.vscode ~= nil
end

-- Check if running in WSL
function M.is_wsl()
    if vim.fn.has("unix") == 0 then return false end
    local ok, result = pcall(vim.fn.system, "uname -r")
    if not ok or type(result) ~= "string" then return false end
    return result:match("[Mm]icrosoft") ~= nil
end

-- Safe require (returns nil on failure)
function M.safe_require(module)
    local ok, result = pcall(require, module)
    if ok then
        return result
    end
    return nil
end

-- Merge tables (shallow)
function M.merge(...)
    return vim.tbl_extend("force", ...)
end

-- Deep merge tables
function M.deep_merge(...)
    return vim.tbl_deep_extend("force", ...)
end

return M
