local M = {}

function M.setup()
    local opts = { noremap = true, silent = true, nowait = true }
    vim.api.nvim_set_keymap('', '<Leader>w', '<cmd>HopChar1<CR>', opts)
    vim.api.nvim_set_keymap('', '<Leader>sw', '<cmd>HopPattern<CR>', opts)
end

return M
