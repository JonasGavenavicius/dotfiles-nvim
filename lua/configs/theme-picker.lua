local M = {}

-- Available themes with their display names and colorscheme commands
local themes = {
    {
        name = "Catppuccin",
        colorscheme = "catppuccin",
        variants = {
            { name = "Catppuccin Latte", cmd = "catppuccin-latte" },
            { name = "Catppuccin Frappe", cmd = "catppuccin-frappe" },
            { name = "Catppuccin Macchiato", cmd = "catppuccin-macchiato" },
            { name = "Catppuccin Mocha", cmd = "catppuccin-mocha" },
        }
    },
    {
        name = "Gruvbox",
        colorscheme = "gruvbox",
        variants = {
            { name = "Gruvbox Dark", cmd = "gruvbox" },
        }
    },
    {
        name = "Rose Pine",
        colorscheme = "rose-pine",
        variants = {
            { name = "Rose Pine Main", cmd = "rose-pine" },
            { name = "Rose Pine Moon", cmd = "rose-pine-moon" },
            { name = "Rose Pine Dawn", cmd = "rose-pine-dawn" },
        }
    },
}

-- Get all theme variants as a flat list
local function get_theme_list()
    local theme_list = {}
    for _, theme in ipairs(themes) do
        for _, variant in ipairs(theme.variants) do
            table.insert(theme_list, {
                display = variant.name,
                cmd = variant.cmd,
                base = theme.colorscheme,
            })
        end
    end
    return theme_list
end

-- Set theme and save preference
local function set_theme(theme_cmd)
    -- Apply the colorscheme
    vim.cmd.colorscheme(theme_cmd)
    
    -- Save the preference to a file for persistence
    local config_path = vim.fn.stdpath("data") .. "/theme_preference.lua"
    local file = io.open(config_path, "w")
    if file then
        file:write(string.format('vim.cmd.colorscheme("%s")\n', theme_cmd))
        file:close()
    end
    
    -- Update the global variable for statusline
    vim.g.current_theme = theme_cmd
    
    vim.notify("Theme changed to: " .. theme_cmd, vim.log.levels.INFO)
end

-- Load saved theme preference
local function load_saved_theme()
    local config_path = vim.fn.stdpath("data") .. "/theme_preference.lua"
    if vim.fn.filereadable(config_path) == 1 then
        dofile(config_path)
    else
        -- Default theme if no preference saved
        vim.cmd.colorscheme("catppuccin-mocha")
    end
end

-- Theme picker using vim.ui.select
function M.pick_theme()
    local theme_list = get_theme_list()
    local display_names = {}
    
    for _, theme in ipairs(theme_list) do
        table.insert(display_names, theme.display)
    end
    
    vim.ui.select(display_names, {
        prompt = "Select a theme:",
        format_item = function(item)
            return item
        end,
    }, function(choice, idx)
        if choice and idx then
            local selected_theme = theme_list[idx]
            set_theme(selected_theme.cmd)
        end
    end)
end

-- Cycle through themes
function M.cycle_theme()
    local theme_list = get_theme_list()
    local current_theme = vim.g.colors_name or "catppuccin-mocha"
    
    local current_idx = 1
    for i, theme in ipairs(theme_list) do
        if theme.cmd == current_theme then
            current_idx = i
            break
        end
    end
    
    -- Get next theme (wrap around)
    local next_idx = current_idx % #theme_list + 1
    set_theme(theme_list[next_idx].cmd)
end

-- Initialize theme system
function M.setup()
    -- Load saved theme on startup
    load_saved_theme()
    
    -- Create user commands
    vim.api.nvim_create_user_command("ThemePicker", M.pick_theme, { desc = "Open theme picker" })
    vim.api.nvim_create_user_command("ThemeCycle", M.cycle_theme, { desc = "Cycle to next theme" })
end

return M