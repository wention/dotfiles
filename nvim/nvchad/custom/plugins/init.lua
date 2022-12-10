return {
  -- Override plugin config
  ["williamboman/mason.nvim"] = {
    override_options = {
          ensure_installed = { "html-lsp", "clangd" }
      }
  },
}
