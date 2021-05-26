local utils = require "utils"
local helper = require "vim_helper"

-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local execute = vim.api.nvim_command
local opt = utils.opt
local ENV_HOME = os.getenv('HOME')

-----------------------------------------------------------------------------//
-- Basics
-----------------------------------------------------------------------------//
if fn.has("multi_byte") then
    -- Let Vim use utf-8 internally, because many scripts require this
    opt.encoding = "utf-8"
    opt.fileencoding = "utf-8"

    -- Windows has traditionally used cp1252, so it's probably wise to
    -- fallback into cp1252 instead of eg. iso-8859-15.
    -- Newer Windows files might contain utf-8 or utf-16 LE so we might
    -- want to try them first.
    opt.fileencodings = "ucs-bom,utf-8,gbk,gb2312,cp936"
end

-----------------------------------------------------------------------------//
-- General
-----------------------------------------------------------------------------//
cmd [[filetype plugin indent on]]
cmd [[syntax on]]

-- cmd [[scriptencoding utf-8]]
vim.o.mouse = "a"
vim.o.history = 1000
vim.o.clipboard = 'unnamedplus'

-- Trim trailing whitespace and trailing blank lines on save
cmd [[
    function TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfunction
    command! TrimWhitespace call TrimWhitespace()
    function TrimTrailingLines()
        let lastLine = line('$')
        let lastNonblankLine = prevnonblank(lastLine)
        if lastLine > 0 && lastNonblankLine != lastLine
            silent! execute lastNonblankLine + 1 . ',$delete _'
        endif
    endfunction
    command! TrimTrailingLines call TrimTrailingLines()
    " function TrimTrailingLinesAlt()
    "     keeppatterns 0;/^\%(\n*.\)\@!/,$d
    " endfunction
    augroup trim_on_save
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> call TrimWhitespace()
    augroup END
]]

-----------------------------------------------------------------------------//
-- Indentation
-----------------------------------------------------------------------------//
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4 -- Let backspace delete indent
vim.o.shiftround = true -- Round indent
vim.o.joinspaces = false -- No double spaces with join after a dot


-----------------------------------------------------------------------------//
-- Display
-----------------------------------------------------------------------------//
vim.wo.number = true -- Print line number
vim.wo.relativenumber = true -- Relative line numbers
vim.wo.numberwidth = 2

vim.wo.signcolumn = 'yes:1' -- 'auto:1-2'
vim.wo.cursorline = true

vim.api.nvim_exec([[
    augroup cursorline_focus
        autocmd!
        autocmd WinEnter * setlocal cursorline
        autocmd WinLeave * setlocal nocursorline
    augroup END
    ]], false)

opt.linebreak = true -- wrap, but on words, not randomly
-- opt.textwidth = 80
opt.synmaxcol = 1024 -- don't syntax highlight long lines
vim.g.vimsyn_embed = 'lPr' -- allow embedded syntax highlighting for lua, python, ruby
vim.o.lazyredraw = true
vim.o.emoji = false -- turn off as they are treated as double width characters
-- vim.o.virtualedit = 'block' -- allow cursor to move past end of line in visual block mode
vim.o.list = true -- invisible chars
vim.o.listchars = utils.add {
    'eol: ', 'tab:→ ', 'extends:…', 'precedes:…', 'trail:·'
}
vim.wo.list = true
vim.o.shortmess = vim.o.shortmess .. 'I' -- disable :intro startup screen

opt.wrap = false
opt.autoindent = true

vim.o.showmode = true


-----------------------------------------------------------------------------//
-- Statusline
-----------------------------------------------------------------------------//
--
--if has_feature('statusline') then
--    vim.o.laststatus = 2
--    vim.o.statusline = "%<f\\%w%h%m%r\\ [%{&ff}/%Y] \\ [%{getcwd()}]%=%-14.(%l,%c%V%)\\ %p%%"
--end


-----------------------------------------------------------------------------//
-- Colorscheme
-----------------------------------------------------------------------------//
vim.o.background = "dark"
vim.o.termguicolors = true
cmd [[colorscheme badwolf]]


-----------------------------------------------------------------------------//
-- Motions & Text Objects
-----------------------------------------------------------------------------//
opt.iskeyword = utils.add('-', vim.bo.iskeyword) -- treat dash separated words as a word textobject

-----------------------------------------------------------------------------//
-- window splitting and buffers
-----------------------------------------------------------------------------//
vim.o.hidden = true -- Enable modified buffers in background
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current
vim.o.fillchars = utils.add {
    'vert:│', 'fold: ', 'diff:-', -- alternatives: ⣿ ░
    'msgsep:‾', 'foldopen:▾', 'foldsep:│', 'foldclose:▸'
}

-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
vim.o.wildignorecase = true -- Ignore case when completing file names and directories
vim.o.wildcharm = 26 -- equals set wildcharm=<C-Z>, used in the mapping section


-----------------------------------------------------------------------------//
-- Title
-----------------------------------------------------------------------------//
vim.o.titlestring = '❐ %t'
vim.o.titleold = '%{fnamemodify(getcwd(), ":t")}'
vim.o.title = true
vim.o.titlelen = 70


-----------------------------------------------------------------------------//
-- Folds
-----------------------------------------------------------------------------//
vim.o.foldtext = 'folds#render()'
vim.o.foldopen = utils.add(vim.o.foldopen, 'search')
vim.o.foldlevelstart = 10
vim.o.foldmethod = 'syntax'


-----------------------------------------------------------------------------//
-- Backup
-----------------------------------------------------------------------------//
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true -- Save undo history
vim.o.confirm = true -- prompt to save before destructive actions

-----------------------------------------------------------------------------//
-- Autocomplete
-----------------------------------------------------------------------------//
vim.o.complete = utils.add('kspell', vim.o.complete)
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.inccommand = 'nosplit'

function init_directories(home, prefix)
    local dir_list = {
        backup = 'backupdir',
        views = 'viewdir',
        swap = 'directory',
    }

    if has_feature('persistent_undo') then
        dir_list['undo'] = 'undodir'
    end

    for dirname, optname in pairs(dir_list) do
        local dir = home .. '/.' .. prefix .. dirname
        if fn.exists("*mkdir") then
            if fn.isdirectory(dir .. "/") == 0 then
                fn.mkdir(dir)
            end
            vim.o[optname] = dir .. "/"
        end
    end
end

init_directories(ENV_HOME, 'nvim')


-----------------------------------------------------------------------------//
-- FileTypes
-----------------------------------------------------------------------------//
cmd [[
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml,html,css setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell
]]


-----------------------------------------------------------------------------//
-- PLUGINS
-----------------------------------------------------------------------------//
require "plugins"


-----------------------------------------------------------------------------//
-- Key (re)Mappings
-----------------------------------------------------------------------------//
require "keymappings"
