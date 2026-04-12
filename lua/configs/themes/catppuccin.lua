local M = { 
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000,
  config = function()
    require("utils.theme_setup").configure("catppuccin-macchiato", vim.g.ui_transparency_enabled == true)
  end
}

return M
