-- Multi-service launcher keymaps
local M = {}

M.setup = function()
  local multi_service = require("utils.multi_service_launcher")
  local process_manager = require("utils.process_manager")
  local map = vim.keymap.set

  -- Multi-service management (Go only for now)
  map("n", "<leader>rm", function()
    if vim.bo.filetype == "go" then
      multi_service.launch_services()
    else
      vim.notify("Multi-service launcher only supported for Go", vim.log.levels.WARN)
    end
  end, { desc = "Launch multiple services" })

  map("n", "<leader>rs", function()
    if vim.bo.filetype == "go" then
      multi_service.start_service()
    else
      vim.notify("Service management only supported for Go", vim.log.levels.WARN)
    end
  end, { desc = "Start service" })

  map("n", "<leader>rk", multi_service.stop_service, { desc = "Stop service" })
  map("n", "<leader>rr", multi_service.restart_service, { desc = "Restart service" })
  map("n", "<leader>rK", process_manager.stop_all, { desc = "Stop all services" })
  map("n", "<leader>rl", process_manager.show_status_ui, { desc = "List services" })
end

return M
