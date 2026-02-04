local M = {}

-- Transparency state
local transparency_enabled = false

-- Theme-specific transparency configurations
local function configure_theme_transparency(theme_cmd, transparent)
    if theme_cmd:match("catppuccin") then
        local ok, catppuccin = pcall(require, "catppuccin")
        if ok then
            catppuccin.setup({
                transparent_background = transparent,
            })
        end
    elseif theme_cmd:match("gruvbox") then
        if transparent then
            vim.g.gruvbox_transparent_bg = 1
        else
            vim.g.gruvbox_transparent_bg = 0
        end
    elseif theme_cmd:match("rose-pine") then
        local ok, rose_pine = pcall(require, "rose-pine")
        if ok then
            rose_pine.setup({
                styles = {
                    transparency = transparent,
                },
            })
        end
    elseif theme_cmd:match("cyberdream") then
        local ok, cyberdream = pcall(require, "cyberdream")
        if ok then
            cyberdream.setup({
                transparent = transparent,
                italic_comments = true,
                borderless_telescope = true,
                terminal_colors = true,
                cache = true,
                theme = {
                    variant = "default",
                },
            })
        end
    end
end

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
    {
        name = "Cyberdream",
        colorscheme = "cyberdream",
        variants = {
            { name = "Cyberdream", cmd = "cyberdream" },
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
    -- Configure theme transparency before applying
    configure_theme_transparency(theme_cmd, transparency_enabled)
    
    -- Apply the colorscheme
    vim.cmd.colorscheme(theme_cmd)
    
    -- Save the preference to a file for persistence
    local config_path = vim.fn.stdpath("data") .. "/theme_preference.lua"
    local transparency_path = vim.fn.stdpath("data") .. "/transparency_preference.lua"
    
    local file = io.open(config_path, "w")
    if file then
        file:write(string.format('vim.cmd.colorscheme("%s")\n', theme_cmd))
        file:close()
    end
    
    -- Save transparency state
    local trans_file = io.open(transparency_path, "w")
    if trans_file then
        trans_file:write(string.format('return %s\n', tostring(transparency_enabled)))
        trans_file:close()
    end
    
    -- Update the global variable for statusline
    vim.g.current_theme = theme_cmd
    
    vim.notify("Theme changed to: " .. theme_cmd, vim.log.levels.INFO)
end

-- Toggle transparency
function M.toggle_transparency()
    transparency_enabled = not transparency_enabled
    
    -- Reapply current theme with new transparency setting
    local current_theme = vim.g.colors_name or "catppuccin-mocha"
    set_theme(current_theme)
    
    local status = transparency_enabled and "enabled" or "disabled"
    vim.notify("Transparency " .. status, vim.log.levels.INFO)
end

-- Load saved theme preference
local function load_saved_theme()
    -- Load transparency preference
    local transparency_path = vim.fn.stdpath("data") .. "/transparency_preference.lua"
    if vim.fn.filereadable(transparency_path) == 1 then
        transparency_enabled = dofile(transparency_path)
    end
    
    local config_path = vim.fn.stdpath("data") .. "/theme_preference.lua"
    if vim.fn.filereadable(config_path) == 1 then
        dofile(config_path)
        -- Apply transparency to loaded theme
        local current_theme = vim.g.colors_name or "catppuccin-mocha"
        configure_theme_transparency(current_theme, transparency_enabled)
    else
        -- Default theme if no preference saved
        configure_theme_transparency("catppuccin-mocha", transparency_enabled)
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
    vim.api.nvim_create_user_command("ToggleTransparency", M.toggle_transparency, { desc = "Toggle theme transparency" })
    
    -- Set up keymaps
    local map = vim.keymap.set
    map("n", "<leader>uh", M.pick_theme, { desc = "Theme picker" })
    map("n", "<leader>uc", M.cycle_theme, { desc = "Cycle theme" })
    map("n", "<leader>ut", M.toggle_transparency, { desc = "Toggle transparency" })
end

return M