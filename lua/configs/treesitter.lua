local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSBufDisable", "TSBufEnable", "TSInstall", "TSInstallSync", "TSModuleInfo", "TSUpdate" },
}

M.parsers = {
  "bash",
  "css",
  "csv",
  "dockerfile",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
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
  "tsx",
  "typescript",
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
  require("nvim-treesitter.configs").setup(opts)
end

return M
