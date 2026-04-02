local M = { 
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000,
  config = function()
    require("utils.theme_setup").configure("catppuccin", vim.g.ui_transparency_enabled == true)

    -- Setup must be called before loading the colorscheme
    vim.cmd.colorscheme("catppuccin")
  end
}

return M
