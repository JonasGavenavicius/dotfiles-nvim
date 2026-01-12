-- Ruby DAP configuration
local M = {}

M.setup = function(dap)
  -- Ruby adapter
  dap.adapters.ruby = {
    type = "executable",
    command = "readapt",
    args = { "stdio" },
  }

  dap.configurations.ruby = {
    {
      type = "ruby",
      name = "Debug RSpec current file",
      request = "launch",
      program = "${file}",
      useBundler = true,
    },
  }
end

return M
