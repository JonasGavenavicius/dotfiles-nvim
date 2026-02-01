local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  branch = "main",
  opts = {
    ensure_installed = {
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
      "sql",
      "svelte",
      "yaml",
      "rust",
    },
    auto_install = true,
    highlight = {
      enable = true,
      use_languagetree = true,
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    indent = { enable = true },
  },
}

return M
