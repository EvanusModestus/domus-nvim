-- LSP Configuration (native vim.lsp.config / vim.lsp.enable — nvim 0.11+)
--
-- Per-server settings are layered over nvim-lspconfig's bundled definitions
-- (its lsp/<name>.lua files supply cmd/filetypes/root_markers on the rtp).
-- This avoids the deprecated require("lspconfig") framework and the
-- mason-lspconfig `handlers` mechanism (removed in mason-lspconfig 2.x).

local M = {}

-- Servers we want installed + enabled. Names match nvim-lspconfig definitions.
local servers = {
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
	"clangd",
}

-- Buffer-local keymaps, wired once via LspAttach (replaces per-server on_attach).
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
	if vim.diagnostic.jump then
		map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
		map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
	else
		map("n", "[d", vim.diagnostic.goto_prev, opts)
		map("n", "]d", vim.diagnostic.goto_next, opts)
	end

	-- Actions
	map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	map("n", "<leader>rn", vim.lsp.buf.rename, opts)

	-- Inlay hints
	if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		map("n", "<leader>ih", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, opts)
	end
end

function M.setup()
	-- Capabilities from blink.cmp
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local blink_ok, blink = pcall(require, "blink.cmp")
	if blink_ok then
		capabilities = blink.get_lsp_capabilities(capabilities)
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("DomusLspAttach", { clear = true }),
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, args.buf)
		end,
	})

	-- Global defaults applied to every server
	vim.lsp.config("*", { capabilities = capabilities })

	-- Per-server overrides (merged over nvim-lspconfig's bundled config)
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				hint = { enable = true },
			},
		},
	})

	vim.lsp.config("pyright", {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticSeverityOverrides = {
						-- Let ruff own these — avoids duplicate diagnostics
						reportUnusedImport = "none",
						reportUnusedVariable = "none",
						reportUnusedExpression = "none",
					},
				},
			},
		},
	})

	vim.lsp.config("rust_analyzer", {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = true,
				check = { command = "clippy" },
				cargo = { allFeatures = true },
				inlayHints = { enable = true },
			},
		},
	})

	vim.lsp.config("clangd", {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
		},
		init_options = {
			usePlaceholders = true,
			completeUnimportedMembers = true,
			clangdFileStatus = true,
		},
	})

	local schemastore_ok, schemastore = pcall(require, "schemastore")

	vim.lsp.config("jsonls", {
		settings = {
			json = {
				schemas = schemastore_ok and schemastore.json.schemas() or {},
				validate = { enable = true },
			},
		},
	})

	vim.lsp.config("yamlls", {
		settings = {
			yaml = {
				schemaStore = {
					-- Disable built-in schemaStore — we supply via schemastore.nvim
					enable = false,
					url = "",
				},
				schemas = schemastore_ok and vim.tbl_deep_extend("force",
					schemastore.yaml.schemas(),
					{
						kubernetes = "*.k8s.yaml",
					}
				) or {
					kubernetes = "*.k8s.yaml",
					["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
					["http://json.schemastore.org/ansible-playbook"] = "playbooks/*.{yml,yaml}",
				},
				validate = true,
			},
		},
	})

	-- Auto-install via mason-lspconfig (no handlers / no lspconfig framework).
	-- automatic_enable = false: we enable explicitly below so the server set is
	-- identical on mason-lspconfig 1.x and 2.x.
	local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")
	if mlsp_ok then
		mlsp.setup({
			ensure_installed = servers,
			automatic_enable = false,
		})
	end

	-- Termux installs a smaller set of servers outside mason; enable that subset.
	if require("domus.core.util").is_termux() then
		vim.lsp.enable({ "lua_ls", "pyright", "rust_analyzer" })
	else
		vim.lsp.enable(servers)
	end
end

return M
