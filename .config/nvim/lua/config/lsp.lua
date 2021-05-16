local M = {}

function M.setup()
    vim.fn.sign_define('LspDiagnosticsSignError',
                       {text = '◉', texthl = 'LspDiagnosticsDefaultError'})
    vim.fn.sign_define('LspDiagnosticsSignWarning',
                       {text = '●', texthl = 'LspDiagnosticsDefaultWarning'})
    vim.fn.sign_define('LspDiagnosticsSignInformation', {
        text = '•',
        texthl = 'LspDiagnosticsDefaultInformation'
    })
    vim.fn.sign_define('LspDiagnosticsSignHint',
                       {text = '·', texthl = 'LspDiagnosticsDefaultHint'})
    vim.fn.sign_define('LightBulbSign', {
        text = '◎',
        texthl = 'LightBulb',
        linehl = '',
        numhl = ''
    })
    
    -- symbols for autocomplete
    vim.lsp.protocol.CompletionItemKind = {
        "   (Text) ",
        "   (Method)",
        "   (Function)",
        "   (Constructor)",
        " ﴲ  (Field)",
        "[] (Variable)",
        "   (Class)",
        " ﰮ  (Interface)",
        "   (Module)",
        " 襁 (Property)",
        "   (Unit)",
        "   (Value)",
        " 練 (Enum)",
        "   (Keyword)",
        "   (Snippet)",
        "   (Color)",
        "   (File)",
        "   (Reference)",
        "   (Folder)",
        "   (EnumMember)",
        " ﲀ  (Constant)",
        " ﳤ  (Struct)",
        "   (Event)",
        "   (Operator)",
        "   (TypeParameter)"
    }

    vim.cmd [[packadd lsp_extensions.nvim]]
    vim.lsp.handlers['textDocument/publishDiagnostics'] =
        vim.lsp.with(require('lsp_extensions.workspace.diagnostic').handler, {
            underline = false,
            signs = true,
            -- signs = {severity_limit = 'Information'},
            virtual_text = {
                spacing = 4,
                prefix = '■', -- ■ 
                severity_limit = 'Warning'
            },
            update_in_insert = false -- delay update
        })

    -- Handle formatting in a smarter way
    -- If the buffer has been edited before formatting has completed, do not try to
    -- apply the changes, by Lukas Reineke
    vim.lsp.handlers['textDocument/formatting'] =
        function(err, _, result, _, bufnr) -- FIXME: bufnr is nil
            if err ~= nil or result == nil then return end

            -- If the buffer hasn't been modified before the formatting has finished,
            -- update the buffer
            if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
                local view = vim.fn.winsaveview()
                vim.lsp.util.apply_text_edits(result, bufnr)
                vim.fn.winrestview(view)
                -- FIXME: commented out as a workaround
                -- if bufnr == vim.api.nvim_get_current_buf() then
                vim.api.nvim_command('noautocmd :update')

                -- Trigger post-formatting autocommand which can be used to refresh gitgutter
                vim.api.nvim_command(
                    'silent doautocmd <nomodeline> User FormatterPost')
                -- end
            end
        end

    local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover,
                                          {border = 'single'})
    vim.lsp.handlers['textDocument/hover'] =
        function(...)
            local buf = overridden_hover(...)
            vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>',
                                        {noremap = true, silent = true})
            -- TODO: close the floating window directly without having to execute wincmd p twice
        end

    vim.lsp.handlers['textDocument/signatureHelp'] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'single'})
end


function M.config()
    local home = os.getenv('HOME')
    vim.cmd [[packadd nvim-lspconfig]]
    vim.cmd [[packadd lsp-status.nvim]]
    vim.cmd [[packadd completion-nvim]]

    local lspconfig = require 'lspconfig'
    local lsp_status = require 'lsp-status'
    lsp_status.config({
        status_symbol = '',
        indicator_ok = '',
        diagnostics = false,
        current_function = false
    })
    lsp_status.register_progress()

    -- client log level
    vim.lsp.set_log_level('debug')
    local capabilities = lsp_status.capabilities
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport =
        {properties = {'documentation', 'detail', 'additionalTextEdits'}}

    local on_attach = function(client, bufnr)
        lsp_status.on_attach(client)

        require('completion').on_attach(client, bufnr)

        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- omni completion source
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        local opts = {noremap = true, silent = true}
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                       opts)
        buf_set_keymap('n', '<C-s>',
                       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('i', '<C-s>',
                       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa',
                       '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr',
                       '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                       opts)
        buf_set_keymap('n', '<space>wl',
                       '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                       opts)
        buf_set_keymap('n', '<space>D',
                       '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>',
                       opts)
        buf_set_keymap('n', 'gr', '<cmd>LspTroubleToggle lsp_references<CR>',
                       opts)
        buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>d',
                       '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = "single"})<CR>',
                       opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                       opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                       opts)
        buf_set_keymap('n', '[e',
                       '<cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit = "Warning"})<CR>',
                       opts)
        buf_set_keymap('n', ']e',
                       '<cmd>lua vim.lsp.diagnostic.goto_next({severity_limit = "Warning"})<CR>',
                       opts)
        buf_set_keymap('n', '<space>q',
                       '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<leader>ls',
                       '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
        buf_set_keymap('n', '<leader>lS',
                       '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
        vim.o.shortmess = vim.o.shortmess .. 'c'

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_formatting then
            vim.cmd [[
                augroup format_on_save
                  autocmd! * <buffer>
                  autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()
                augroup END
              ]]
        end

        if client.resolved_capabilities.document_range_formatting then
            buf_set_keymap('n', '<leader>f',
                           '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
        end

        if client.resolved_capabilities.document_highlight then
            vim.cmd [[
                augroup lsp_document_highlight
                  autocmd! * <buffer>
                  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
              ]]
        end

        _G.show_lightbulb = function()
            require'nvim-lightbulb'.update_lightbulb {
                sign = {enabled = false, priority = 99},
                virtual_text = {enabled = true, text = '💡 '}
            }
        end

        if client.resolved_capabilities.code_action then
            vim.cmd [[packadd nvim-lightbulb]]
            vim.cmd [[autocmd CursorHold,CursorHoldI * if &ft != 'java' | lua show_lightbulb()]]
            buf_set_keymap('n', '<leader>a',
                           '<cmd>lua require\'telescope.builtin\'.lsp_code_actions()<CR>',
                           opts)
        end

        vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({border = 'single'})]]
        vim.cmd [[
            augroup lsp_signature_help
                autocmd! * <buffer>
                autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.signature_help({border = 'single'})
            augroup END
        ]]
        -- vim.cmd [[
        --     augroup lsp_signature_help
        --         autocmd! * <buffer>
        --         autocmd CursorHoldI <buffer> silent! :Lspsaga signature_help
        --     augroup END
        -- ]]

        print('LSP attached.')
    end

    -- C/C++
    lspconfig.clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150}
    }

    -- Python
    lspconfig.pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150}
    }

    vim.api.nvim_command('noautocmd :edit') -- reload file to attach LSP
end

return M
