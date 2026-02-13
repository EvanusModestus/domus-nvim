-- Domus Bootstrap
-- Load configuration layers in order

-- Layer 1: User configuration (options, keymaps, autocmds)
require("domus.config")

-- Layer 2: Core infrastructure (lazy.nvim bootstrap)
require("domus.core")

-- Layer 3: Plugin system (loads via lazy.nvim)
-- Handled by domus.core.lazy

-- Layer 4: Features loaded after plugins (via VeryLazy)
-- Layer 5: UI loaded after plugins (via VeryLazy)
