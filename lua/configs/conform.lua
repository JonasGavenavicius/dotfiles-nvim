local M = {
  "stevearc/conform.nvim",
}

M.config = function()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      go = { "gofumpt", "goimports" },
      lua = { "stylua" },
      ruby = { "rubocop" },
      rust = { "rustfmt" },
    },
    format_after_save = {
      lsp_format = "fallback",
      async = true,
      timeout_ms = 1000,
    },
  })
end

return M
