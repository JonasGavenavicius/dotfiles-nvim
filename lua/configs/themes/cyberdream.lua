local M = {
    "scottmckendry/cyberdream.nvim",
    name = "cyberdream",
    priority = 1000,
}

M.config = function()
    require("cyberdream").setup({
        -- Enable transparency management (theme-picker will control this)
        transparent = false,

        -- Theme appearance
        italic_comments = true,
        hide_fillchars = false,
        borderless_telescope = true,
        terminal_colors = true,
        cache = true,

        -- Use default variant (dark, high-contrast)
        theme = {
            variant = "default",
        },
    })

    -- Don't set colorscheme here - let theme picker handle it
end

return M
