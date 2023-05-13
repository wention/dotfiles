local overrides = require "custom.plugins.overrides"

return {
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = overrides.treesitter
  },

  -- Override plugin config
  ["williamboman/mason.nvim"] = {
    override_options = overrides.mason
  },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
}
