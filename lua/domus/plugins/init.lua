-- Plugin Specs Aggregator
-- Combines all domain specs into single table for lazy.nvim

local specs = {}

-- Helper to merge spec tables
local function add(spec_module)
    local ok, module = pcall(require, spec_module)
    if ok and type(module) == "table" then
        for _, spec in ipairs(module) do
            table.insert(specs, spec)
        end
    end
end

-- Core specs (load order matters)
add("domus.plugins.specs.editor")     -- Treesitter, autopairs, comment
add("domus.plugins.specs.ui")         -- Colorscheme, lualine, icons
add("domus.plugins.specs.coding")     -- LSP, completion, snippets
add("domus.plugins.specs.git")        -- Fugitive, gitsigns, lazygit
add("domus.plugins.specs.tools")      -- Telescope, harpoon, oil
add("domus.plugins.specs.debug")      -- DAP stack

-- Language-specific specs
add("domus.plugins.specs.lang.python")
add("domus.plugins.specs.lang.rust")
add("domus.plugins.specs.lang.javascript")
add("domus.plugins.specs.lang.asciidoc")
add("domus.plugins.specs.lang.markdown")
add("domus.plugins.specs.lang.misc")  -- Cisco, Jinja2, CSV, SQL

return specs
