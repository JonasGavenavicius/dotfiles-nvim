-- Go testing configuration and utilities
local M = {}

-- ============================================================================
-- PRIVATE STATE
-- ============================================================================

-- Module-local variable to store the test terminal instance
local test_term = nil

-- Track if project-wide discovery has been performed
local project_discovery_done = false

-- ============================================================================
-- PRIVATE HELPER FUNCTIONS
-- ============================================================================

-- Detect if current directory is a Go project
local function is_go_project()
  local project_root = vim.fn.getcwd()

  -- Check for go.mod (primary indicator of a Go module)
  if vim.fn.filereadable(project_root .. "/go.mod") == 1 then
    return true
  end

  -- Check for go.work (Go workspace)
  if vim.fn.filereadable(project_root .. "/go.work") == 1 then
    return true
  end

  -- Check if there are any .go files in the project root
  local go_files = vim.fn.glob(project_root .. "/*.go", false, true)
  if #go_files > 0 then
    return true
  end

  return false
end

-- Get directories to exclude when scanning for tests
local function get_filter_dirs()
  return { ".git", "node_modules", "vendor", "tmp", "bin", "build", "dist" }
end

-- Find all test files in a directory, excluding filtered directories
local function find_test_files(base_path)
  local test_files = vim.fn.globpath(base_path, "**/*_test.go", false, true)
  local filter_dirs = get_filter_dirs()
  local filtered_files = {}

  for _, file in ipairs(test_files) do
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

-- Find the nearest test function at or before the cursor
local function find_nearest_test()
  local line = vim.fn.line(".")
  local lines = vim.api.nvim_buf_get_lines(0, 0, line, false)

  -- Search backwards for a test function
  for i = #lines, 1, -1 do
    local test_name = lines[i]:match("^func%s+(Test%w+)")
    if not test_name then
      test_name = lines[i]:match("^func%s+(Benchmark%w+)")
    end
    if test_name then
      return test_name
    end
  end

  return nil
end

-- ============================================================================
-- PUBLIC API
-- ============================================================================

