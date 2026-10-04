-- Perl Language Specs
-- PerlNavigator (LSP) configured in lsp/init.lua, perltidy in conform.lua.
-- Treesitter `perl` parser is in config/treesitter.lua's ensure_installed.
-- Snippets live in lua/domus/snippets/perl.lua and are registered by the single
-- LuaSnip spec in specs/coding.lua (same pattern as C -- avoids a duplicate
-- LuaSnip spec whose config would override the friendly-snippets loader).

return {}
