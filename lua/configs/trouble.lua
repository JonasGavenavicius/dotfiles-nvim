local M = {
  "folke/trouble.nvim",
  cmd = { "Trouble" }, -- Lazy load on command
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    modes = {
      -- Workspace diagnostics - shows ALL files in project
      diagnostics = {
        mode = "diagnostics",
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
      },
    },
    -- Icons for diagnostic severity
    icons = {
      indent = {
        middle = "├╴",
        last = "└╴",
        top = "│ ",
        ws = "  ",
      },
      folder_closed = " ",
      folder_open = " ",
    },
    -- Focus on trouble window when opened
    focus = true,
    -- Auto close when no diagnostics
    auto_close = false,
    -- Auto refresh when diagnostics change
    auto_refresh = true,
  },
  keys = {
    -- Project-wide diagnostics (ALL files)
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    -- Current buffer diagnostics only
    {
      "<leader>xb",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    -- Show only errors across project
    {
      "<leader>xe",
      "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
      desc = "Errors Only (Trouble)",
    },
    -- Quickfix list in Trouble
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    -- Location list in Trouble
    {
      "<leader>xl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
  },
}

return M
