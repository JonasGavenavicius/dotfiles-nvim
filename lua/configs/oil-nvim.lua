return {
  'stevearc/oil.nvim',
  cmd = { "Oil" },
  keys = {
    {
      "-",
      function()
        require("oil").open_float()
      end,
      desc = "Open parent directory",
    },
    {
      "<leader>ee",
      function()
        require("oil").open_float()
      end,
      desc = "Oil open parent directory",
    },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(vim.tbl_extend("force", opts or {}, {
      default_file_explorer = false,
    }))
  end,
}
