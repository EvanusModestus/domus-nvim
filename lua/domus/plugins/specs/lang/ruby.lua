-- Ruby Language Specs
-- Native, minimal:
--   LSP        ruby_lsp (Shopify) -> lsp/init.lua (servers list)
--   Treesitter ruby               -> config/treesitter.lua ensure_installed
--   Format     rubocop            -> conform.lua (installed via mason-tools.lua)
--   Lint       rubocop            -> lint.lua (installed via mason-tools.lua)
-- rubocop drives both format and lint only when the gem is on PATH (gem install
-- rubocop, or `bundle` in a project with it); both no-op cleanly when absent.
-- No plugins to register here; kept for symmetry with c.lua / perl.lua.

return {}
