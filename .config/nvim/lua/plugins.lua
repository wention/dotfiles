vim.o.runtimepath = '/Users/wention/.config/nvim-lua,' .. vim.o.runtimepath

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd('!git clone https://github.com/wbthomason/packer.nvim' .. ' ' ..
                install_path)
end
vim.cmd 'packadd packer.nvim'
-- auto compile
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'


return require('packer').startup(function(use)
  -- Packer can manage itself
  use {'wbthomason/packer.nvim', opt = true}

  -- Treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      event = {'BufRead', 'BufNewFile'},
      requires = {
          {
              'nvim-treesitter/nvim-treesitter-refactor',
              after = 'nvim-treesitter'
          },
          {
              'nvim-treesitter/nvim-treesitter-textobjects',
              after = 'nvim-treesitter'
          }
      },
      config = require('config/nvim-treesitter').config,
      run = ':TSUpdate'
  }

  use {'windwp/nvim-ts-autotag', opt = true}

  -- Explorer
  use {
      'kyazdani42/nvim-tree.lua',
      opt = true,
      cmd = {'NvimTreeOpen', 'NvimTreeToggle'},
      setup = require('config/nvim_tree').setup,
      config = require('config/nvim_tree').config,
      requires = {'kyazdani42/nvim-web-devicons'}
  }


  use {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      config = require('config/gitsigns').config,
      requires = { 'nvim-lua/plenary.nvim' },
  }

  use {'folke/which-key.nvim', opt = true}
  use {
      'kevinhwang91/nvim-bqf',
      event = { 'BufWinEnter quickfix' },
      config = require('config/nvim-bqf').config,
  }


  use {
      'steelsojka/pears.nvim',
      event = { 'BufRead' },
      config = require('config/pears').config,
  }
  use {
      'blackCauldron7/surround.nvim',
      event = { 'BufRead', 'BufNewFile' },
      config = require('config/surround').config,
  }

  use {
      'folke/trouble.nvim',
      cmd = { 'Trouble', 'TroubleToggle' },
      setup = require('config/trouble').setup,
      config = require('config/trouble').config,
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }


  use {
      'phaazon/hop.nvim',
      cmd = { 'HopWord', 'HopChar1', 'HopPattern' },
      setup = require('config/hop').setup
  }


  -- Comment
  use {
      'b3nj5m1n/kommentary',
      event = { 'BufRead', 'BufNewFile' },
      setup = require('config/kommentary').setup,
      config = require('config/kommentary').config
  }

  -- LSP
  use {
      'neovim/nvim-lspconfig',
      opt = true,
      event = {'BufRead'},
      setup = require('config/lsp').setup,
      config = require('config/lsp').config,
      requires = {
            {'nvim-lua/lsp-status.nvim', opt = true},
            {'nvim-lua/lsp_extensions.nvim', opt = true},
            {'kosayoda/nvim-lightbulb', opt = true}
        }

  }

  -- use {
  --     'simrat39/symbols-outline.nvim',
  --     cmd = {'SymbolsOutline'},
  --     setup = require('config/symbols-outline').setup,
  --     config = require('config/symbols-outline').config
  -- }

  use {
      'liuchengxu/vista.vim',
      cmd = {'Vista'},
      setup = require('config/vista').setup,
      config = require('config/vista').config
  }

  use {
      'glepnir/lspsaga.nvim',
      opt = true
  }

  -- Autocomplete
  --[[
  use {
      'nvim-lua/completion-nvim',
      opt = true,
      after = {'nvim-lspconfig'},
      event = {'InsertEnter'},
      setup = require('config/completion-nvim').setup,
      config = require('config/completion-nvim').config,
  }
  --]]

  use {
      'hrsh7th/nvim-compe',
      event = { 'InsertEnter' },
      config = require('config/compe').config,
      after = 'LuaSnip',
  }

  use {
      'L3MON4D3/LuaSnip',
      opt = true,
      event = { 'InsertEnter' },
      config = function()
          require 'config/LuaSnip'
      end,
      requires = { 'rafamadriz/friendly-snippets', opt = true }
  }

  -- Telescope
  use {
      'nvim-telescope/telescope.nvim',
      opt = true,
      event = { 'VimEnter' },
      setup = require('config/telescope').setup,
      config = require('config/telescope').config,
      requires = {
          {'nvim-lua/popup.nvim'},
          {'nvim-lua/plenary.nvim'}
      }
  }

  use {
      'nvim-telescope/telescope-fzy-native.nvim',
      after = {'telescope.nvim'},
      config = function()
          require('telescope').load_extension('fzy_native')
      end,
      disable = true
  }

  --[[
  use {
      'nvim-telescope/telescope-dap.nvim',
      after = {'telescope.nvim', 'nvim-dap'},
      config = function()
          require('telescope').load_extension('dap')
      end
  }

  use {
      'nvim-telescope/telescope-github.nvim',
      after = {'telescope.nvim'},
      config = function()
          require('telescope').load_extension('gh')
      end
  }
  --]]


  -- Debugging
  use {
      'mfussenegger/nvim-dap',
      opt = true,
      ft = {'python'},
      requires = {
          {'mfussenegger/nvim-dap-python', opt = true},
          {
              'theHamsta/nvim-dap-virtual-text',
              opt = true,
              after = 'nvim-treesitter'
          }
      },
      setup = require('config/nvim-dap').setup,
      config = require('config/nvim-dap').config
  }


  -------------------------------------------------------
  -- UI
  -------------------------------------------------------

  -- Color
  use {
      'npxbr/gruvbox.nvim',
      config = function()
          vim.cmd 'colorscheme gruvbox'
      end,
      requires = {'rktjmp/lush.nvim'}
  }

  -- Icons

  -- Status Line and Bufferline
  use {
      'glepnir/galaxyline.nvim',
      opt = true,
      branch = 'main',
      event = {'VimEnter'},
      config = function() require('config/statusline') end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {
      'lukas-reineke/indent-blankline.nvim',
      opt = true,
      branch = 'lua',
      event = {'VimEnter'},
      setup = require('config/indent_blankline').setup,
  }

  use {
      'akinsho/nvim-bufferline.lua',
      event = {'VimEnter'},
      config = require('config/nvim_bufferline').config,
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      disable = true
  }

  use {
      'romgrk/barbar.nvim',
      event = { 'VimEnter' },
      setup = require('config/barbar').setup,
      config = require('config/barbar').config,
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  end
)
