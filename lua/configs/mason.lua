local M = {
  'williamboman/mason.nvim',
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

function M.config()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = M.servers,
    automatic_installation = true,
    handlers = {
      -- Default handler will be overridden by manual lspconfig.setup calls
      function(server_name)
        -- This ensures servers are installed but we configure them manually in lspconfig.lua
      end,
    },
  })

  require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb" }
  })
end

return M
