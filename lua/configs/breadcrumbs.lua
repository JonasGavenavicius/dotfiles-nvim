local M = {
    "LunarVim/breadcrumbs.nvim",
    lazy = true,
    event = "LspAttach",
    dependencies = {
        { "SmiteshP/nvim-navic" },
    },
}

M.config = function()
    require("nvim-navic").setup {
      lsp = {
          auto_attach = true,
      },
    }
    require("breadcrumbs").setup()
end

return M
