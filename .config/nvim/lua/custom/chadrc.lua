local M = {}
local userPlugins = require "custom.plugins"

M.options = {
   mapleader = ",",
}

M.ui = {}

M.plugins = {
  install = userPlugins,

  options = {
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },
}

M.mappings = {}

M.mappings.plugins = {
   nvimtree = {
      toggle = "<leader>e",
      focus = "",
   },
}

return M
