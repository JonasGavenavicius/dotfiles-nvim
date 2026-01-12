-- DAP (Debug Adapter Protocol) configuration
local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "suketa/nvim-dap-ruby",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup plugins
    require("nvim-dap-virtual-text").setup({})
    dapui.setup()

    -- Load language-specific DAP configurations
    require("configs.dap.go").setup(dap)
    require("configs.languages.ruby.dap").setup(dap)
    require("configs.dap.rust").setup(dap)

    -- Setup dap-ruby plugin
    require("dap-ruby").setup()

    -- DAP UI auto open/close
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
  end,
}

M.keys = function()
  return require("configs.dap.keys").keys()
end

return M
