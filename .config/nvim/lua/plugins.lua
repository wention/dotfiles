vim.o.runtimepath = '/Users/wention/.config/nvim-lua,' .. vim.o.runtimepath

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd ('!git clone https://github.com/wbthomason/packer.nvim' .. ' ' ..
                install_path)
end
vim.cmd [[packadd packer.nvim]]
-- auto compile
vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]


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
      run = ':TSUpdate',
  }
  use {"windwp/nvim-ts-autotag", opt = true}

  -- Explorer
  use {
      'kyazdani42/nvim-tree.lua',
      opt = true,
      cmd = {'NvimTreeOpen', 'NvimTreeToggle'},
      setup = require('config/nvim_tree').setup,
      config = require('config/nvim_tree').config,
      requires = {'kyazdani42/nvim-web-devicons'}
    }

  use "kevinhwang91/rnvimr"

  -- use {'lukas-reineke/indent-blankline.nvim', opt=true, branch = 'lua'}
  use {"lewis6991/gitsigns.nvim", opt = true}
  -- use {"liuchengxu/vim-which-key", opt = true}
  use {"folke/which-key.nvim", opt = true}
  use {"ChristianChiarulli/dashboard-nvim", opt = true}
  use {"windwp/nvim-autopairs", opt = true}
  use {"terrortylor/nvim-comment", opt = true}
  use {"kevinhwang91/nvim-bqf", opt = true}

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

  -- after = {'nvim-lua/completion-nvim'},

  use {
      'glepnir/lspsaga.nvim',
      opt = true,
  }

  -- Autocomplete
  use {
      'nvim-lua/completion-nvim',
      opt = true,
      after = {'nvim-lspconfig'},
      event = {'InsertEnter'},
      setup = require('config/completion-nvim').setup,
      config = require('config/completion-nvim').config,
  }

  use {'hrsh7th/vim-vsnip', opt = true}
  use {'rafamadriz/friendly-snippets', opt = true}

  -- Telescope
  use {
      'nvim-telescope/telescope.nvim',
      opt = true,
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
  }
  use {
      'nvim-telescope/telescope-fzy-native.nvim',
      after = {'telescope.nvim'},
      config = function()
          require('telescope').load_extension('fzy_native')
      end
  }
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
  use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}

  -- Icons
  --use {"kyazdani42/nvim-web-devicons", opt = true}

  -- Status Line and Bufferline
  use {
        'glepnir/galaxyline.nvim',
        opt = true,
        branch = 'main',
        event = {'VimEnter'},
        config = function() require('config/statusline') end,
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

  -- use {"romgrk/barbar.nvim", opt = true}
  use {
      'akinsho/nvim-bufferline.lua',
      event = {'VimEnter'},
      config = require('config.nvim_bufferline').config,
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }

  use {
      'lukas-reineke/indent-blankline.nvim',
      opt = true,
      branch = 'lua',
      event = {'VimEnter'},
      setup = require('config/indent_blankline').setup
  }

  end
)
