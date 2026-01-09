-- Multi-service launcher for starting multiple Go binaries
local M = {}

-- Helper to load Go language module
local function load_go_module()
  local ok, go_module = pcall(require, "utils.languages.go")
  if not ok then
    vim.notify("Failed to load Go utilities", vim.log.levels.ERROR)
    return nil
  end
  return go_module
end

-- Show multi-select picker for services
local function show_multi_select_picker(executables, callback)
  if #executables == 0 then
    vim.notify("No executables found", vim.log.levels.WARN)
    return
  end

  -- Build list of items with checkboxes
  local selected = {}
  for i = 1, #executables do
    selected[i] = false
  end

  local items = {}
  for i, exec in ipairs(executables) do
    local display = string.format("[ ] %s (%s)", exec.name, exec.relative or exec.path or "")
    table.insert(items, {
      display = display,
      executable = exec,
      index = i,
    })
  end

  local function update_display()
    for i, item in ipairs(items) do
      local checkbox = selected[i] and "[●]" or "[ ]"
      item.display = string.format("%s %s (%s)", checkbox, item.executable.name,
        item.executable.relative or item.executable.path or "")
    end
  end

  local function show_picker()
    vim.ui.select(items, {
      prompt = "Select services (choose to toggle, 'Start Selected' when ready):",
      format_item = function(item)
        return item.display
      end,
    }, function(choice, idx)
      if not choice then
        return
      end

      -- Toggle selection
      selected[idx] = not selected[idx]
      update_display()

      -- Ask what to do next
      vim.ui.select({ "Start Selected", "Toggle More", "Cancel" }, {
        prompt = "Action:",
      }, function(action)
        if action == "Start Selected" then
          -- Collect selected executables
          local selected_execs = {}
          for i, is_selected in ipairs(selected) do
            if is_selected then
              table.insert(selected_execs, executables[i])
            end
          end

          if #selected_execs == 0 then
            vim.notify("No services selected", vim.log.levels.WARN)
          else
            callback(selected_execs)
          end
        elseif action == "Toggle More" then
          show_picker() -- Show picker again
        end
      end)
    end)
  end

  show_picker()
end

-- Launch multiple services
function M.launch_services()
  local go = load_go_module()
  if not go then
    return
  end

  -- Get current file and find project root
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) == 1 then
    vim.notify("No valid file open", vim.log.levels.WARN)
    return
  end

  local project_root = go.find_project_root(file)
  if not project_root then
    vim.notify("No Go project root (go.mod) found", vim.log.levels.WARN)
    return
  end

  local executables = go.find_executables(project_root)
  if #executables == 0 then
    vim.notify("No Go executables found in project", vim.log.levels.WARN)
    return
  end

  show_multi_select_picker(executables, function(selected_execs)
    local process_manager = require("utils.process_manager")

    for _, exec in ipairs(selected_execs) do
      local cmd = string.format("cd %s && go run %s", vim.fn.shellescape(project_root),
        vim.fn.shellescape(exec.relative or exec.path))

      process_manager.start_service(exec.name, cmd, exec.relative or exec.path)
    end

    vim.notify(string.format("Started %d service(s)", #selected_execs), vim.log.levels.INFO)
  end)
end

-- Start a single service with picker
function M.start_service()
  local go = load_go_module()
  if not go then
    return
  end

  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) == 1 then
    vim.notify("No valid file open", vim.log.levels.WARN)
    return
  end

  local project_root = go.find_project_root(file)
  if not project_root then
    vim.notify("No Go project root (go.mod) found", vim.log.levels.WARN)
    return
  end

  local executables = go.find_executables(project_root)
  if #executables == 0 then
    vim.notify("No Go executables found in project", vim.log.levels.WARN)
    return
  end

  -- Show simple picker
  local items = {}
  for _, exec in ipairs(executables) do
    table.insert(items, {
      display = string.format("%s (%s)", exec.name, exec.relative or exec.path or ""),
      executable = exec,
    })
  end

  vim.ui.select(items, {
    prompt = "Select service to start:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end

    local process_manager = require("utils.process_manager")
    local exec = choice.executable
    local cmd = string.format("cd %s && go run %s", vim.fn.shellescape(project_root),
      vim.fn.shellescape(exec.relative or exec.path))

    process_manager.start_service(exec.name, cmd, exec.relative or exec.path)
  end)
end

-- Stop a service with picker
function M.stop_service()
  local process_manager = require("utils.process_manager")
  local services = process_manager.list_services()

  -- Filter running services
  local running = {}
  for _, service in ipairs(services) do
    if service.status == "running" then
      table.insert(running, service)
    end
  end

  if #running == 0 then
    vim.notify("No running services", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, service in ipairs(running) do
    table.insert(items, {
      display = string.format("%s (%s)", service.name, service.path or "?"),
      service = service,
    })
  end

  vim.ui.select(items, {
    prompt = "Select service to stop:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end

    process_manager.stop_service(choice.service.name)
  end)
end

-- Restart a service with picker
function M.restart_service()
  local process_manager = require("utils.process_manager")
  local services = process_manager.list_services()

  if #services == 0 then
    vim.notify("No services registered", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, service in ipairs(services) do
    local status = service.status == "running" and "running" or "stopped"
    table.insert(items, {
      display = string.format("%s (%s) [%s]", service.name, service.path or "?", status),
      service = service,
    })
  end

  vim.ui.select(items, {
    prompt = "Select service to restart:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end

    process_manager.restart_service(choice.service.name)
  end)
end

return M
