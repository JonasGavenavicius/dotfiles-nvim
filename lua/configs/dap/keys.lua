-- DAP keybindings
local M = {}

M.keys = function()
  local dap = require("dap")
  local dapui = require("dapui")

  return {
    { "<F2>",        function() dap.step_into() end,                                 desc = "DAP step into" },
    { "<F3>",        function() dap.step_over() end,                                 desc = "DAP step over" },
    { "<F4>",        function() dap.step_out() end,                                  desc = "DAP step out" },
    { "<F5>",        function()
      if dap.session() then
        -- During debug: continue execution
        dap.continue()
      else
        -- Not debugging: auto-start with first config (Debug with executable picker)
        if vim.bo.filetype == "go" and dap.configurations.go then
          dap.run(dap.configurations.go[1])
        else
          -- Fallback to standard continue for other languages
          dap.continue()
        end
      end
    end, desc = "DAP continue / Quick start" },
    { "<F6>",        function() dap.terminate() end,                                 desc = "DAP terminate" },
    { "<Leader>db",  function() dap.toggle_breakpoint() end,                         desc = "Toggle breakpoint" },
    { "<Leader>dd",  function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
    { "<Leader>dlr", function() dap.run_last() end,                                  desc = "Run last" },
    { "<Leader>du",  function() dapui.toggle() end,                                  desc = "Toggle DAP UI" },
    { "<Leader>de",  function() dap.repl.open() end,                                 desc = "Open DAP REPL" },
    { "<Leader>dlc", function() dap.run_to_cursor() end,                             desc = "Run to cursor" },
  }
end

return M
