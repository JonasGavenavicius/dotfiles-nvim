-- Go DAP configuration
local M = {}

-- Find dlv in PATH, GOPATH, or common locations
local function find_dlv()
  -- Try PATH first
  if vim.fn.executable("dlv") == 1 then
    return "dlv"
  end

  -- Try GOPATH/bin
  local gopath = vim.fn.system("go env GOPATH 2>/dev/null"):gsub("\n", "")
  if gopath ~= "" then
    local dlv_path = gopath .. "/bin/dlv"
    if vim.fn.executable(dlv_path) == 1 then
      return dlv_path
    end
  end

  -- Fallback to default Go location
  local default_dlv = vim.fn.expand("$HOME/go/bin/dlv")
  if vim.fn.executable(default_dlv) == 1 then
    return default_dlv
  end

  return "dlv" -- Let it fail with clear error
end

-- Helper function for Go executable selection (synchronous for DAP)
local function select_go_executable_sync()
  local go_utils = require("configs.languages.go.run")
  local file = vim.fn.expand("%:p")

  local project_root = go_utils.find_project_root(file)
  if not project_root then
    vim.notify("No Go project root found", vim.log.levels.WARN)
    return vim.fn.getcwd() -- Fallback to current directory
  end

  local executables = go_utils.find_executables(project_root)

  if #executables == 0 then
    vim.notify("No executables found", vim.log.levels.WARN)
    return project_root
  end

  if #executables == 1 then
    -- Auto-select single executable
    local exec = executables[1]
    return exec.relative == "." and project_root or (project_root .. "/" .. exec.relative)
  end

  -- Multiple executables - need to prompt
  local selected_program = nil
  local items = {}

  for _, exec in ipairs(executables) do
    table.insert(items, string.format("%s (%s)", exec.name, exec.relative))
  end

  -- Add custom path option
  table.insert(items, "Enter custom path...")

  -- Show picker and wait for result
  local co = coroutine.running()
  if co then
    vim.ui.select(items, {
      prompt = "Select executable to debug:",
    }, function(choice, idx)
      if not choice or not idx then
        selected_program = project_root -- Fallback
        coroutine.resume(co)
        return
      end

      if idx == #items then
        -- User selected "Enter custom path..."
        vim.ui.input({
          prompt = "Enter path to executable: ",
          default = "",
        }, function(path)
          if path and path ~= "" then
            selected_program = path
          else
            selected_program = project_root -- Fallback
          end
          coroutine.resume(co)
        end)
      else
        local exec = executables[idx]
        selected_program = exec.relative == "." and project_root or (project_root .. "/" .. exec.relative)
        coroutine.resume(co)
      end
    end)

    coroutine.yield()
    return selected_program
  end

  -- Fallback if not in coroutine
  return project_root
end

M.setup = function(dap)
  -- Setup dap-go plugin
  require("dap-go").setup({
    delve = {
      path = find_dlv(),
    },
  })

  -- Define Go debug configurations
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = select_go_executable_sync,
      cwd = "${workspaceFolder}",
    },
    {
      type = "go",
      name = "Debug with arguments",
      request = "launch",
      program = select_go_executable_sync,
      args = function()
        local args_string = vim.fn.input("Arguments: ")
        return vim.split(args_string, " +")
      end,
      cwd = "${workspaceFolder}",
    },
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
      processId = function()
        return tonumber(vim.fn.input("Process ID: "))
      end,
    },
  }
end

return M
