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

    local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'single',
    })
    vim.lsp.handlers['textDocument/hover'] = function(...)
        local buf = overridden_hover(...)
        vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>',
        {noremap = true, silent = true})
        -- TODO: close the floating window directly without having to execute wincmd p twice
    end

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = 'single' }
    )
end


function M.config()
    local home = os.getenv('HOME')
    vim.cmd [[packadd nvim-lspconfig]]
    vim.cmd [[packadd lsp-status.nvim]]
    -- vim.cmd [[packadd completion-nvim]]

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
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {'documentation', 'detail', 'additionalTextEdits'}
    }

    local on_attach = function(client, bufnr)
        lsp_status.on_attach(client)

        -- require('completion').on_attach(client, bufnr)

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
        buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('i', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', 'gr', '<Cmd>LspTroubleToggle lsp_references<CR>', opts)
        buf_set_keymap('n', 'gR', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>d', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = "single"})<CR>', opts)
        buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '[e', '<Cmd>lua vim.lsp.diagnostic.goto_prev({severity_limit = "Warning"})<CR>', opts)
        buf_set_keymap('n', ']e', '<Cmd>lua vim.lsp.diagnostic.goto_next({severity_limit = "Warning"})<CR>', opts)
        buf_set_keymap('n', '<space>q', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<leader>ls', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
        buf_set_keymap('n', '<leader>lS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
        vim.o.shortmess = vim.o.shortmess .. 'c'

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_formatting then
            -- vim.cmd [[
            --    augroup format_on_save
            --      autocmd! * <buffer>
            --      autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()
            --    augroup END
            --  ]]
        end

        if client.resolved_capabilities.document_range_formatting then
            buf_set_keymap('n', '<leader>f', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
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

        -- print('LSP attached.')
        vim.api.nvim_echo({ { 'LSP attached.' } }, false, {})
    end

    -- Python
    --[[
    lspconfig.pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150}
    }
    ]]

    lspconfig.pyls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150}
    }

    -- YAML
    -- https://github.com/redhat-developer/yaml-language-server
    lspconfig.yamlls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        settings = {
            yaml = {
                customTags = {
                    '!secret',
                    '!include_dir_named',
                    '!include_dir_list',
                    '!include_dir_merge_named',
                    '!include_dir_merge_list',
                    '!lambda',
                    '!input',
                },
                -- schemas = {kubernetes = {"*.yaml"}}
            },
        },
    }

    -- TYPESCRIPT
    -- https://github.com/theia-ide/typescript-language-server
    lspconfig.tsserver.setup {
        on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            on_attach(client)
        end,
        capabilities = capabilities,
        flags = { debounce_text_changes = 500 },
        commands = {
            OrganizeImports = {
                function()
                    local params = {
                        command = '_typescript.organizeImports',
                        arguments = { vim.api.nvim_buf_get_name(0) },
                        title = '',
                    }
                    vim.lsp.buf.execute_command(params)
                end,
            },
        },
    }

    -- GO
    lspconfig.gopls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
    }

    -- LUA
    local system_name
    if vim.fn.has 'mac' == 1 then
        system_name = 'macOS'
    elseif vim.fn.has 'unix' == 1 then
        system_name = 'Linux'
    end
    local sumneko_root_path = home .. '/dev/lua-language-server'
    local sumneko_binary = sumneko_root_path
        .. '/bin/'
        .. system_name
        .. '/lua-language-server'

    lspconfig.sumneko_lua.setup {
        cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = vim.split(package.path, ';'),
                },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                        [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
                    },
                },
                telemetry = { enable = false },
            },
        },
    }

    -- C / C++
    lspconfig.clangd.setup {
        -- cmd = {'clangd', '--background-index', '-xc++', '-Wall'},
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
    }

    -- LATEX
    lspconfig.texlab.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
    }

    -- JAVA
    _G.init_jdtls = function()
        vim.bo.shiftwidth = 4
        vim.wo.colorcolumn = '120'
        local settings = {
            ['java.format.settings.url'] = '~/bakdata/dependencies/format-bakdata-codestyle.xml',
            ['java.format.settings.profile'] = 'bakdata',
        }
        vim.cmd [[packadd nvim-jdtls]]
        require('jdtls').start_or_attach {
            cmd = {
                'jdtls',
                home .. '/bakdata/workspace/' .. vim.fn.fnamemodify(
                    vim.fn.getcwd(),
                    ':p:h:t'
                ),
            },
            on_attach = on_attach,
            capabilities = capabilities,
            flags = { debounce_text_changes = 150 },
            on_init = function(client, _)
                client.notify('workspace/didChangeConfiguration', {
                    settings = settings,
                })
            end,
            settings = settings,
        }

        -- vim.cmd [[
        --     augroup organize_imports_on_save
        --         autocmd! * <buffer>
        --         autocmd FileType java
        --         autocmd BufWritePre <buffer> lua require'jdtls'.organize_imports()
        --     augroup END
        --     ]]

    end

    -- vim.cmd [[
    --     augroup jdtls
    --         autocmd!
    --         autocmd FileType java lua init_jdtls()
    --     augroup END
    --     ]]

    -- EXTEND LSPCONFIG
    local lspconfigs = require 'lspconfig/configs'

    -- Markdown language server
    -- https://github.com/kitten/prosemd-lsp
    lspconfigs.prosemd = {
        default_config = {
            cmd = { 'prosemd-lsp', '--stdio' },
            filetypes = { 'markdown' },
            root_dir = function(fname)
                return lspconfig.util.find_git_ancestor(fname)
                    or vim.fn.getcwd()
            end,
            settings = {},
        },
    }

    lspconfig.prosemd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
    }

    -- vim.api.nvim_command 'noautocmd :edit'
    vim.cmd 'bufdo e'
end

return M
