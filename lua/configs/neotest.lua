local M = {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-go",
    "rouge8/neotest-rust",
    "olimorris/neotest-rspec",
  },
}

M.config = function()
  local neotest = require("neotest")
  neotest.setup({
    log_level = vim.log.levels.INFO,
    discovery = {
      enabled = true, -- Auto-discover tests in all supported languages
      concurrent = 8,
    },
    status = {
      enabled = true,
    },
    adapters = {
      require("neotest-jest"),
      require("neotest-rust"),
      require("neotest-go")({
        experimental = {
          test_table = true,
        },
        args = { "-count=1", "-timeout=60s" }
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
end


M.keys = {
  { "<leader>tn", function() require("neotest").run.run() end,                     desc = "Run nearest test" },
  { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Run nearest test debug" },
  { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run file tests" },
  { "<leader>ta", function() require("neotest").run.run({ suite = true }) end,     desc = "Run test suite" },
  { "<leader>tl", function() require("neotest").run.run_last() end,                desc = "Run last test" },
  { "<leader>tk", function() require("neotest").run.stop() end,                    desc = "Stop test" },
  { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
  { "<leader>tt", function() require("neotest").summary.toggle() end,              desc = "Toggle test summary" },
}

return M
