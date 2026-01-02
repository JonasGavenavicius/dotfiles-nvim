-- DAP helper functions for smart debugging
local M = {}

-- Smart Go debugging with executable selection
function M.debug_go_smart()
  local dap = require("dap")
  local go_utils = require("utils.languages.go")

  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file", vim.log.levels.WARN)
    return
  end

  local project_root = go_utils.find_project_root(file)
  if not project_root then
    vim.notify("No Go project root found", vim.log.levels.WARN)
    return
  end

  local executables = go_utils.find_executables(project_root)

  if #executables == 0 then
    vim.notify("No executables found", vim.log.levels.WARN)
    return
  end

  local function start_debug(exec)
    local program_path
    if exec.relative == "." then
      program_path = project_root
    else
      program_path = project_root .. "/" .. exec.relative
    end

    dap.run({
      type = "go",
      name = "Debug: " .. exec.name,
      request = "launch",
      program = program_path,
      cwd = project_root,
      stopOnEntry = false,
    })
  end

  if #executables == 1 then
    start_debug(executables[1])
  else
    local items = {}
    for _, exec in ipairs(executables) do
      local display = string.format("%s (%s)", exec.name, exec.relative)
      table.insert(items, display)
    end

    vim.ui.select(items, {
      prompt = "Select executable to debug:",
    }, function(choice, idx)
      if choice and idx then
        start_debug(executables[idx])
      end
    end)
  end
end

return M
