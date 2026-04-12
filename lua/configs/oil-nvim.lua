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
  opts = {
    columns = { "icon" },
    win_options = {
      signcolumn = "no",
      cursorline = true,
      wrap = false,
    },
    float = {
      padding = 3,
      max_width = 0.72,
      max_height = 0.72,
      border = "rounded",
      preview_split = "right",
      win_options = {
        winblend = 0,
      },
      override = function(conf)
        conf.row = math.max(1, math.floor((vim.o.lines - conf.height) / 2) - 1)
        conf.col = math.max(0, math.floor((vim.o.columns - conf.width) / 2))
        return conf
      end,
    },
    confirmation = {
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    progress = {
      border = "rounded",
      minimized_border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    ssh = {
      border = "rounded",
    },
    keymaps_help = {
      border = "rounded",
    },
  },
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(vim.tbl_extend("force", opts or {}, {
      default_file_explorer = false,
    }))
  end,
}
