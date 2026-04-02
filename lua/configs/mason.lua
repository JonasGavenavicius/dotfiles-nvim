local M = {
  'williamboman/mason.nvim',
  cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUpdate" },
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    "jay-babu/mason-nvim-dap.nvim",
  },
}

M.servers = {
  "lua_ls",
  "jsonls",
  "terraformls",
  "rust_analyzer",
  "ruby_lsp",
  "gopls",
}

M.dap_adapters = {
  "codelldb",
}

function M.config()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_installation = false,
    automatic_enable = false,
  })

  require("mason-nvim-dap").setup({
    ensure_installed = {},
    automatic_installation = false,
  })
end

return M
