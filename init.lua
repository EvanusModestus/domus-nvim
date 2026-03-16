-- Domus Instrumentum - Modular Neovim Configuration
-- A hierarchical, maintainable setup for the modern developer
--
-- Structure:
--   domus.config   - User preferences (options, keymaps, autocmds)
--   domus.core     - Infrastructure (lazy.nvim, utilities)
--   domus.plugins  - Plugin system (specs + configs)
--   domus.features - Custom systems (MOTD, regex-mastery, captures)
--   domus.ui       - Visual components (colorscheme, statusline)

-- Version check: mason-lspconfig requires neovim 0.11+
local min_version = "0.11.0"
if vim.fn.has("nvim-0.11") ~= 1 then
  vim.api.nvim_echo({
    { "domus-nvim requires Neovim " .. min_version .. "+\n", "ErrorMsg" },
    { "Current version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch .. "\n", "WarningMsg" },
    { "\nInstall latest neovim:\n", "Normal" },
    { "  sudo add-apt-repository ppa:neovim-ppa/unstable\n", "Comment" },
    { "  sudo apt update && sudo apt install neovim\n", "Comment" },
  }, true, {})
  return
end

require("domus")
