-- UFO (Folding) Configuration

local M = {}

function M.setup()
    local ok, ufo = pcall(require, "ufo")
    if not ok then return end

    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    ufo.setup({
        provider_selector = function(bufnr, filetype, buftype)
            -- Use indent for filetypes without treesitter
            local no_ts = { "asciidoc", "asciidoctor", "text" }
            if vim.tbl_contains(no_ts, filetype) then
                return { "indent" }
            end
            return { "treesitter", "indent" }
        end,
    })

    -- Keymaps
    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zK", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, { desc = "Peek fold" })
end

return M
