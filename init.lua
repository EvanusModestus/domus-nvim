-- Domus Instrumentum - Modular Neovim Configuration
-- A hierarchical, maintainable setup for the modern developer
--
-- Structure:
--   domus.config   - User preferences (options, keymaps, autocmds)
--   domus.core     - Infrastructure (lazy.nvim, utilities)
--   domus.plugins  - Plugin system (specs + configs)
--
-- Targets Neovim 0.11+ (uses vim.lsp.config). No hard version gate: the config
-- always loads and degrades where an unsupported API is actually used, rather
-- than bailing early into a bare default editor.

require("domus")
