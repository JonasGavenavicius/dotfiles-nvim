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

  return highlight_color(colors[vim.fn.mode()] or { "Identifier", "Function" }, "fg", "#7aa2f7")
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
          return "▍"
        end,
        color = function()
          return { fg = mode_color() }
        end,
        padding = { left = 0, right = 1 },
      },
      {
        function()
          return ""
        end,
        color = function()
          return { fg = mode_color(), gui = "bold" }
        end,
        padding = { left = 0, right = 1 },
      },
    },
    lualine_b = {
      {
        "filename",
        path = 0,
        cond = conditions.buffer_not_empty,
        file_status = true,
        newfile_status = true,
        symbols = {
          modified = " ●",
          readonly = " 󰌾",
          unnamed = "[No Name]",
          newfile = " [New]",
        },
        color = function()
          return {
            fg = highlight_color({ "Directory", "Title" }, "fg", "#7aa2f7"),
            gui = "bold",
          }
        end,
      },
    },
    lualine_c = {
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
      },
    },
    lualine_x = {
      {
        "branch",
        icon = "",
        cond = conditions.git_workspace,
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
      },
      {
        current_lsp,
        icon = "",
        cond = function()
          return current_lsp() ~= ""
        end,
        color = function()
          return {
            fg = highlight_color({ "Identifier", "Function" }, "fg", "#7aa2f7"),
            gui = "bold",
          }
        end,
      },
      {
        current_codeowner,
        icon = "󰒇",
        cond = function()
          return conditions.ultra() and current_codeowner() ~= ""
        end,
        color = function()
          return {
            fg = highlight_color({ "Special", "Type" }, "fg", "#c678dd"),
            gui = "bold",
          }
        end,
      },
    },
    lualine_y = {
      {
        "filesize",
        cond = function()
          return conditions.wide() and conditions.buffer_not_empty()
        end,
      },
      {
        current_fileformat,
        cond = function()
          return conditions.ultra() or current_fileformat() ~= "UNIX"
        end,
        color = function()
          return { fg = highlight_color({ "Comment", "LineNr" }, "fg", "#808080") }
        end,
      },
      {
        current_encoding,
        cond = function()
          return conditions.ultra() or current_encoding() ~= "UTF-8"
        end,
        color = function()
          return { fg = highlight_color({ "Comment", "LineNr" }, "fg", "#808080") }
        end,
      },
    },
    lualine_z = {
      {
        "location",
        padding = { left = 1, right = 1 },
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
      },
    },
    lualine_x = {
      { "location" },
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
