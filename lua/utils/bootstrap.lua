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
  local ts_parsers = require("nvim-treesitter.parsers")
  local parsers = treesitter.parsers or {}
  local missing = {}

  if #parsers == 0 then
    return
  end

  for _, parser in ipairs(parsers) do
    if not ts_parsers.has_parser(parser) then
      table.insert(missing, parser)
    end
  end

  if #missing == 0 then
    vim.notify("Treesitter parsers are already installed.", vim.log.levels.INFO)
    return
  end

  local ok, err = pcall(vim.cmd, "TSInstallSync " .. table.concat(missing, " "))
  if not ok then
    vim.notify("Treesitter bootstrap failed: " .. err, vim.log.levels.ERROR)
    return
  end

  vim.notify("Treesitter parsers installed: " .. table.concat(missing, ", "), vim.log.levels.INFO)
end

local function install_mason_packages()
  local mason = require("configs.mason")
  local registry = require("mason-registry")
  local mappings = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
  local package_names = {}
  local seen = {}

  local function add_package(package_name)
    if package_name and package_name ~= "" and not seen[package_name] then
      seen[package_name] = true
      table.insert(package_names, package_name)
    end
  end

  for _, server in ipairs(mason.servers) do
    add_package(mappings[server] or server)
  end

  for _, package_name in ipairs(mason.dap_adapters or {}) do
    add_package(package_name)
  end

  for _, package_name in ipairs(mason.formatters or {}) do
    add_package(package_name)
  end

  for _, package_name in ipairs(mason.linters or {}) do
    add_package(package_name)
  end

  for _, package_name in ipairs(mason.tools or {}) do
    add_package(package_name)
  end

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
