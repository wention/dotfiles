local M = {}

function M.config()
    --[[
    vim.g.bufferline = {
        -- Enable/disable animations
        animation = false,

        auto_hide = true,

        -- Enable/disable icons
        -- if set to 'numbers', will show buffer index in the tabline
        -- if set to 'both', will show buffer index and icons in the tabline
        icons = true,
        icon_separator_active = '▎',
        icon_separator_inactive = ' ',
        icon_close_tab = '',
        icon_close_tab_modified = ' ',

        -- Enable/disable close button
        closable = false,

        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,

        -- If set, the letters for each buffer in buffer-pick mode will be
        -- assigned based on their name. Otherwise or in case all letters are
        -- already assigned, the behavior is to assign letters in order of
        -- usability (see order below)
        semantic_letters = true,

        -- Sets the maximum padding width with which to surround each tab
        maximum_padding = 2,
    }
    ]]
    local opts = { noremap = true, silent = true }
    -- Move to previous/next
    vim.api.nvim_set_keymap('n', '<A-[>', '<cmd>BufferPrevious<CR>', opts)
    vim.api.nvim_set_keymap('n', '<A-]>', '<cmd>BufferPrevious<CR>', opts)
    -- Re-order to previous/next
    vim.api.nvim_set_keymap('n', '<A-{>', '<cmd>BufferPrevious<CR>', opts)
    vim.api.nvim_set_keymap('n', '<A-}>', '<cmd>BufferPrevious<CR>', opts)
    -- Goto buffer in position...
    vim.api.nvim_set_keymap('n', '<Leader>1', '<cmd>BufferGoto 1<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>2', '<cmd>BufferGoto 2<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>3', '<cmd>BufferGoto 3<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>4', '<cmd>BufferGoto 4<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>5', '<cmd>BufferGoto 5<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>6', '<cmd>BufferGoto 6<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>7', '<cmd>BufferGoto 7<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>8', '<cmd>BufferGoto 8<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>9', '<cmd>BufferGoto 9<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>0', '<cmd>BufferLast<CR>', opts)
    -- Close buffer
    vim.api.nvim_set_keymap('n', '<Leader>x', '<cmd>BufferClose<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>X', '<cmd>BufferCloseAllButCurrent<CR>', opts)

    -- Magic buffer-picking mode
    vim.api.nvim_set_keymap('n', '<Leader>p', '<cmd>BufferPick<CR>', opts)


end

return M
