-- Terminal utilities for running programs
local M = {}

-- Helper to load language-specific modules
local function load_language_module(filetype)
  local ok, module = pcall(require, "utils.languages." .. filetype)
  if ok then
    return module
  end
  return nil
end

-- Generic executable selection (works for any language)
local function select_executable(executables, callback)
  local items = {}
  for _, exec in ipairs(executables) do
    local display = string.format("%s (%s)", exec.name, exec.relative or exec.path or "")
    table.insert(items, display)
  end

  -- Add custom path option
  table.insert(items, "Enter custom path...")

  vim.ui.select(items, {
    prompt = "Select executable:",
  }, function(choice, idx)
    if not choice or not idx then
      return
    end

    if idx == #items then
      -- User selected "Enter custom path..."
      vim.ui.input({
        prompt = "Enter path to executable: ",
        default = "",
      }, function(path)
        if path and path ~= "" then
          callback({
            name = vim.fn.fnamemodify(path, ":t"),
            relative = path,
            path = path,
          })
        end
      end)
    else
      callback(executables[idx])
    end
  end)
end

-- Default run commands for different file types
M.run_commands = {
  go = function(file) return "go run " .. vim.fn.shellescape(file) end,
  rust = function(_) return "cargo run" end,
  ruby = function(file) return "bundle exec ruby " .. vim.fn.shellescape(file) end,
  python = function(file) return "python " .. vim.fn.shellescape(file) end,
  javascript = function(file) return "node " .. vim.fn.shellescape(file) end,
  typescript = function(file) return "tsx " .. vim.fn.shellescape(file) end,
  lua = function(file) return "lua " .. vim.fn.shellescape(file) end,
}

-- Terminal instance for running programs
local run_terminal = nil

-- Named terminal instances for multi-service support
local named_terminals = {}

-- Create or reuse terminal for running programs
M.get_run_terminal = function()
  if run_terminal == nil then
    local ok, Terminal = pcall(require, "toggleterm.terminal")
    if not ok then
      vim.notify("Failed to load toggleterm", vim.log.levels.ERROR)
      return nil
    end

    run_terminal = Terminal.Terminal:new({
      direction = "float",
      close_on_exit = false,
      on_exit = function() run_terminal = nil end,
    })
  end
  return run_terminal
end

-- Create or reuse a named terminal (for multi-service support)
M.get_named_terminal = function(name, opts)
  opts = opts or {}

  if named_terminals[name] then
    return named_terminals[name]
  end

  local ok, Terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.notify("Failed to load toggleterm", vim.log.levels.ERROR)
    return nil
  end

  local term = Terminal.Terminal:new(vim.tbl_extend("force", {
    direction = "float",
    close_on_exit = false,
    on_exit = function()
      named_terminals[name] = nil
      if opts.on_exit then
        opts.on_exit()
      end
    end,
  }, opts))

  named_terminals[name] = term
  return term
end

-- Run current file with default command
M.run_current_file = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local command_fn = M.run_commands[ft]
  if not command_fn then
    vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  local cmd = command_fn(file)
  -- Add pause after execution
  cmd = cmd .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]

  local terminal = M.get_run_terminal()
  if terminal then
    terminal.cmd = cmd
    terminal:toggle()
  end
end

-- Run program with custom arguments
M.run_with_arguments = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local command_fn = M.run_commands[ft]
  if not command_fn then
    vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  local default_cmd = command_fn(file)

  vim.ui.input({
    prompt = "Run command: ",
    default = default_cmd .. " ",
  }, function(command)
    if command and command ~= "" then
      local terminal = M.get_run_terminal()
      if terminal then
        -- Add pause after execution
        terminal.cmd = command .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]
        terminal:toggle()
      end
    end
  end)
end

-- Run project (smart, language-aware)
M.run_project = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local lang = load_language_module(ft)
  if not lang then
    vim.notify("No smart project support for " .. ft, vim.log.levels.WARN)
    return
  end

  local project_root = lang.find_project_root(file)
  if not project_root then
    vim.notify("No project root found", vim.log.levels.WARN)
    return
  end

  local executables = lang.find_executables(project_root)

  if #executables == 0 then
    vim.notify("No executables found in project", vim.log.levels.WARN)
  elseif #executables == 1 then
    lang.run_executable(executables[1], project_root)
  else
    select_executable(executables, function(selected)
      lang.run_executable(selected, project_root)
    end)
  end
end

-- Run project with arguments (smart, language-aware)
M.run_project_with_arguments = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local lang = load_language_module(ft)
  if not lang then
    vim.notify("No smart project support for " .. ft, vim.log.levels.WARN)
    return
  end

  local project_root = lang.find_project_root(file)
  if not project_root then
    vim.notify("No project root found", vim.log.levels.WARN)
    return
  end

  local executables = lang.find_executables(project_root)

  if #executables == 0 then
    vim.notify("No executables found in project", vim.log.levels.WARN)
    return
  end

  local function run_with_args(selected)
    vim.ui.input({
      prompt = "Arguments: ",
      default = "",
    }, function(args)
      if args ~= nil then
        lang.run_executable(selected, project_root, args)
      end
    end)
  end

  if #executables == 1 then
    run_with_args(executables[1])
  else
    select_executable(executables, run_with_args)
  end
end

-- Build project (smart, language-aware)
M.build_project = function()
  local file = vim.fn.expand("%:p")
  if file == "" or not vim.fn.filereadable(file) then
    vim.notify("No valid file to run", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local lang = load_language_module(ft)
  if not lang then
    vim.notify("No smart project support for " .. ft, vim.log.levels.WARN)
    return
  end

  local project_root = lang.find_project_root(file)
  if not project_root then
    vim.notify("No project root found", vim.log.levels.WARN)
    return
  end

  local executables = lang.find_executables(project_root)

  if #executables == 0 then
    vim.notify("No executables found in project", vim.log.levels.WARN)
  elseif #executables == 1 then
    lang.build_executable(executables[1], project_root)
  else
    select_executable(executables, function(selected)
      lang.build_executable(selected, project_root)
    end)
  end
end

return M