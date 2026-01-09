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
    { "olimorris/neotest-rspec", commit = "281c0ed0e55d623e8028796e1c4dc27b7e421fd0" },
    { "olimorris/neotest-rspec" },
  },
}

M.config = function()
  local neotest = require("neotest")
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

  local map = vim.keymap.set
  map("n", "<leader>trn", RunNearestTestInTerminal, { desc = "Run nearest ruby test in terminal" })
  map("n", "<leader>trk", function()
    vim.fn.jobstart({ "pkill", "-f", "rspec" }, {
      on_exit = function()
        print("Killed all rspec processes.")
      end,
    })
  end, { desc = "Kill all running RSpec tests" })
  -- Debug function to check adapter detection
  map("n", "<leader>trd", function()
    local current_file = vim.fn.expand("%:p")
    print("Current file: " .. current_file)
    print("File type: " .. vim.bo.filetype)

    -- Check treesitter parser
    local has_parser = pcall(vim.treesitter.get_parser, 0, "ruby")
    print("Has Ruby treesitter parser: " .. tostring(has_parser))

    -- Try to get neotest adapters
    local ok, neotest_debug = pcall(require, "neotest")
    if ok then
      local tree = neotest_debug.state.positions()
      if tree then
        print("Neotest tree exists - tests should be detected")
      else
        print("No neotest tree found - no tests detected")
      end
      print("")
      print("Tip: Use <leader>tt to open test summary and discover tests")
    else
      print("Failed to load neotest")
    end
  end, { desc = "Debug neotest adapter detection" })

  -- Manual scan commands that actually discover tests recursively
  local function scan_for_tests(base_path, depth_description)
    vim.notify("Scanning for tests in " .. depth_description .. "...", vim.log.levels.INFO)

    -- Directories to exclude (matching neotest-rspec config)
    local filter_dirs = { ".git", "node_modules", "vendor", "tmp", "log", "public", "storage" }

    -- Find all spec files recursively
    local spec_files = vim.fn.globpath(base_path, "**/*_spec.rb", false, true)

    -- Filter out excluded directories
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

    if #filtered_files == 0 then
      vim.notify("No spec files found in " .. depth_description, vim.log.levels.WARN)
      return
    end

    vim.notify(string.format("Found %d spec files, discovering tests...", #filtered_files), vim.log.levels.INFO)

    -- Discover tests by reading each file (this triggers neotest's discovery)
    local original_buf = vim.api.nvim_get_current_buf()
    local discovered = 0

    -- Process files in batches with progress updates
    local batch_size = 50
    for i, file in ipairs(filtered_files) do
      -- Use badd to add buffer without displaying it, then trigger discovery
      vim.cmd("badd " .. vim.fn.fnameescape(file))
      local buf = vim.fn.bufnr(file)
      if buf ~= -1 then
        -- Trigger BufEnter event which causes neotest to discover positions
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("doautocmd BufEnter")
        end)
        discovered = discovered + 1
      end

      -- Show progress every batch_size files
      if i % batch_size == 0 then
        local progress = math.floor((i / #filtered_files) * 100)
        vim.notify(string.format("Progress: %d%% (%d/%d files)", progress, i, #filtered_files), vim.log.levels.INFO)
        vim.cmd("redraw")
      end
    end

    -- Return to original buffer
    vim.api.nvim_set_current_buf(original_buf)

    vim.notify(string.format("Discovered tests in %d files. Open summary (<leader>tt) to view.", discovered), vim.log.levels.INFO)
  end

  map("n", "<leader>tsp", function()
    local filetype = vim.bo.filetype

    if filetype == "ruby" then
      -- Existing Ruby logic
      local current_file = vim.fn.expand("%:p")
      local current_dir = vim.fn.expand("%:p:h")
      local project_root = vim.fn.getcwd()

      -- Walk up looking for packages/[package_name] structure
      local path = current_dir
      local package_spec_dir = nil

      while path:len() >= project_root:len() do
        -- Check if we're inside a packages directory
        local parent = vim.fn.fnamemodify(path, ":h")
        local dirname = vim.fn.fnamemodify(path, ":t")

        if vim.fn.fnamemodify(parent, ":t") == "packages" then
          -- Found a package directory
          local spec_path = path .. "/spec"
          if vim.fn.isdirectory(spec_path) == 1 then
            package_spec_dir = spec_path
            break
          end
        end

        -- Move up one directory
        if path == parent then
          break
        end
        path = parent
      end

      -- Use found package spec dir, or fallback to root spec
      if package_spec_dir then
        local package_name = vim.fn.fnamemodify(package_spec_dir:gsub("/spec$", ""), ":t")
        scan_for_tests(package_spec_dir, "package '" .. package_name .. "' specs")
      else
        local root_spec = project_root .. "/spec"
        if vim.fn.isdirectory(root_spec) == 1 then
          scan_for_tests(root_spec, "root spec directory")
        else
          vim.notify("Not in a package and no root spec directory found", vim.log.levels.WARN)
        end
      end
    else
      vim.notify("Test scanning only supported for Ruby", vim.log.levels.WARN)
    end
  end, { desc = "Scan Ruby package tests" })

  map("n", "<leader>tsd", function()
    local filetype = vim.bo.filetype
    local current_dir = vim.fn.expand("%:p:h")

    if filetype == "ruby" then
      scan_for_tests(current_dir, "current directory")
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
