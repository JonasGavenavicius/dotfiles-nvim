local M = {
  "nvim-neotest/neotest",
  lazy = true,
  commit = "747775fc22dfeb6102bdde6559ccb5126dac0ff8", -- Pin to specific stable version
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Runners
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-vim-test",
    "fredrikaverpil/neotest-golang",
    { "olimorris/neotest-rspec", commit = "281c0ed0e55d623e8028796e1c4dc27b7e421fd0" },
  },
}

M.config = function()
  local neotest = require("neotest")
  neotest.setup({
    log_level = vim.log.levels.DEBUG,
    adapters = {
      require("neotest-jest"),
      -- require('rustaceanvim.neotest'),
      require("neotest-rust"),
      require("neotest-vim-test")({
        ignore_file_types = { "python", "vim", "lua" },
      }),
      require("neotest-golang"),
      require("neotest-rspec")({
        rspec_cmd = function()
          return vim.tbl_flatten({ "bundle", "exec", "rspec" })
        end,
        root_files = { "Gemfile", ".rspec", "spec" },
        filter_dirs = { ".git", "node_modules" },
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
  function RunNearestTestInTerminal()
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

  vim.keymap.set("n", "<leader>trn", RunNearestTestInTerminal, { desc = "Run nearest ruby test in terminal" })
  vim.keymap.set("n", "<leader>trk", function()
    vim.fn.jobstart({ "pkill", "-f", "rspec" }, {
      on_exit = function()
        print("Killed all rspec processes.")
      end,
    })
  end, { desc = "Kill all running RSpec tests" })
  
  -- Debug function to check adapter detection
  vim.keymap.set("n", "<leader>trd", function()
    local current_file = vim.fn.expand("%:p")
    print("Current file: " .. current_file)
    print("File type: " .. vim.bo.filetype)
    
    -- Check treesitter parser
    local has_parser = pcall(vim.treesitter.get_parser, 0, "ruby")
    print("Has Ruby treesitter parser: " .. tostring(has_parser))
    
    -- Try to get neotest adapters
    local ok, neotest = pcall(require, "neotest")
    if ok then
      local tree = neotest.state.positions()
      if tree then
        print("Neotest tree exists - tests should be detected")
      else
        print("No neotest tree found - no tests detected")
      end
    else
      print("Failed to load neotest")
    end
  end, { desc = "Debug neotest adapter detection" })
end

M.keys = {
  { "<leader>tn", function() require("neotest").run.run() end,                     desc = "Run nearest test" },
  { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Run nearest test debug" },
  { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run file tests" },
  { "<leader>ta", function() require("neotest").run.run({ suite = true }) end,     desc = "Run test suite" },
  { "<leader>tl", function() require("neotest").run.run_last() end,                desc = "Run last test" },
  { "<leader>ts", function() require("neotest").run.stop() end,                    desc = "Stop test" },
  { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
  { "<leader>tt", function() require("neotest").summary.toggle() end,              desc = "Toggle test summary" },
}

return M
