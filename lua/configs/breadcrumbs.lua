local M = {
  "SmiteshP/nvim-navic",
  event = "LspAttach",
}

local excluded_filetypes = {
  alpha = true,
  lazy = true,
  NvimTree = true,
  oil = true,
  trouble = true,
}

function M.winbar()
  if excluded_filetypes[vim.bo.filetype] then
    return ""
  end

  local buffer_name = vim.api.nvim_buf_get_name(0)
  if buffer_name == "" then
    return ""
  end

  local relative_path = vim.fn.fnamemodify(buffer_name, ":~:.")
  local directory = vim.fn.fnamemodify(relative_path, ":h")
  local filename = vim.fn.fnamemodify(relative_path, ":t")
  local path_hint = ""

  if directory ~= "." and directory ~= "" then
    local formatted_directory = vim.fn.winwidth(0) > 120 and directory or vim.fn.pathshorten(directory)
    path_hint = "%#Comment#" .. formatted_directory .. "/%* "
  end

  local location = ""
  local ok, navic = pcall(require, "nvim-navic")
  if ok and navic.is_available() then
    location = navic.get_location({
      highlight = true,
      separator = "  ›  ",
      depth_limit = 4,
      safe_output = true,
    })
  end

  if location ~= "" then
    return path_hint .. "%#WinBar#" .. filename .. "%*  ›  " .. location
  end

  return path_hint .. "%#WinBar#" .. filename .. "%*"
end

M.config = function()
  local navic = require("nvim-navic")

  navic.setup({
    highlight = true,
    separator = "  ›  ",
    depth_limit = 4,
    safe_output = true,
  })

  local function attach(client, bufnr)
    if client and client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("NavicAttach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      attach(client, args.buf)
    end,
  })

  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    attach(client, bufnr)
  end

  vim.o.winbar = "%{%v:lua.require'configs.breadcrumbs'.winbar()%}"
end

return M
