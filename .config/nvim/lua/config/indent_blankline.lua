local M = {}

function M.setup()
    --vim.g.indent_blankline_char = '|'
    vim.g.indent_blankline_show_current_context = true
    vim.g.indent_blankline_indent_level = 10
    --vim.g.indent_blankline_filetype = {}
    vim.g.indent_blankline_filetype_exclude = {'help', 'packer'}
    vim.g.indent_blankline_buftype_exclude = {'terminal', 'packer', 'NvimTree'}
    vim.g.indent_blankline_bufname_exclude = {'README.md'}
    vim.g.indent_blankline_use_treesitter = true
    vim.g.indent_blankline_context_patterns = {'class', 'function', 'method', '^if', '^for', '^while'}
    --vim.cmd [[highlight IndentBlanklineChar guifg=#00FF00 gui=nocombine]]
    --vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#00FF00 gui=nocombine]]
    --vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=#00FF00 gui=nocombine]]
    --vim.cmd [[highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine]]
end

return M