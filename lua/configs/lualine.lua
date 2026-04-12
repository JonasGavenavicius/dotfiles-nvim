local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
}

local function highlight_color(groups, attr, fallback)
  local names = type(groups) == "table" and groups or { groups }

  for _, name in ipairs(names) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and hl and hl[attr] then
      return string.format("#%06x", hl[attr])
    end
  end

  return fallback
end

local function width_at_least(width)
  return function()
    return vim.fn.winwidth(0) > width
  end
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  medium = width_at_least(90),
  wide = width_at_least(120),
  ultra = width_at_least(150),
  git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local function mode_color()
  local colors = {
    n = { "Function", "Directory" },
    i = { "String", "Character" },
    v = { "Constant", "Type" },
    [""] = { "Constant", "Type" },
    V = { "Constant", "Type" },
    c = { "Keyword", "Statement" },
    r = { "Type", "Statement" },
    R = { "Type", "Statement" },
    s = { "Special", "Identifier" },
    S = { "Special", "Identifier" },
    t = { "PreProc", "Identifier" },
  }

  return highlight_color(colors[vim.fn.mode()] or { "Identifier", "Function" }, "fg", "#8aadf4")
end

local function mode_label()
  local labels = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    [""] = "V-BLOCK",
    V = "V-LINE",
    c = "COMMAND",
    r = "PROMPT",
    R = "REPLACE",
    s = "SELECT",
    S = "S-LINE",
    t = "TERMINAL",
  }

  return labels[vim.fn.mode()] or vim.fn.mode():upper()
end

local function surface_color()
  return highlight_color({ "NormalFloat", "StatusLine", "Normal" }, "bg", "#24273a")
end

local function base_background()
  return highlight_color({ "Normal", "StatusLine" }, "bg", "#1e2030")
end

local function text_color()
  return highlight_color({ "Normal", "Identifier" }, "fg", "#cad3f5")
end

local function muted_color()
  return highlight_color({ "Comment", "LineNr" }, "fg", "#6e738d")
end

local function accent_color()
  return highlight_color({ "Type", "Identifier" }, "fg", "#c6a0f6")
end

local function info_color()
  return highlight_color({ "Special", "Type" }, "fg", "#91d7e3")
end

local function surface_spec(fg, extra)
  local spec = {
    fg = fg,
    bg = surface_color(),
  }

  if extra then
    for key, value in pairs(extra) do
      spec[key] = value
    end
  end

  return spec
end

local function current_lsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  return table.concat(names, ", ")
end

local function current_codeowner()
  local ok, codeowners = pcall(require, "codeowners")
  if not ok then
    return ""
  end

  local owner = codeowners.codeowners()
  if not owner or owner == "" then
    return ""
  end

  return owner
end

local function current_encoding()
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  return string.upper(encoding)
end

local function current_fileformat()
  return string.upper(vim.bo.fileformat)
end

local config = {
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = "",
    section_separators = "",
    disabled_filetypes = {
      statusline = { "alpha", "lazy" },
    },
  },
  sections = {
    lualine_a = {
      {
        function()
          return " " .. mode_label()
        end,
        color = function()
          return {
            fg = base_background(),
            bg = mode_color(),
            gui = "bold",
          }
        end,
        padding = { left = 1, right = 3 },
      },
    },
    lualine_b = {
      {
        "filename",
        path = 0,
        cond = conditions.buffer_not_empty,
        file_status = true,
        newfile_status = true,
        shorting_target = 40,
        symbols = {
          modified = " ●",
          readonly = " 󰌾",
          unnamed = "Untitled",
          newfile = " [new]",
        },
        color = function()
          return surface_spec(text_color(), { gui = "bold" })
        end,
        padding = { left = 2, right = 3 },
      },
    },
    lualine_c = {
      {
        "branch",
        icon = "",
        cond = conditions.git_workspace,
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 1, right = 3 },
      },
      {
        "diff",
        cond = function()
          return conditions.medium() and conditions.git_workspace()
        end,
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 0, right = 3 },
      },
      {
        "filetype",
        colored = true,
        icon_only = false,
        cond = conditions.wide,
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 0, right = 2 },
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = "󰌵 ",
        },
        color = function()
          return surface_spec(text_color())
        end,
        diagnostics_color = {
          error = function()
            return surface_spec(highlight_color({ "DiagnosticError", "ErrorMsg" }, "fg", "#ed8796"), { gui = "bold" })
          end,
          warn = function()
            return surface_spec(highlight_color({ "DiagnosticWarn", "WarningMsg" }, "fg", "#eed49f"), { gui = "bold" })
          end,
          info = function()
            return surface_spec(highlight_color({ "DiagnosticInfo", "Identifier" }, "fg", "#91d7e3"))
          end,
          hint = function()
            return surface_spec(highlight_color({ "DiagnosticHint", "Identifier" }, "fg", "#8bd5ca"))
          end,
        },
        padding = { left = 1, right = 3 },
      },
      {
        current_lsp,
        icon = "",
        cond = function()
          return current_lsp() ~= "" and conditions.wide()
        end,
        color = function()
          return surface_spec(accent_color(), { gui = "bold" })
        end,
        padding = { left = 0, right = 3 },
      },
      {
        current_codeowner,
        icon = "󰒇",
        cond = function()
          return conditions.ultra() and current_codeowner() ~= ""
        end,
        color = function()
          return surface_spec(info_color(), { gui = "bold" })
        end,
        padding = { left = 0, right = 2 },
      },
    },
    lualine_y = {
      {
        "filesize",
        cond = function()
          return conditions.wide() and conditions.buffer_not_empty()
        end,
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 1, right = 3 },
      },
      {
        current_fileformat,
        cond = function()
          return conditions.ultra() or current_fileformat() ~= "UNIX"
        end,
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 0, right = 3 },
      },
      {
        current_encoding,
        cond = function()
          return conditions.ultra() or current_encoding() ~= "UTF-8"
        end,
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 0, right = 2 },
      },
    },
    lualine_z = {
      {
        "progress",
        color = function()
          return surface_spec(muted_color())
        end,
        padding = { left = 1, right = 3 },
      },
      {
        "location",
        color = function()
          return surface_spec(text_color(), { gui = "bold" })
        end,
        padding = { left = 0, right = 1 },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 0,
        cond = conditions.buffer_not_empty,
        color = function()
          return { fg = muted_color() }
        end,
      },
    },
    lualine_x = {
      {
        "location",
        color = function()
          return { fg = muted_color() }
        end,
      },
    },
    lualine_y = {},
    lualine_z = {},
  },
}

M.config = function()
  local lualine = require("lualine")
  local group = vim.api.nvim_create_augroup("balanced_clarity_lualine", { clear = true })

  lualine.setup(config)

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      lualine.refresh()
    end,
  })
end

return M
