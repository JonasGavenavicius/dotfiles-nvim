-- Ruby DAP configuration
local M = {}

M.setup = function()
  local ok, dap_ruby = pcall(require, "dap-ruby")
  if not ok then
    vim.notify("Failed to load nvim-dap-ruby", vim.log.levels.WARN)
    return
  end

  dap_ruby.setup()
end

return M
