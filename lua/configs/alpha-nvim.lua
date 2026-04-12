local M = {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- icons for dashboard
      "folke/snacks.nvim", -- for picker functionality
    },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[┌─────────────────────────────────────────────┐]],
        [[│  N E O V I M                                │]],
        [[│  focused surfaces, vivid syntax             │]],
        [[└─────────────────────────────────────────────┘]],
      }
      dashboard.section.header.opts.hl = "AlphaHeader"

      dashboard.section.buttons.val = {
        dashboard.button("r", "  Restore session", ":lua require('persistence').load({ last = true })<CR>"),
        dashboard.button("f", "󰱼  Find files", ":lua require('snacks').picker.files()<CR>"),
        dashboard.button("g", "󰺮  Search text", ":lua require('snacks').picker.grep({ regex = false })<CR>"),
        dashboard.button("p", "󰄉  Recent files", ":lua require('snacks').picker.recent()<CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("d", "󰕴  Diff view", ":DiffviewOpen<CR>"),
        dashboard.button("t", "  Theme picker", ":ThemePicker<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
      }
      dashboard.section.buttons.opts.spacing = 1
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
        button.opts.width = 40
        button.opts.cursor = 4
        button.opts.align_shortcut = "right"
      end

      local current_theme = vim.g.current_theme or vim.g.colors_name or "catppuccin-macchiato"
      dashboard.section.footer.val = {
        "",
        "Theme: " .. current_theme .. "  •  <space> to browse commands",
      }
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout = {
        { type = "padding", val = 4 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  }
}

return M
