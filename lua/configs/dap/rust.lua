-- Rust DAP configuration
local M = {}

-- Get codelldb path from Mason
local function get_codelldb_path()
  local mason_registry = require("mason-registry")
  local codelldb_pkg = mason_registry.get_package("codelldb")
  return codelldb_pkg:get_install_path() .. "/extension/adapter/codelldb"
end

M.setup = function(dap)
  -- Rust adapter (codelldb via Mason)
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
end

return M
