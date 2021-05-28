local M = {}

function M.setup()
    vim.cmd [[packadd nvim-web-devicons]]
    -- line char: ┆, , │, 
    vim.g.indent_blankline_char = '┆'
    vim.g.indent_blankline_show_current_context = true
    vim.g.indent_blankline_indent_level = 10
    vim.g.indent_blankline_use_treesitter = true
    vim.g.indent_blankline_filetype_exclude = {'help', 'man', 'packer', 'NvimTree', 'Outline'}
    vim.g.indent_blankline_buftype_exclude = {'terminal'}
    vim.g.indent_blankline_bufname_exclude = {'README.md'}
    vim.g.indent_blankline_context_patterns = {
        "class",
        "function",
        "method",
        "^if",
        "while",
        "for",
        "with",
        "func_literal",
        "block",
        "try",
        "except",
        "argument_list",
        "object",
        "dictionary"
    }
    --vim.cmd [[highlight IndentBlanklineChar guifg=#00FF00 gui=nocombine]]
    --vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#00FF00 gui=nocombine]]
    --vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=#00FF00 gui=nocombine]]
    --vim.cmd [[highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine]]
end

return M
