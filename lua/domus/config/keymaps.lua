-- Keymaps
-- Core keybindings (non-plugin)

local map = vim.keymap.set

-- Move visual selection up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join lines, keep cursor position
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Half page jumping with centering
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Search centering
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })
map("n", "*", "*zz", { desc = "Search word forward" })
map("n", "#", "#zz", { desc = "Search word backward" })
map("n", "g*", "g*zz", { desc = "Search partial word" })

-- Paste without yanking in visual mode
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete to void register (<leader>D — <leader>d is the Debug group prefix)
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to void" })

-- Better escape
map("i", "<C-c>", "<Esc>", { desc = "Escape" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Disable Ex mode
map("n", "Q", "<nop>")

-- Tmux integration
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Tmux sessionizer" })

-- Note: buffer formatting is <leader>cF (conform.lua, with LSP fallback).
-- The old <leader>f map was removed — it shadowed the Find/Telescope group.

-- Quickfix navigation
map("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location" })

-- Search and replace word under cursor (<leader>S — <leader>s prefixes treesitter swap / iron REPL)
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search/replace word" })

-- Make file executable (<leader>X — <leader>x is the Trouble group prefix)
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

-- Source current file
map("n", "<leader><leader>", function()
    vim.cmd("source %")
end, { desc = "Source file" })

-- Quick save and quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Window navigation (use <C-w> prefix to avoid conflicts)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
-- NOTE: <C-j>/<C-k> reserved for quickfix navigation above

-- Window resize
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })

-- JavaScript/Node.js
map("n", "<leader>jd", ":w<CR>:!npm run dev<CR>", { desc = "npm dev" })
map("n", "<leader>js", ":w<CR>:!npm start<CR>", { desc = "npm start" })
map("n", "<leader>ji", ":!npm install<CR>", { desc = "npm install" })
map("n", "<leader>jb", ":w<CR>:!npm run build<CR>", { desc = "npm build" })
