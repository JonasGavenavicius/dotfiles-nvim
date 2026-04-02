local M = {}
local theme_setup = require("utils.theme_setup")
local DEFAULT_THEME = "catppuccin-mocha"

-- Transparency state
local transparency_enabled = false
local ui_registered = false

local function preference_paths()
    local data_path = vim.fn.stdpath("data")

    return data_path .. "/theme_preference.lua", data_path .. "/transparency_preference.lua"
end

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end

    local content = file:read("*a")
    file:close()

    return content
end

local function write_file(path, content)
    local file = io.open(path, "w")
    if not file then
        return false
    end

    file:write(content)
    file:close()

    return true
end

local function parse_saved_theme(content)
    if not content or content == "" then
        return nil
    end

    return content:match('return%s+["\']([^"\']+)["\']')
        or content:match('colorscheme%(["\']([^"\']+)["\']%)')
end

local function parse_saved_transparency(content)
    if not content then
        return nil
    end

    if content:match("return%s+true") then
        return true
    end

    if content:match("return%s+false") then
        return false
    end

    return nil
end

local function save_preferences(theme_cmd)
    local theme_path, transparency_path = preference_paths()

    write_file(theme_path, string.format("return %q\n", theme_cmd))
    write_file(transparency_path, string.format("return %s\n", tostring(transparency_enabled)))
end

local function apply_theme(theme_cmd)
    local target_theme = theme_cmd or DEFAULT_THEME

    vim.g.ui_transparency_enabled = transparency_enabled
    theme_setup.configure(target_theme, transparency_enabled)

    local ok = pcall(vim.cmd.colorscheme, target_theme)
    if not ok then
        target_theme = DEFAULT_THEME
        theme_setup.configure(target_theme, transparency_enabled)
        vim.cmd.colorscheme(target_theme)
    end

    vim.g.current_theme = target_theme

    return target_theme
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
    local applied_theme = apply_theme(theme_cmd)
    save_preferences(applied_theme)

    vim.notify("Theme changed to: " .. applied_theme, vim.log.levels.INFO)
end

-- Toggle transparency
function M.toggle_transparency()
    transparency_enabled = not transparency_enabled

    local current_theme = vim.g.current_theme or vim.g.colors_name or DEFAULT_THEME
    local applied_theme = apply_theme(current_theme)
    save_preferences(applied_theme)

    local status = transparency_enabled and "enabled" or "disabled"
    vim.notify("Transparency " .. status, vim.log.levels.INFO)
end

-- Load saved theme preference
function M.load_startup_theme()
    local theme_path, transparency_path = preference_paths()
    local saved_transparency = parse_saved_transparency(read_file(transparency_path))
    if saved_transparency ~= nil then
        transparency_enabled = saved_transparency
    end

    local saved_theme = parse_saved_theme(read_file(theme_path)) or DEFAULT_THEME
    apply_theme(saved_theme)
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

function M.register_ui()
    if ui_registered then
        return
    end

    ui_registered = true

    vim.api.nvim_create_user_command("ThemePicker", M.pick_theme, { desc = "Open theme picker" })
    vim.api.nvim_create_user_command("ThemeCycle", M.cycle_theme, { desc = "Cycle to next theme" })
    vim.api.nvim_create_user_command("ToggleTransparency", M.toggle_transparency, { desc = "Toggle theme transparency" })

    local map = vim.keymap.set
    map("n", "<leader>uh", M.pick_theme, { desc = "Theme picker" })
    map("n", "<leader>uc", M.cycle_theme, { desc = "Cycle theme" })
    map("n", "<leader>ut", M.toggle_transparency, { desc = "Toggle transparency" })
end

return M
