-- Diagnostics
--
-- Global vim.diagnostic.config. This was previously *unset* — diagnostics ran on
-- Neovim's bare defaults: no sign-column glyphs, unsorted severity, and a
-- borderless float. This adds glyphs, severity sorting, a bordered float, and an
-- on-demand switch to virtual_lines (0.11's multi-line diagnostic renderer).
--
-- Design note: virtual_text and virtual_lines are independent renderers, and
-- virtual_text.current_line only offers "current line only" or "all lines" — there
-- is no "all except current" mode. So showing inline text everywhere *and*
-- virtual_lines on the cursor line would double-render that line. Instead we run
-- two clean, non-overlapping modes and toggle between them with <leader>vl:
--   inline (default) : concise virtual_text on every line, virtual_lines off
--   expanded         : virtual_lines on every line, virtual_text off
-- virtual_lines needs 0.11; on older builds (Termux) the toggle is not mapped and
-- diagnostics stay in inline mode.

local has_011 = vim.fn.has("nvim-0.11") == 1

-- Sign-column glyphs per severity (nerd font — same family as todo-comments/lualine).
local signs = {
	[vim.diagnostic.severity.ERROR] = "",
	[vim.diagnostic.severity.WARN]  = "",
	[vim.diagnostic.severity.INFO]  = "",
	[vim.diagnostic.severity.HINT]  = "",
}

-- Concise inline text. `source = "if_many"` tags the producer only when a buffer
-- has >1 (e.g. ruff vs pyright on Python), so single-source buffers stay quiet.
local function virtual_text_opts()
	return {
		source = "if_many",
		spacing = 2,
		prefix = "●",
	}
end

vim.diagnostic.config({
	severity_sort = true,     -- errors sort/draw above warnings in the sign column
	update_in_insert = false, -- don't recompute mid-keystroke (matches the snappy updatetime)
	underline = true,
	signs = { text = signs },
	virtual_text = virtual_text_opts(),
	virtual_lines = false,
	float = {
		border = "rounded", -- also inherited from winborder; set explicitly for older builds
		source = "if_many",
		header = "",
		prefix = "",
	},
})

-- <leader>vl — flip between inline (virtual_text) and expanded (virtual_lines).
-- Same <leader>v* diagnostics group as <leader>vd (open_float, wired buffer-locally
-- in plugins/config/lsp/init.lua). Requires 0.11 for virtual_lines.
if has_011 then
	local expanded = false
	vim.keymap.set("n", "<leader>vl", function()
		expanded = not expanded
		-- Explicit branches, NOT `expanded and false or opts`: that idiom always
		-- returns opts because `true and false` is falsy, leaving virtual_text on in
		-- expanded mode and double-rendering every line.
		if expanded then
			vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
		else
			vim.diagnostic.config({ virtual_text = virtual_text_opts(), virtual_lines = false })
		end
		vim.notify("Diagnostics: " .. (expanded and "expanded (virtual_lines)" or "inline (virtual_text)"))
	end, { desc = "Toggle diagnostic virtual_lines" })
end
