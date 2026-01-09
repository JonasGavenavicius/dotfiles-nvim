-- Process manager for running multiple services simultaneously
local M = {}

-- Service registry: tracks all managed processes
-- Structure: { name = { name, terminal, pid, status, started_at, exit_code, cmd, path } }
local services = {}

-- Get or create a named terminal for a service
local function get_service_terminal(name, cmd)
  local ok, Terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.notify("Failed to load toggleterm", vim.log.levels.ERROR)
    return nil
  end

  local term = Terminal.Terminal:new({
    cmd = cmd,
    direction = "float",
    float_opts = {
      border = "curved",
      width = 120,
      height = 30,
    },
    close_on_exit = false,
    on_open = function(t)
      -- Store PID when terminal opens
      if services[name] then
        services[name].pid = t.job_id
      end
    end,
    on_exit = function(t, job, exit_code, _)
      M.on_service_exit(name, exit_code)
    end,
  })

  return term
end

-- Callback when service exits
function M.on_service_exit(name, exit_code)
  if services[name] then
    services[name].status = exit_code == 0 and "stopped" or "error"
    services[name].exit_code = exit_code
    services[name].pid = nil

    local status_msg = exit_code == 0 and "stopped" or "exited with error"
    vim.notify(string.format("Service '%s' %s (exit code: %d)", name, status_msg, exit_code), vim.log.levels.INFO)
  end
end

-- Start a service
function M.start_service(name, cmd, path)
  if services[name] and services[name].status == "running" then
    vim.notify(string.format("Service '%s' is already running", name), vim.log.levels.WARN)
    return false
  end

  local terminal = get_service_terminal(name, cmd)
  if not terminal then
    return false
  end

  services[name] = {
    name = name,
    terminal = terminal,
    pid = nil, -- Will be set in on_open
    status = "running",
    started_at = os.time(),
    exit_code = nil,
    cmd = cmd,
    path = path,
  }

  terminal:toggle()
  vim.notify(string.format("Starting service '%s'...", name), vim.log.levels.INFO)
  return true
end

-- Stop a service
function M.stop_service(name)
  local service = services[name]
  if not service then
    vim.notify(string.format("Service '%s' not found", name), vim.log.levels.WARN)
    return false
  end

  if service.status ~= "running" then
    vim.notify(string.format("Service '%s' is not running", name), vim.log.levels.WARN)
    return false
  end

  if service.terminal then
    service.terminal:shutdown()
    service.status = "stopped"
    service.pid = nil
    vim.notify(string.format("Stopped service '%s'", name), vim.log.levels.INFO)
    return true
  end

  return false
end

-- Restart a service
function M.restart_service(name)
  local service = services[name]
  if not service then
    vim.notify(string.format("Service '%s' not found", name), vim.log.levels.WARN)
    return false
  end

  local cmd = service.cmd
  local path = service.path

  M.stop_service(name)
  vim.defer_fn(function()
    M.start_service(name, cmd, path)
  end, 500) -- Wait 500ms before restarting

  return true
end

-- Stop all services
function M.stop_all()
  local count = 0
  for name, service in pairs(services) do
    if service.status == "running" then
      M.stop_service(name)
      count = count + 1
    end
  end

  if count > 0 then
    vim.notify(string.format("Stopped %d service(s)", count), vim.log.levels.INFO)
  else
    vim.notify("No running services to stop", vim.log.levels.INFO)
  end

  return count
end

-- Get list of all services
function M.list_services()
  local list = {}
  for _, service in pairs(services) do
    table.insert(list, service)
  end

  -- Sort by name
  table.sort(list, function(a, b)
    return a.name < b.name
  end)

  return list
end

-- Get status of a specific service
function M.get_status(name)
  return services[name]
end

-- Check if a service is running
function M.is_running(name)
  local service = services[name]
  return service and service.status == "running"
end

-- Show status UI with service picker
function M.show_status_ui()
  local service_list = M.list_services()

  if #service_list == 0 then
    vim.notify("No services registered", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, service in ipairs(service_list) do
    local status_icon = service.status == "running" and "●" or "○"
    local runtime = ""
    if service.status == "running" and service.started_at then
      local elapsed = os.time() - service.started_at
      local minutes = math.floor(elapsed / 60)
      local seconds = elapsed % 60
      runtime = string.format(" [%dm %ds]", minutes, seconds)
    end

    local pid_info = service.pid and string.format("PID: %d", service.pid) or "Not running"
    local display = string.format("%s %-15s  (%s)  %s%s", status_icon, service.name, service.path or "?", pid_info,
      runtime)

    table.insert(items, {
      display = display,
      service = service,
    })
  end

  vim.ui.select(items, {
    prompt = "Services (select to manage):",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end

    local service = choice.service
    local actions = {}

    if service.status == "running" then
      table.insert(actions, "Stop")
      table.insert(actions, "Restart")
    else
      table.insert(actions, "Start")
    end

    table.insert(actions, "Cancel")

    vim.ui.select(actions, {
      prompt = string.format("Action for '%s':", service.name),
    }, function(action)
      if action == "Start" then
        M.start_service(service.name, service.cmd, service.path)
      elseif action == "Stop" then
        M.stop_service(service.name)
      elseif action == "Restart" then
        M.restart_service(service.name)
      end
    end)
  end)
end

return M
