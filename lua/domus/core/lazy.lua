-- Lazy.nvim Bootstrap
-- Plugin manager setup

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin specs
local specs = require("domus.plugins")

require("lazy").setup(specs, {
    -- Performance
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    -- UI
    ui = {
        border = "rounded",
        icons = {
            cmd = "C",
            config = "CFG",
            event = "E",
            ft = "FT",
            init = "I",
            keys = "K",
            plugin = "P",
            runtime = "RT",
            source = "S",
            start = ">",
            task = "T",
            lazy = "z",
        },
    },

    -- Checker
    checker = {
        enabled = false, -- Don't auto-check for updates
    },

    -- Change detection
    change_detection = {
        enabled = true,
        notify = false, -- Don't spam notifications
    },
})

-- Post-plugin setup
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- Load features after plugins are ready
        vim.defer_fn(function()
            require("domus.features")
            require("domus.ui")
        end, 100)
    end,
})
