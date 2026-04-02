local M = {}

local function load_bootstrap_plugins()
  require("lazy").load({
    plugins = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "mason-nvim-dap.nvim",
      "nvim-treesitter",
    },
  })
end

local function install_treesitter_parsers()
  local treesitter = require("configs.treesitter")
  local parsers = treesitter.parsers or {}

  if #parsers == 0 then
    return
  end

  local ok, err = pcall(vim.cmd, "TSInstallSync " .. table.concat(parsers, " "))
  if not ok then
    vim.notify("Treesitter bootstrap failed: " .. err, vim.log.levels.ERROR)
    return
  end

  vim.notify("Treesitter parsers are up to date.", vim.log.levels.INFO)
end

local function install_mason_packages()
  local mason = require("configs.mason")
  local registry = require("mason-registry")
  local mappings = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
  local package_names = {}

  for _, server in ipairs(mason.servers) do
    table.insert(package_names, mappings[server] or server)
  end

  vim.list_extend(package_names, mason.dap_adapters or {})

  registry.refresh(vim.schedule_wrap(function(success)
    if not success then
      vim.notify("Failed to refresh Mason registry.", vim.log.levels.ERROR)
      return
    end

    local started = 0

    for _, package_name in ipairs(package_names) do
      local ok, pkg = pcall(registry.get_package, package_name)
      if not ok then
        vim.notify("Unknown Mason package: " .. package_name, vim.log.levels.WARN)
      elseif not pkg:is_installed() then
        pkg:install()
        started = started + 1
      end
    end

    if started == 0 then
      vim.notify("Mason packages are already installed.", vim.log.levels.INFO)
    else
      vim.notify(string.format("Started Mason installs for %d package(s).", started), vim.log.levels.INFO)
    end
  end))
end

function M.run()
  load_bootstrap_plugins()
  install_treesitter_parsers()
  install_mason_packages()
end

return M
