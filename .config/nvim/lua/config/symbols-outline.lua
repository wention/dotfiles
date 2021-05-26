local M = {}

function M.setup()
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', '<Leader>t', '<cmd>SymbolsOutline<CR>', opts)

    vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false, -- experimental
        position = 'right',
        keymaps = {
            close = "q",
            goto_location = "o",
            hover_symbol = "O",
            focus_location = "f",
            rename_symbol = "r",
            code_actions = "a",
        },
        lsp_blacklist = {},
    }
end

function M.config()
    require('symbols-outline').setup {}
end

return M
