-- DAP keybindings
local M = {}

M.keys = function()
  return {
    { "<F2>",        function() require("dap").step_into() end,                      desc = "DAP step into" },
    { "<F3>",        function() require("dap").step_over() end,                      desc = "DAP step over" },
    { "<F4>",        function() require("dap").step_out() end,                       desc = "DAP step out" },
    { "<F5>",        function()
      local dap = require("dap")
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
    { "<F6>",        function() require("dap").terminate() end,                      desc = "DAP terminate" },
    { "<Leader>db",  function() require("dap").toggle_breakpoint() end,              desc = "Toggle breakpoint" },
    { "<Leader>dd",  function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
    { "<Leader>dlr", function() require("dap").run_last() end,                       desc = "Run last" },
    { "<Leader>du",  function() require("dapui").toggle() end,                       desc = "Toggle DAP UI" },
    { "<Leader>de",  function() require("dap").repl.open() end,                      desc = "Open DAP REPL" },
    { "<Leader>dlc", function() require("dap").run_to_cursor() end,                  desc = "Run to cursor" },
  }
end

return M
