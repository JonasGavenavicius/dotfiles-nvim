-- Ruby testing helpers for terminal-based workflows
local M = {}
local test_term = nil
local terminal_utils = require("utils.terminal")

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
  local line = vim.fn.line(".")
  local cmd = "bundle exec rspec " .. vim.fn.shellescape(file .. ":" .. line)

  run_in_terminal(cmd)
end

function M.kill_rspec_processes()
  vim.fn.jobstart({ "pkill", "-f", "rspec" }, {
    on_exit = function()
      print("Killed all rspec processes.")
    end,
  })
end

function M.setup_keymaps()
  local augroup = vim.api.nvim_create_augroup("RubyTestKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "ruby",
    callback = function(args)
      local bufnr = args.buf
      local map = vim.keymap.set

      map("n", "<leader>trn", M.run_nearest_test_in_terminal,
        { buf = bufnr, desc = "Run nearest Ruby test in terminal" })

      map("n", "<leader>trk", M.kill_rspec_processes,
        { buf = bufnr, desc = "Kill all running RSpec tests" })
    end,
  })
end

return M
