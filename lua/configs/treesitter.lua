local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSBufDisable", "TSBufEnable", "TSInstall", "TSInstallSync", "TSModuleInfo", "TSUpdate" },
}

M.parsers = {
  "bash",
  "csv",
  "dockerfile",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "json",
  "lua",
  "markdown",
  "proto",
  "rego",
  "regex",
  "ruby",
  "rust",
  "sql",
  "vim",
  "vimdoc",
  "yaml",
}

M.opts = {
  ensure_installed = M.parsers,
  auto_install = false,
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

function M.config(_, opts)
  require("utils.treesitter_compat").setup()
  require("nvim-treesitter.configs").setup(opts)
end

return M
