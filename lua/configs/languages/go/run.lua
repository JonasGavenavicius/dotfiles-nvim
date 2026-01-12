-- Go language support for smart project execution
local M = {}

-- Helper function to find Go module root
local function find_go_module_root(start_path)
  local current = vim.fn.fnamemodify(start_path, ":p:h")
  local root = vim.fn.fnamemodify(current, ":h")

  -- Walk up directory tree looking for go.mod
  while current ~= root do
    if vim.fn.filereadable(current .. "/go.mod") == 1 then
      return current
    end
    current = vim.fn.fnamemodify(current, ":h")
    root = vim.fn.fnamemodify(current, ":h")
  end

  -- Check root directory
  if vim.fn.filereadable(current .. "/go.mod") == 1 then
    return current
  end

  return nil
end

-- Helper function to check if a Go file is a main package
local function is_main_package(filepath)
  local ok, lines = pcall(vim.fn.readfile, filepath, "", 10)
  if not ok then
    return false
  end

  for _, line in ipairs(lines) do
    if line:match("^package%s+main%s*$") or line:match("^package%s+main%s*//") then
      return true
    end
  end
  return false
end

-- Helper function to extract executable name from path
local function extract_executable_name(path, module_root)
  -- Use plain string substitution to avoid pattern matching issues
  local relative = path
  if path:sub(1, #module_root + 1) == module_root .. "/" then
    relative = path:sub(#module_root + 2)
  end

  -- Remove /main.go suffix
  if relative:sub(-8) == "/main.go" then
    relative = relative:sub(1, -9)
  elseif relative == "main.go" then
    return "root"
  end

  -- Extract name based on common patterns
  if relative == "" then
    return "root"
  end

  -- For cmd/something pattern, extract just "something"
  local cmd_pattern = "^cmd/([^/]+)$"
  local cmd_name = relative:match(cmd_pattern)
  if cmd_name then
    return cmd_name
  end

  return relative
end

-- Find project root (go.mod location)
function M.find_project_root(file)
  return find_go_module_root(file)
end

-- Find all executable main packages in the project
function M.find_executables(project_root)
  local executables = {}

  -- Search patterns for common Go project structures
  local patterns = {
    "main.go",
    "cmd/*/main.go",
    "cmd/*/*/main.go",
    "tools/*/main.go",
    "*/main.go",
  }

  for _, pattern in ipairs(patterns) do
    local found = vim.fn.globpath(project_root, pattern, false, true)
    for _, filepath in ipairs(found) do
      -- Exclude vendor, .git, node_modules
      if not filepath:match("/vendor/")
        and not filepath:match("/%.git/")
        and not filepath:match("/node_modules/")
        and not filepath:match("/testdata/") then

        -- Verify it's actually a main package
        if is_main_package(filepath) then
          local dir = vim.fn.fnamemodify(filepath, ":h")

          -- Use plain string substitution to avoid pattern matching issues
          local relative = dir
          if dir == project_root then
            relative = "."
          elseif dir:sub(1, #project_root + 1) == project_root .. "/" then
            relative = dir:sub(#project_root + 2)
          end

          local name = extract_executable_name(filepath, project_root)
          table.insert(executables, {
            name = name,
            path = dir,
            relative = relative,
            main_file = filepath,
          })
        end
      end
    end
  end

  -- Sort by name for consistent ordering
  table.sort(executables, function(a, b) return a.name < b.name end)

  return executables
end

-- Run a specific executable
function M.run_executable(executable, project_root, args)
  args = args or ""
  local cmd

  if executable.relative == "." then
    -- Run from module root
    cmd = string.format("cd %s && go run . %s", vim.fn.shellescape(project_root), args)
  else
    -- Run from specific subdirectory
    cmd = string.format("cd %s && go run ./%s %s", vim.fn.shellescape(project_root), executable.relative, args)
  end

  -- Add pause after execution
  cmd = cmd .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]

  local terminal = require("utils.terminal").get_run_terminal()
  if terminal then
    terminal.cmd = cmd
    terminal:toggle()
  end
end

-- Build a specific executable
function M.build_executable(executable, project_root)
  vim.ui.input({
    prompt = "Output binary name: ",
    default = executable.name,
  }, function(binary_name)
    if not binary_name or binary_name == "" then
      return
    end

    local cmd
    if executable.relative == "." then
      -- Build from module root
      cmd = string.format("cd %s && go build -o %s .",
        vim.fn.shellescape(project_root),
        vim.fn.shellescape(binary_name))
    else
      -- Build from specific subdirectory
      cmd = string.format("cd %s && go build -o %s ./%s",
        vim.fn.shellescape(project_root),
        vim.fn.shellescape(binary_name),
        executable.relative)
    end

    -- Add pause after execution
    cmd = cmd .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]

    local terminal = require("utils.terminal").get_run_terminal()
    if terminal then
      terminal.cmd = cmd
      terminal:toggle()
    end
  end)
end

return M
