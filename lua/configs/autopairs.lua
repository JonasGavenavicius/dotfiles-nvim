local M = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    fast_wrap = {},
    disable_filetype = { "vim" },
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
  end,
}

return M
