-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "morhetz/gruvbox",
    config = function() vim.cmd.colorscheme "gruvbox" end,
  },
}
