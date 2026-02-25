local M = {
  "echasnovski/mini.map",
  version = "*", -- Stable release
  event = "BufReadPre", -- Lazy load when opening buffer
  config = function()
    local map = require("mini.map")
    map.setup({
      -- Integrations with other plugins
      integrations = {
        map.gen_integration.builtin_search(), -- Show search results
        map.gen_integration.diagnostic({      -- Show LSP diagnostics
          error = "DiagnosticFloatingError",
          warn  = "DiagnosticFloatingWarn",
          info  = "DiagnosticFloatingInfo",
          hint  = "DiagnosticFloatingHint",
        }),
      },

      -- Symbols for visualization
      symbols = {
        encode = map.gen_encode_symbols.dot("4x2"), -- Braille-like encoding
        scroll_line = "█",
        scroll_view = "┃",
      },

      -- Window configuration
      window = {
        focusable = true,              -- Allow focusing minimap
        side = "right",                -- Position on right
        show_integration_count = true, -- Show integration counts
        width = 15,                    -- Width in columns
        winblend = 25,                 -- Transparency (matches theme)
      },
    })

    -- Keybindings (using <leader>um as minimap prefix)
    vim.keymap.set("n", "<leader>umt", function()
      map.toggle()
    end, { desc = "Toggle minimap" })

    vim.keymap.set("n", "<leader>umr", function()
      map.refresh()
    end, { desc = "Refresh minimap" })

    vim.keymap.set("n", "<leader>umf", function()
      map.toggle_focus()
    end, { desc = "Toggle minimap focus" })
  end,
}

return M
