-- LSP Configuration

local M = {}

function M.setup()
	-- Get capabilities from blink.cmp
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local blink_ok, blink = pcall(require, "blink.cmp")
	if blink_ok then
		capabilities = blink.get_lsp_capabilities(capabilities)
	end

	-- On attach function
	local function on_attach(client, bufnr)
		local opts = { buffer = bufnr }
		local map = vim.keymap.set

		-- Navigation
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gi", vim.lsp.buf.implementation, opts)
		map("n", "go", vim.lsp.buf.type_definition, opts)
		map("n", "gr", vim.lsp.buf.references, opts)

		-- Information
		map("n", "K", vim.lsp.buf.hover, opts)
		map("i", "<C-k>", vim.lsp.buf.signature_help, opts)

		-- Diagnostics
		map("n", "<leader>vd", vim.diagnostic.open_float, opts)
		map("n", "[d", vim.diagnostic.goto_prev, opts)
		map("n", "]d", vim.diagnostic.goto_next, opts)

		-- Actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)

		-- Inlay hints
		if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, opts)
		end
	end

	-- Setup mason-lspconfig
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"pyright",
			"rust_analyzer",
			"ts_ls",
			"html",
			"cssls",
			"jsonls",
			"yamlls",
			"bashls",
			"dockerls",
			"ansiblels",
			"marksman",
			"taplo",
		},
		handlers = {
			-- Default handler
			function(server_name)
				require("lspconfig")[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,

			-- Lua
			lua_ls = function()
				require("lspconfig").lua_ls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							hint = { enable = true },
						},
					},
				})
			end,

			-- Python
			pyright = function()
				require("lspconfig").pyright.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				})
			end,

			-- Rust
			rust_analyzer = function()
				require("lspconfig").rust_analyzer.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = { command = "clippy" },
							cargo = { allFeatures = true },
							inlayHints = { enable = true },
						},
					},
				})
			end,

			-- JSON (with SchemaStore)
			jsonls = function()
				local schemastore_ok, schemastore = pcall(require, "schemastore")
				require("lspconfig").jsonls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						json = {
							schemas = schemastore_ok and schemastore.json.schemas() or {},
							validate = { enable = true },
						},
					},
				})
			end,

			-- YAML (with schemas)
			yamlls = function()
				require("lspconfig").yamlls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						yaml = {
							schemas = {
								kubernetes = "*.k8s.yaml",
								["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
								["http://json.schemastore.org/ansible-playbook"] = "playbooks/*.{yml,yaml}",
							},
						},
					},
				})
			end,
		},
	})

	-- Termux fallback: setup LSPs using nvim 0.11 native API
	if require("domus.core.util").is_termux() then
		-- lua_ls
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".git", ".luarc.json", "init.lua" },
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			},
		}

		-- pyright
		vim.lsp.config.pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			root_markers = { ".git", "pyproject.toml", "setup.py" },
		}

		-- rust_analyzer
		vim.lsp.config.rust_analyzer = {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_markers = { ".git", "Cargo.toml" },
		}

		-- Enable them
		vim.lsp.enable({ "lua_ls", "pyright", "rust_analyzer" })
	end
end

return M
