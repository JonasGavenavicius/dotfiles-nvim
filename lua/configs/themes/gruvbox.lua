local M = {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
}

M.config = function()
    require("utils.theme_setup").configure("gruvbox", vim.g.ui_transparency_enabled == true)
    
    -- Don't set colorscheme here - let theme picker handle it
end

return M