-- Scan for tests in a directory with progress reporting
-- Triggers neotest's test discovery by loading test files
function M.scan_for_tests(base_path, description)
  vim.notify("Scanning for tests in " .. description .. "...", vim.log.levels.INFO)

  local filtered_files = find_test_files(base_path)

  if #filtered_files == 0 then
    vim.notify("No test files found in " .. description, vim.log.levels.WARN)
    return 0
  end

  vim.notify(string.format("Found %d test files, discovering tests...", #filtered_files), vim.log.levels.INFO)

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

-- Find the appropriate test directory for the current file
-- Returns { path, type, name } or nil if not found
function M.find_test_directory()
  local current_dir = vim.fn.expand("%:p:h")
  local project_root = vim.fn.getcwd()

  -- Check if we're in a Go module
  local go_mod = vim.fn.findfile("go.mod", current_dir .. ";")
  if go_mod ~= "" then
    local mod_dir = vim.fn.fnamemodify(go_mod, ":h")
    return { path = mod_dir, type = "module", name = vim.fn.fnamemodify(mod_dir, ":t") }
  end

  -- Fall back to current directory
  return { path = current_dir, type = "directory", name = vim.fn.fnamemodify(current_dir, ":t") }
end

-- Scan for tests based on current context (module or directory)
function M.scan_package_tests()
  local test_info = M.find_test_directory()

  if not test_info then
    vim.notify("Could not determine test directory", vim.log.levels.WARN)
    return
  end

  local description = test_info.type == "module"
    and "module '" .. test_info.name .. "'"
    or "directory '" .. test_info.name .. "'"

  M.scan_for_tests(test_info.path, description)
end

-- Scan for tests in the current directory
function M.scan_current_directory()
  local current_dir = vim.fn.expand("%:p:h")
  M.scan_for_tests(current_dir, "current directory")
end

-- Scan for tests in the current file only
function M.scan_current_file()
  local current_file = vim.fn.expand("%:p")

  if not current_file:match("_test%.go$") then
    vim.notify("Current file is not a Go test file", vim.log.levels.WARN)
    return
  end

  -- Silently load current buffer and trigger discovery
  local buf = vim.fn.bufnr(current_file)
  if buf == -1 then
    vim.cmd("badd " .. vim.fn.fnameescape(current_file))
    buf = vim.fn.bufnr(current_file)
  end

  if buf ~= -1 then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("doautocmd BufEnter")
    end)
  end
end

-- Scan for tests in the entire project
function M.scan_all_tests()
  local project_root = vim.fn.getcwd()
  M.scan_for_tests(project_root, "entire project")
end

-- Interactive menu to choose discovery scope
function M.choose_discovery_scope()
  if vim.bo.filetype ~= "go" then
    vim.notify("Discovery menu only available in Go files", vim.log.levels.WARN)
    return
  end

  local options = {
    "Current file only",
    "Current directory",
    "Current module/package",
    "Entire project"
  }

  vim.ui.select(options, {
    prompt = "Select test discovery scope:",
    format_item = function(item)
      return "  " .. item
    end,
  }, function(choice, idx)
    if not choice or not idx then
      return
    end

    if idx == 1 then
      M.scan_current_file()
      vim.notify("Discovered tests in current file. Open summary (<leader>tt) to view.", vim.log.levels.INFO)
    elseif idx == 2 then
      M.scan_current_directory()
    elseif idx == 3 then
      M.scan_package_tests()
    elseif idx == 4 then
      M.scan_all_tests()
    end
  end)
end


-- Run nearest test in terminal using toggleterm
function M.run_nearest_test_in_terminal()
  local file = vim.fn.expand("%:p")
  local test_name = find_nearest_test()

  if not test_name then
    vim.notify("No test function found at or before cursor", vim.log.levels.WARN)
    return
  end

  -- Get the directory containing the test file
  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd = "cd " .. vim.fn.shellescape(dir) .. " && go test -v -race -count=1 -run '^" .. test_name .. "$'"

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

-- Run all tests in current package in terminal
function M.run_package_tests_in_terminal()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd = "cd " .. vim.fn.shellescape(dir) .. " && go test -v -race -count=1 ./..."

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

-- Run tests with coverage in terminal
function M.run_tests_with_coverage()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd = "cd " .. vim.fn.shellescape(dir) .. " && go test -v -race -count=1 -coverprofile=coverage.out ./... && go tool cover -html=coverage.out"

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

-- Kill all running Go test processes
function M.kill_go_test_processes()
  vim.fn.jobstart({ "pkill", "-f", "go test" }, {
    on_exit = function()
      print("Killed all go test processes.")
    end,
  })
end

-- Setup Go test keybindings (buffer-local for Go files)
function M.setup_keymaps()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function(args)
      local bufnr = args.buf
      local map = vim.keymap.set

      -- Test running
      map("n", "<leader>tgn", M.run_nearest_test_in_terminal,
          { buffer = bufnr, desc = "Run nearest Go test in terminal" })

      map("n", "<leader>tgp", M.run_package_tests_in_terminal,
          { buffer = bufnr, desc = "Run Go package tests in terminal" })

      map("n", "<leader>tgc", M.run_tests_with_coverage,
          { buffer = bufnr, desc = "Run Go tests with coverage" })

      map("n", "<leader>tgk", M.kill_go_test_processes,
          { buffer = bufnr, desc = "Kill all running Go tests" })

      -- Test discovery (manual triggers)
      map("n", "<leader>tsf", M.scan_current_file,
          { buffer = bufnr, desc = "Rediscover current file tests" })

      map("n", "<leader>tsd", M.scan_current_directory,
          { buffer = bufnr, desc = "Scan directory for Go tests" })

      map("n", "<leader>tsp", M.scan_package_tests,
          { buffer = bufnr, desc = "Scan Go package tests" })

      map("n", "<leader>tsa", M.scan_all_tests,
          { buffer = bufnr, desc = "Scan all Go tests in project" })

      -- Discovery menu
      map("n", "<leader>ts", M.choose_discovery_scope,
          { buffer = bufnr, desc = "Choose Go test discovery scope" })
    end,
  })
end

return M
