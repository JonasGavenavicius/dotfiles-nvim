local M = {}

local function transparency_enabled(override)
  if override ~= nil then
    return override
  end

  return vim.g.ui_transparency_enabled == true
end

local function catppuccin_flavour(theme_name)
  return theme_name:match("catppuccin%-([%w_]+)$") or "macchiato"
end

local function rose_pine_variant(theme_name)
  return theme_name:match("rose%-pine%-([%w_]+)$") or "main"
end

function M.configure(theme_name, transparent)
  transparent = transparency_enabled(transparent)

  if theme_name:match("catppuccin") then
    require("catppuccin").setup({
      flavour = catppuccin_flavour(theme_name),
      transparent_background = transparent,
      float = {
        transparent = false,
        solid = true,
      },
      integrations = {
        alpha = true,
        cmp = true,
        dap = true,
        fzf = true,
        dap_ui = true,
        mason = true,
        nvimtree = true,
        neotest = true,
        gitsigns = true,
        snacks = true,
        treesitter = true,
        notify = false,
        which_key = true,
        harpoon = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        telescope = {
          enabled = false,
          style = "nvchad",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
    })
  elseif theme_name:match("gruvbox") then
    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = transparent,
    })
  elseif theme_name:match("rose%-pine") then
    local variant = rose_pine_variant(theme_name)

    require("rose-pine").setup({
      variant = variant,
      dark_variant = variant,
      dim_inactive_windows = true,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = true,
        italic = true,
        transparency = transparent,
      },
      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",
        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",
        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",
        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },
      palette = {},
      highlight_groups = {},
      before_highlight = function() end,
    })
  elseif theme_name:match("cyberdream") then
    require("cyberdream").setup({
      transparent = transparent,
      italic_comments = true,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
      cache = true,
      theme = {
        variant = "default",
      },
    })
  end
end

return M
