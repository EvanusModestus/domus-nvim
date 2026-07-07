-- Theme-adaptive plugin highlights
--
-- Several plugins (headlines, alpha, indent-blankline, hlargs) need custom
-- highlight groups. Hardcoding hex values ties them to one colorscheme and
-- leaves stale colors when the theme changes. Instead we DERIVE these groups
-- from the active colorscheme's own highlights and re-apply on every
-- ColorScheme event, so they track whatever theme is loaded.

local M = {}

-- "#rrggbb" from a highlight-group attribute (returns fallback if unavailable)
local function to_hex(n)
	if type(n) == "number" then
		return string.format("#%06x", n)
	end
	return nil
end

function M.fg(group, fallback)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	return (ok and hl and to_hex(hl.fg)) or fallback
end

function M.bg(group, fallback)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	return (ok and hl and to_hex(hl.bg)) or fallback
end

-- Split "#rrggbb" into r,g,b integers (nil if malformed)
local function channels(hex)
	if type(hex) ~= "string" then
		return nil
	end
	local h = hex:gsub("#", "")
	if #h ~= 6 then
		return nil
	end
	local r = tonumber(h:sub(1, 2), 16)
	local g = tonumber(h:sub(3, 4), 16)
	local b = tonumber(h:sub(5, 6), 16)
	return r, g, b
end

-- Blend `fg` over `bg`; alpha is the weight of fg (0.0 = bg, 1.0 = fg).
-- Returns `bg` unchanged if either color can't be parsed.
function M.blend(fg, bg, alpha)
	local fr, fgc, fb = channels(fg)
	local br, bgc, bb = channels(bg)
	if not (fr and br) then
		return bg
	end
	local function mix(a, b)
		return math.floor(a * alpha + b * (1 - alpha) + 0.5)
	end
	return string.format("#%02x%02x%02x", mix(fr, br), mix(fgc, bgc), mix(fb, bb))
end

-- Per-heading accent groups (exist in nearly every colorscheme) + fallbacks.
local HEADING_GROUPS = {
	"DiagnosticError", -- red
	"DiagnosticWarn", -- yellow / orange
	"DiagnosticInfo", -- blue
	"DiagnosticHint", -- teal / cyan
	"Function", -- blue
	"Keyword", -- purple / magenta
}
local HEADING_FALLBACK = { "#f38ba8", "#fab387", "#f9e2af", "#a6e3a1", "#89b4fa", "#cba6f7" }

-- Apply all theme-derived plugin highlight groups for the CURRENT colorscheme.
function M.apply()
	local set = vim.api.nvim_set_hl
	local normal_bg = M.bg("Normal", "#1a1a26")

	-- headlines.nvim: subtle themed background bar + bold accent per level
	for i = 1, 6 do
		local accent = M.fg(HEADING_GROUPS[i], HEADING_FALLBACK[i])
		set(0, "Headline" .. i, {
			bg = M.blend(accent, normal_bg, 0.18),
			fg = accent,
			bold = true,
		})
	end
	set(0, "CodeBlock", { bg = M.bg("CursorLine", M.blend("#808080", normal_bg, 0.12)) })
	set(0, "Dash", { fg = M.fg("Comment", "#6c7086") })

	-- Note: indent-blankline owns IblScope/IblIndent via its HIGHLIGHT_SETUP hook
	-- (ui.lua) — setting them here would race with ibl's own ColorScheme refresh.

	-- alpha-nvim dashboard
	set(0, "AlphaHeader", { fg = M.fg("Function", "#cba6f7"), bold = true })
	set(0, "AlphaButtons", { fg = M.fg("Normal", "#cdd6f4") })
	set(0, "AlphaShortcut", { fg = M.fg("DiagnosticError", "#f38ba8"), bold = true })
	set(0, "AlphaFooter", { fg = M.fg("Comment", "#6c7086"), italic = true })
end

-- Register the ColorScheme autocmd and apply once for the current theme.
function M.setup()
	local group = vim.api.nvim_create_augroup("DomusThemedHighlights", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		desc = "Re-derive plugin highlights from the active colorscheme",
		callback = M.apply,
	})
	M.apply()
end

return M
