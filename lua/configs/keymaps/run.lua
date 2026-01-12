-- Run and build commands for various filetypes
local M = {}

M.setup = function()
  local terminal_utils = require("utils.terminal")
  local map = vim.keymap.set

  -- Simple run (all languages)
  map("n", "<leader>rf", terminal_utils.run_current_file, { desc = "Run current file" })
  map("n", "<leader>rc", terminal_utils.run_with_arguments, { desc = "Run with arguments" })

  -- Smart project run (language-aware)
  map("n", "<leader>rp", terminal_utils.run_project, { desc = "Run project (smart)" })
  map("n", "<leader>ra", terminal_utils.run_project_with_arguments, { desc = "Run project with arguments" })
  map("n", "<leader>rb", terminal_utils.build_project, { desc = "Build project" })

  -- Smart debug (Go only for now)
  map("n", "<leader>rd", function()
    if vim.bo.filetype == "go" then
      require("dap").continue() -- Opens DAP config picker
    else
      vim.notify("Smart debug only supported for Go", vim.log.levels.WARN)
    end
  end, { desc = "Debug project (picker)" })
end

return M
