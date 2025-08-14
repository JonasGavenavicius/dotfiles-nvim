local M = {
  "nvim-neotest/neotest",
  lazy = true,
  commit = "747775fc22dfeb6102bdde6559ccb5126dac0ff8",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
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
    discovery = {
      enabled = false,
    },
    status = {
      enabled = true,
    },
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
        filter_dirs = { ".git", "node_modules", "vendor", "tmp", "log", "public", "storage" },
        -- Performance: Only discover tests for current file, not entire directory
        is_test_file = function(file_path)
          -- Only consider files that are currently open or explicitly requested
          local current_file = vim.fn.expand("%:p")
          if file_path == current_file then
            return file_path:match("_spec%.rb$") ~= nil
          end
          return false
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
  
  -- Manual discovery commands for better control (using <leader>ts prefix for "test scan")
  vim.keymap.set("n", "<leader>tsf", function()
    require("neotest").run.run(vim.fn.expand("%"))
    vim.notify("Discovered tests in current file", vim.log.levels.INFO)
  end, { desc = "Discover tests in current file" })
  
  vim.keymap.set("n", "<leader>tsd", function() 
    local current_dir = vim.fn.expand("%:p:h")
    require("neotest").run.run(current_dir)
    vim.notify("Discovered tests in current directory", vim.log.levels.INFO)
  end, { desc = "Discover tests in current directory" })
  
  vim.keymap.set("n", "<leader>tsp", function()
    -- Find project root and discover all tests
    local project_root = vim.fn.getcwd()
    vim.notify("Discovering all tests in project (this may take a while)...", vim.log.levels.WARN)
    require("neotest").run.run(project_root)
    vim.notify("Discovered all tests in project", vim.log.levels.INFO)
  end, { desc = "Discover all tests in project" })
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
