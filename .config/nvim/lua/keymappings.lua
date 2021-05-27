local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- set leader to space
vim.g.mapleader = ','
-- Easier splits navigation
map('n', '<C-j>', '<C-w>j', { noremap = false })
map('n', '<C-k>', '<C-w>k', { noremap = false })
map('n', '<C-h>', '<C-w>h', { noremap = false })
map('n', '<C-l>', '<C-w>l', { noremap = false })

-- Use alt + hjkl to resize windows
map('n', '<M-j>', '<cmd>resize -2<CR>')
map('n', '<M-k>', '<cmd>resize +2<CR>')
map('n', '<M-h>', '<cmd>vertical resize -2<CR>')
map('n', '<M-l>', '<cmd>vertical resize +2<CR>')

-- Terminal window navigation
map('t', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = false })
map('t', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = false })
map('t', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = false })
map('t', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = false })
map('t', '<C-[><C-[>', '<C-\\><C-N>') -- double ESC to escape terminal

-- command mode
map('c', '<C-a>', '<Home>')
map('c', '<C-e>', '<End>')

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- sensible defaults
map('', 'Y', 'y$') -- yank to end of line (for consistency)
map('', 'Q', '') -- disable
map('n', 'x', '"_x') -- delete char without yank
map('x', 'x', '"_x') -- delete visual selection without yank

-- paste in visual mode and keep available
-- map('x', 'p', '"_dP')
-- map('x', 'P', '"_dP')

--  ctrl + /: nohighlight
map('n', '<C-_>', ':noh<CR>')

