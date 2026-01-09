-- Ruby language support for test management and execution
local M = {}

-- ============================================================================
-- PRIVATE STATE
-- ============================================================================

-- Module-local variable to store the test terminal instance
local test_term = nil

-- ============================================================================
-- PRIVATE HELPER FUNCTIONS
-- ============================================================================

-- Get directories to exclude when scanning for tests (matches neotest-rspec config)
local function get_filter_dirs()
  return { ".git", "node_modules", "vendor", "tmp", "log", "public", "storage" }
end

-- Find all spec files in a directory, excluding filtered directories
local function find_spec_files(base_path)
  local spec_files = vim.fn.globpath(base_path, "**/*_spec.rb", false, true)
  local filter_dirs = get_filter_dirs()
  local filtered_files = {}

  for _, file in ipairs(spec_files) do
    local should_include = true
    for _, excluded in ipairs(filter_dirs) do
      if file:match("/" .. excluded .. "/") then
        should_include = false
        break
      end
    end
    if should_include then
      table.insert(filtered_files, file)
    end
  end

  return filtered_files
end

-- Find package spec directory by walking up the tree
local function find_package_spec_dir(current_dir, project_root)
  local path = current_dir

  while path:len() >= project_root:len() do
    local parent = vim.fn.fnamemodify(path, ":h")

    if vim.fn.fnamemodify(parent, ":t") == "packages" then
      local spec_path = path .. "/spec"
      if vim.fn.isdirectory(spec_path) == 1 then
        local package_name = vim.fn.fnamemodify(path, ":t")
        return { path = spec_path, name = package_name }
      end
    end

    if path == parent then break end
    path = parent
  end

  return nil
end

-- ============================================================================
-- PUBLIC API
-- ============================================================================

-- Scan for tests in a directory with progress reporting
-- Triggers neotest's test discovery by loading spec files
function M.scan_for_tests(base_path, description)
  vim.notify("Scanning for tests in " .. description .. "...", vim.log.levels.INFO)

  local filtered_files = find_spec_files(base_path)

  if #filtered_files == 0 then
    vim.notify("No spec files found in " .. description, vim.log.levels.WARN)
    return 0
  end

  vim.notify(string.format("Found %d spec files, discovering tests...", #filtered_files), vim.log.levels.INFO)

  local original_buf = vim.api.nvim_get_current_buf()
  local discovered = 0
  local batch_size = 50

  for i, file in ipairs(filtered_files) do
    vim.cmd("badd " .. vim.fn.fnameescape(file))
    local buf = vim.fn.bufnr(file)
    if buf ~= -1 then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("doautocmd BufEnter")
      end)
      discovered = discovered + 1
    end

    if i % batch_size == 0 then
      local progress = math.floor((i / #filtered_files) * 100)
      vim.notify(string.format("Progress: %d%% (%d/%d files)", progress, i, #filtered_files), vim.log.levels.INFO)
      vim.cmd("redraw")
    end
  end

  vim.api.nvim_set_current_buf(original_buf)
  vim.notify(string.format("Discovered tests in %d files. Open summary (<leader>tt) to view.", discovered),
    vim.log.levels.INFO)

  return discovered
end

-- Find the appropriate spec directory for the current file
-- Returns { path, type, name } or nil if not found
function M.find_spec_directory()
  local current_dir = vim.fn.expand("%:p:h")
  local project_root = vim.fn.getcwd()

  -- Try to find package-specific spec directory
  local package_info = find_package_spec_dir(current_dir, project_root)
  if package_info then
    return { path = package_info.path, type = "package", name = package_info.name }
  end

  -- Fall back to root spec directory
  local root_spec = project_root .. "/spec"
  if vim.fn.isdirectory(root_spec) == 1 then
    return { path = root_spec, type = "root", name = "root" }
  end

  return nil
end

-- Scan for tests based on current context (package or root)
function M.scan_package_tests()
  local spec_info = M.find_spec_directory()

  if not spec_info then
    vim.notify("Not in a package and no root spec directory found", vim.log.levels.WARN)
    return
  end

  local description = spec_info.type == "package"
    and "package '" .. spec_info.name .. "' specs"
    or "root spec directory"

  M.scan_for_tests(spec_info.path, description)
end

-- Scan for tests in the current directory
function M.scan_current_directory()
  local current_dir = vim.fn.expand("%:p:h")
  M.scan_for_tests(current_dir, "current directory")
end

-- Run nearest test in terminal using toggleterm
function M.run_nearest_test_in_terminal()
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local cmd = "bundle exec rspec " .. file .. ":" .. line

  if test_term == nil then
    local Terminal = require("toggleterm.terminal").Terminal
    test_term = Terminal:new({
      cmd = cmd,
      direction = "float",
      on_exit = function() test_term = nil end,
    })
  else
    test_term.cmd = cmd
  end

  test_term:toggle()
end

-- Kill all running RSpec processes
function M.kill_rspec_processes()
  vim.fn.jobstart({ "pkill", "-f", "rspec" }, {
    on_exit = function()
      print("Killed all rspec processes.")
    end,
  })
end

return M
