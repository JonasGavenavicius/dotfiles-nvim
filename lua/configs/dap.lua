local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "suketa/nvim-dap-ruby",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup plugins
    require("nvim-dap-virtual-text").setup({})
    dapui.setup()

    -- Find dlv in PATH, GOPATH, or common locations
    local function find_dlv()
      -- Try PATH first
      if vim.fn.executable("dlv") == 1 then
        return "dlv"
      end

      -- Try GOPATH/bin
      local gopath = vim.fn.system("go env GOPATH 2>/dev/null"):gsub("\n", "")
      if gopath ~= "" then
        local dlv_path = gopath .. "/bin/dlv"
        if vim.fn.executable(dlv_path) == 1 then
          return dlv_path
        end
      end

      -- Fallback to default Go location
      local default_dlv = vim.fn.expand("$HOME/go/bin/dlv")
      if vim.fn.executable(default_dlv) == 1 then
        return default_dlv
      end

      return "dlv" -- Let it fail with clear error
    end

    require("dap-go").setup({
      delve = {
        path = find_dlv(),
      },
    })
    require("dap-ruby").setup()

    -- DAP UI auto open/close
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- Ruby adapter
    dap.adapters.ruby = {
      type = "executable",
      command = "readapt",
      args = { "stdio" },
    }

    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "Debug RSpec current file",
        request = "launch",
        program = "${file}",
        useBundler = true,
      },
    }

    -- Rust adapter (codelldb via Mason)
    local function get_codelldb_path()
      local mason_registry = require("mason-registry")
      local codelldb_pkg = mason_registry.get_package("codelldb")
      return codelldb_pkg:get_install_path() .. "/extension/adapter/codelldb"
    end

    dap.adapters.codelldb = function(callback, config)
      local ok, codelldb_path = pcall(get_codelldb_path)
      if not ok then
        -- Fallback to old hardcoded path
        codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
      end
      
      callback({
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      })
    end

    dap.configurations.rust = {
      {
        name = "Debug Rust",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    -- Helper function for Go executable selection (synchronous for DAP)
    local function select_go_executable_sync()
      local go_utils = require("utils.languages.go")
      local file = vim.fn.expand("%:p")

      local project_root = go_utils.find_project_root(file)
      if not project_root then
        vim.notify("No Go project root found", vim.log.levels.WARN)
        return vim.fn.getcwd() -- Fallback to current directory
      end

      local executables = go_utils.find_executables(project_root)

      if #executables == 0 then
        vim.notify("No executables found", vim.log.levels.WARN)
        return project_root
      end

      if #executables == 1 then
        -- Auto-select single executable
        local exec = executables[1]
        return exec.relative == "." and project_root or (project_root .. "/" .. exec.relative)
      end

      -- Multiple executables - need to prompt
      local selected_program = nil
      local items = {}

      for _, exec in ipairs(executables) do
        table.insert(items, string.format("%s (%s)", exec.name, exec.relative))
      end

      -- Add custom path option
      table.insert(items, "Enter custom path...")

      -- Show picker and wait for result
      local co = coroutine.running()
      if co then
        vim.ui.select(items, {
          prompt = "Select executable to debug:",
        }, function(choice, idx)
          if not choice or not idx then
            selected_program = project_root -- Fallback
            coroutine.resume(co)
            return
          end

          if idx == #items then
            -- User selected "Enter custom path..."
            vim.ui.input({
              prompt = "Enter path to executable: ",
              default = "",
            }, function(path)
              if path and path ~= "" then
                selected_program = path
              else
                selected_program = project_root -- Fallback
              end
              coroutine.resume(co)
            end)
          else
            local exec = executables[idx]
            selected_program = exec.relative == "." and project_root or (project_root .. "/" .. exec.relative)
            coroutine.resume(co)
          end
        end)

        coroutine.yield()
        return selected_program
      end

      -- Fallback if not in coroutine
      return project_root
    end

    -- Define Go debug configurations
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = select_go_executable_sync,
        cwd = "${workspaceFolder}",
      },
      {
        type = "go",
        name = "Debug with arguments",
        request = "launch",
        program = select_go_executable_sync,
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
        cwd = "${workspaceFolder}",
      },
      {
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
        processId = function()
          return tonumber(vim.fn.input("Process ID: "))
        end,
      },
    }
  end,
}

M.keys = function()
  local dap = require("dap")
  local dapui = require("dapui")
  return {
    { "<F2>",        function() dap.step_into() end,                                 desc = "DAP step into" },
    { "<F3>",        function() dap.step_over() end,                                 desc = "DAP step over" },
    { "<F4>",        function() dap.step_out() end,                                  desc = "DAP step out" },
    { "<F5>",        function()
      if dap.session() then
        -- During debug: continue execution
        dap.continue()
      else
        -- Not debugging: auto-start with first config (Debug with executable picker)
        if vim.bo.filetype == "go" and dap.configurations.go then
          dap.run(dap.configurations.go[1])
        else
          -- Fallback to standard continue for other languages
          dap.continue()
        end
      end
    end, desc = "DAP continue / Quick start" },
    { "<F6>",        function() dap.terminate() end,                                 desc = "DAP terminate" },
    { "<Leader>db",  function() dap.toggle_breakpoint() end,                         desc = "Toggle breakpoint" },
    { "<Leader>dd",  function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
    { "<Leader>dlr", function() dap.run_last() end,                                  desc = "Run last" },
    { "<Leader>du",  function() dapui.toggle() end,                                  desc = "Toggle DAP UI" },
    { "<Leader>de",  function() dap.repl.open() end,                                 desc = "Open DAP REPL" },
    { "<Leader>dlc", function() dap.run_to_cursor() end,                             desc = "Run to cursor" },
  }
end

return M
