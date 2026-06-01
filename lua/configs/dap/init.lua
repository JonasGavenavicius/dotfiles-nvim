-- DAP (Debug Adapter Protocol) configuration
local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "suketa/nvim-dap-ruby",
    "theHamsta/nvim-dap-virtual-text",
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
  },
  config = function()
    local dap = require("dap")
    local ok_dapui, dapui = pcall(require, "dapui")

    -- Setup plugins
    require("nvim-dap-virtual-text").setup({})
    if ok_dapui then
      dapui.setup()
    else
      vim.notify("Failed to load nvim-dap-ui", vim.log.levels.WARN)
    end

    -- Load language-specific DAP configurations
    require("configs.dap.go").setup(dap)
    require("configs.languages.ruby.dap").setup()
    require("configs.dap.rust").setup(dap)

    -- DAP UI auto open/close
    if ok_dapui then
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end
  end,
}

M.keys = function()
  return require("configs.dap.keys").keys()
end

return M
