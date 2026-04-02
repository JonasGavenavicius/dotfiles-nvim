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
  "javascript",
  "json",
  "lua",
  "markdown",
  "proto",
  "python",
  "rego",
  "ruby",
  "rust",
  "sql",
  "svelte",
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
  require("nvim-treesitter").setup(opts)
end

return M
