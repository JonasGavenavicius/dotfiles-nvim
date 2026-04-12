local M = {
  "LunarVim/breadcrumbs.nvim",
  lazy = true,
  event = "LspAttach",
  dependencies = {
    { "SmiteshP/nvim-navic" },
  },
}

M.config = function()
  local breadcrumbs = require("breadcrumbs")

  require("nvim-navic").setup({
    lsp = {
      auto_attach = true,
      preference = { "lua_ls" },
    },
    highlight = true,
    separator = "  ›  ",
    depth_limit = 4,
    safe_output = true,
  })

  breadcrumbs.winbar_filetype_exclude = vim.list_extend(breadcrumbs.winbar_filetype_exclude or {}, {
    "alpha",
    "lazy",
    "NvimTree",
    "oil",
    "trouble",
  })

  local default_get_filename = breadcrumbs.get_filename
  breadcrumbs.get_filename = function()
    local value = default_get_filename()
    if not value or value == "" then
      return value
    end

    local relative_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
    local directory = vim.fn.fnamemodify(relative_path, ":h")
    if directory == "." or directory == "" then
      return value
    end

    local formatted_directory = vim.fn.winwidth(0) > 120 and directory or vim.fn.pathshorten(directory)
    local path_hint = "%#Comment#" .. formatted_directory .. "/%* "

    return value:gsub("%%#WinBar#", path_hint .. "%#WinBar#", 1)
  end

  breadcrumbs.setup()
end

return M
