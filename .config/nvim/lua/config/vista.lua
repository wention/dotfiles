local M = {}

function M.setup()
    vim.g.vista_icon_indent = {"╰─▸ ", "├─▸ "}
    vim.g.vista_default_executive = 'ctags'
    vim.g.vista_executive_for = {
        cpp = 'vim_lsp',
    }
    
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', '<Leader>t', '<cmd>Vista!!<CR>', opts)
end

function M.config()
    vim.g.vista_icon_indent = {"╰─▸ ", "├─▸ "}
    vim.g.vista_default_executive = 'ctags'
    vim.g.vista_executive_for = {
        cpp = 'vim_lsp',
    }
    --vim.g.vista.renderer.enable_icon = 1
end

return M
