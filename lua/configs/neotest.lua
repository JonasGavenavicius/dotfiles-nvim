local M = {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-vim-test",
    "olimorris/neotest-rspec",
  },
}

M.config = function()
  local neotest = require("neotest")
  local ruby = require("utils.languages.ruby")
  neotest.setup({
    log_level = vim.log.levels.DEBUG,
    discovery = {
      enabled = true,
      concurrent = 8,
    },
    status = {
      enabled = true,
    },
    adapters = {
      require("neotest-jest"),
      require("neotest-rust"),
      require("neotest-vim-test")({
        ignore_file_types = { "python", "vim", "lua" },
      }),
      require("neotest-rspec")({
        rspec_cmd = function()
          return vim.tbl_flatten({ "bundle", "exec", "rspec" })
        end,
        root_files = { "Gemfile", ".rspec", "spec" },
        filter_dirs = { ".git", "node_modules", "vendor", "tmp", "log", "public", "storage" },
        -- Match RSpec test files (_spec.rb) while relying on filter_dirs for performance
        is_test_file = function(file_path)
          return file_path:match("_spec%.rb$") ~= nil
        end,
        transform_spec_path = function(path)
          return path
        end,
      }),
    },
    icons = {
      child_indent = "│",
      child_prefix = "├",
      collapsed = "─",
      expanded = "╮",
      failed = "❌",
      final_child_indent = " ",
      final_child_prefix = "╰",
      non_collapsible = "─",
      notify = "🔔",
      passed = "🟩",
      running = "󰜎",
      running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
      skipped = "󰒭",
      unknown = "!",
      watching = "󰈈",
    },
  })

  -- Ruby-specific keybindings
  local map = vim.keymap.set
  map("n", "<leader>trn", function()
    if vim.bo.filetype == "ruby" then
      ruby.run_nearest_test_in_terminal()
    else
      vim.notify("Terminal runner only supported for Ruby", vim.log.levels.WARN)
    end
  end, { desc = "Run nearest ruby test in terminal" })

  map("n", "<leader>trk", function()
    ruby.kill_rspec_processes()
  end, { desc = "Kill all running RSpec tests" })

  map("n", "<leader>tsp", function()
    if vim.bo.filetype == "ruby" then
      ruby.scan_package_tests()
    else
      vim.notify("Test scanning only supported for Ruby", vim.log.levels.WARN)
    end
  end, { desc = "Scan Ruby package tests" })

  map("n", "<leader>tsd", function()
    if vim.bo.filetype == "ruby" then
      ruby.scan_current_directory()
    else
      vim.notify("Test scanning only supported for Ruby", vim.log.levels.WARN)
    end
  end, { desc = "Scan directory for Ruby tests" })
end

M.keys = function()
  local neotest = require("neotest")
  return {
    { "<leader>tn", function() neotest.run.run() end,                     desc = "Run nearest test" },
    { "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, desc = "Run nearest test debug" },
    { "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,   desc = "Run file tests" },
    { "<leader>ta", function() neotest.run.run({ suite = true }) end,     desc = "Run test suite" },
    { "<leader>tl", function() neotest.run.run_last() end,                desc = "Run last test" },
    { "<leader>tk", function() neotest.run.stop() end,                    desc = "Stop test" },
    { "<leader>to", function() neotest.output.open({ enter = true }) end, desc = "Show test output" },
    { "<leader>tt", function() neotest.summary.toggle() end,              desc = "Toggle test summary" },
  }
end

return M
