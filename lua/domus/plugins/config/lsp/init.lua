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
	"powershell_es", -- PowerShell (needs `pwsh` on PATH; bundle_path set below)
	"sqlls",         -- SQL (sql-language-server, npm)
	"terraformls",   -- Terraform / Azure IaC
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
	-- Skip K for C/C++: ftplugin/c.lua binds a richer K (man 2→3→general, then
	-- hover fallback) on FileType, and LspAttach fires after it — mapping here
	-- would clobber the man-page lookup. Other filetypes get plain hover.
	local ft = vim.bo[bufnr].filetype
	if ft ~= "c" and ft ~= "cpp" then
		map("n", "K", vim.lsp.buf.hover, opts)
	end
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

	-- Code lens (native vim.lsp.codelens — no plugin). rust_analyzer emits Run/Debug
	-- and "N implementations" lenses, clangd and others too; this config previously
	-- discarded them. enable() auto-refreshes the lens display for this buffer;
	-- <leader>cL runs the lens under the cursor. Gated on the codeLensProvider
	-- capability, so it stays silent for servers without one (pyright, bashls, …).
	-- enable() is 0.11+; guarded so older builds skip rather than error.
	if client and client.server_capabilities.codeLensProvider
		and vim.lsp.codelens and vim.lsp.codelens.enable then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
		map("n", "<leader>cL", vim.lsp.codelens.run,
			vim.tbl_extend("force", opts, { desc = "Run code lens" }))
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
				-- procMacro + buildScripts are the completion multipliers: without them,
				-- derive-macro output (serde's Deserialize, tokio's #[tokio::main], etc.)
				-- and build-script-generated symbols never make it into the completion
				-- index, so whole APIs look "missing". allFeatures widens the surface.
				cargo = { allFeatures = true, buildScripts = { enable = true } },
				procMacro = { enable = true },
				completion = {
					callable = { snippets = "fill_arguments" }, -- complete `fn(a, b)` with arg placeholders
					fullFunctionSignatures = { enable = true },
					postfix = { enable = true },                -- `.match`, `.if`, `.let` postfix completions
					autoimport = { enable = true },             -- offer + insert `use` for out-of-scope items
					autoself = { enable = true },
				},
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
			"--header-insertion-decorators", -- prefix header-adding items with a marker so they're obvious
			"--completion-style=detailed",
			"--all-scopes-completion",       -- suggest symbols from all scopes (auto-adds the needed #include)
			"--pch-storage=memory",          -- keep preamble PCH in RAM: faster completion, no /tmp churn
			"--function-arg-placeholders=1", -- clangd 22+ requires an explicit value (bare flag errors)
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

	-- PowerShell Editor Services ships as a bundle, not a plain binary. The
	-- lspconfig def reads vim.lsp.config.powershell_es.bundle_path to build its
	-- Start-EditorServices.ps1 cmd. mason-lspconfig's handler used to inject this;
	-- our native vim.lsp.enable path bypasses that, so set it to the mason package.
	-- Requires `pwsh` (PowerShell Core) on PATH — install separately on Arch.
	local pses_bundle = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
	vim.lsp.config("powershell_es", {
		bundle_path = pses_bundle,
		settings = {
			powershell = {
				-- Run $PROFILE inside the PSES runspace so any `Import-Module` there
				-- (e.g. Az) populates completion. NOTE: completion of Az cmdlets ALSO
				-- requires the module to actually be installed on PSModulePath —
				-- `Install-Module Az -Scope CurrentUser`. With Az absent, no setting helps.
				enableProfileLoading = true,
				scriptAnalysis = { enable = true },
				codeFormatting = { preset = "OTBS", autoCorrectAliases = true },
			},
		},
	})

	-- bash-language-server: point it explicitly at mason's shellcheck (its lint +
	-- completion source) and widen the glob so sourced fragments are indexed for
	-- cross-file completion. Falls back to no-op if the key is unsupported.
	vim.lsp.config("bashls", {
		settings = {
			bashIde = {
				globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
				shellcheckPath = vim.fn.stdpath("data") .. "/mason/bin/shellcheck",
			},
		},
	})

	-- AsciiDoc language server: NOT in nvim-lspconfig or mason. Hand-defined and
	-- guarded so a missing binary never breaks startup. Provides document symbols,
	-- folding, and xref/anchor completion only — the asciidoctor linter (nvim-lint)
	-- remains the real validator. Install with: npm i -g asciidoc-language-server
	if vim.fn.executable("asciidoc-language-server") == 1 then
		vim.lsp.config("asciidoc_ls", {
			cmd = { "asciidoc-language-server", "--stdio" },
			filetypes = { "asciidoc" },
			root_markers = { "antora.yml", ".git" },
		})
		vim.lsp.enable("asciidoc_ls")
	end

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
		-- powershell_es spawns `pwsh`; enabling it without PowerShell Core installed
		-- logs a start failure on every launch. Keep it in the mason install set but
		-- only enable when pwsh is present (Arch: install the `powershell` package).
		local enabled = {}
		for _, s in ipairs(servers) do
			if s ~= "powershell_es" or vim.fn.executable("pwsh") == 1 then
				table.insert(enabled, s)
			end
		end
		vim.lsp.enable(enabled)
	end
end

return M
