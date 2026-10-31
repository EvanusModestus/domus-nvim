-- Go Language Specs
-- Native, minimal (no ray-x/go.nvim wrapper):
--   LSP        gopls          -> lsp/init.lua (servers list + per-server settings)
--   Treesitter go/gomod/...   -> config/treesitter.lua ensure_installed
--   Format     goimports+gofumpt -> conform.lua (installed via mason-tools.lua)
--   Lint       golangci-lint  -> lint.lua (installed via mason-tools.lua)
--   Debug      delve (dlv dap) -> dap/init.lua adapter + configurations.go
--   Run/test   <leader>cr / <leader>ct -> ftplugin/go.lua
-- No plugins to register here; kept for symmetry with c.lua / perl.lua.

return {}
