local M = {}

function M.setup()
    vim.g.kommentary_create_default_mappings = false
end

function M.config()
    require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
    })
    require('kommentary.config').configure_language('lua', {
        single_line_comment_string = '--',
        prefer_single_line_comments = true,
    })

    vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>kommentary_line_default", {})
    vim.api.nvim_set_keymap("n", "<leader>c", "<Plug>kommentary_motion_default", {})
    vim.api.nvim_set_keymap("v", "<leader>c", "<Plug>kommentary_visual_default", {})
end

return M
