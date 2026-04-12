-- Go testing helpers for terminal-based workflows
local M = {}
local test_term = nil
local terminal_utils = require("utils.terminal")

local function find_nearest_test()
  local line = vim.fn.line(".")
  local lines = vim.api.nvim_buf_get_lines(0, 0, line, false)

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

local function get_test_terminal(command)
  local ok, Terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.notify("Failed to load toggleterm", vim.log.levels.ERROR)
    return nil
  end

  if test_term == nil then
    test_term = Terminal.Terminal:new({
      cmd = command,
      direction = "float",
      float_opts = terminal_utils.get_float_opts(),
      close_on_exit = false,
      on_exit = function()
        test_term = nil
      end,
    })
  else
    test_term.cmd = command
  end

  return test_term
end

local function run_in_terminal(command)
  local terminal = get_test_terminal(command)
  if terminal then
    terminal:toggle()
  end
end

function M.run_nearest_test_in_terminal()
  local file = vim.fn.expand("%:p")
  local test_name = find_nearest_test()

  if not test_name then
    vim.notify("No test function found at or before cursor", vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd = string.format(
    "cd %s && go test -v -race -count=1 -run %s",
    vim.fn.shellescape(dir),
    vim.fn.shellescape("^" .. test_name .. "$")
  )

  run_in_terminal(cmd)
end

function M.run_package_tests_in_terminal()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd = string.format("cd %s && go test -v -race -count=1 ./...", vim.fn.shellescape(dir))

  run_in_terminal(cmd)
end

function M.run_tests_with_coverage()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.fnamemodify(file, ":h")
  local cmd = string.format(
    "cd %s && go test -v -race -count=1 -coverprofile=coverage.out ./... && go tool cover -html=coverage.out",
    vim.fn.shellescape(dir)
  )

  run_in_terminal(cmd)
end

function M.kill_go_test_processes()
  vim.fn.jobstart({ "pkill", "-f", "go test" }, {
    on_exit = function()
      print("Killed all go test processes.")
    end,
  })
end

function M.setup_keymaps()
  local augroup = vim.api.nvim_create_augroup("GoTestKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "go",
    callback = function(args)
      local bufnr = args.buf
      local map = vim.keymap.set

      map("n", "<leader>tgn", M.run_nearest_test_in_terminal,
        { buf = bufnr, desc = "Run nearest Go test in terminal" })

      map("n", "<leader>tgp", M.run_package_tests_in_terminal,
        { buf = bufnr, desc = "Run Go package tests in terminal" })

      map("n", "<leader>tgc", M.run_tests_with_coverage,
        { buf = bufnr, desc = "Run Go tests with coverage" })

      map("n", "<leader>tgk", M.kill_go_test_processes,
        { buf = bufnr, desc = "Kill all running Go tests" })
    end,
  })
end

return M
