local M = {}

function M.config()
    require('bufferline').setup {
        options = {
            view = "multiwindow",
            numbers = "ordinal",
            number_style = "superscript",
            mappings = true,
            -- NOTE: this plugin is designed with this icon in mind,
            -- and so changing this is NOT recommended, this is intended
            -- as an escape hatch for people who cannot bear it for whatever reason
            indicator_icon = '▎',
            buffer_close_icon = '窱',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            tab_size = 18,
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
            -- NOTE: this will be called a lot so don't do any heavy processing here
            custom_filter = function(buf_number)
                -- filter out filetypes you don't want to see
                if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                    return true
                end
                -- filter out by buffer name
                if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                    return true
                end
                -- filter out based on arbitrary rules
                -- e.g. filter out vim wiki buffer from tabline in your work repo
                if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                    return true
                end
            end,
            offsets = {
                {filetype = "NvimTree", text = "File Explorer"},
                {filetype = "Outline", text = "Outline"}
            },
            show_buffer_icons = true, -- disable filetype icons for buffers
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { '|', '|' }
            separator_style = { 'any', 'any' }, -- "slant" | "thick" | "thin" | { 'any', 'any' },
            enforce_regular_tabs = true,
            always_show_bufferline = false,
            sort_by = 'directory',
            --sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
            --    -- add custom logic
            --    return buffer_a.modified > buffer_b.modified
            --end
        }
    }
    
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', '<Leader>[', ':BufferPrevious<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>]', ':BufferNext<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>x', ':BufferClose<CR>', opts)
end

return M
