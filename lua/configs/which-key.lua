local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    win = {
      border = "rounded",
      title = false,
      padding = { 1, 2 },
    },
    layout = {
      width = { min = 28 },
      spacing = 4,
    },
    icons = {
      breadcrumb = "›",
      separator = "󰁔",
      group = " ",
    },
    spec = {
      { "<leader>d", group = "Debug" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find" },
      { "<leader>fl", group = "Search in Local Directory" },
      { "<leader>g", group = "Git" },
      { "<leader>gc", group = "Conflicts" },
      { "<leader>gv", group = "Fugitive" },
      { "<leader>gw", group = "Worktrees" },
      { "<leader>gx", group = "Mini Diff" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>l", group = "LSP/Lint" },
      { "<leader>r", group = "Run" },
      { "<leader>s", group = "Search/Replace" },
      { "<leader>t", group = "Test" },
      { "<leader>tg", group = "Test Go" },
      { "<leader>tr", group = "Test Ruby" },
      { "<leader>u", group = "UI/Theme" },
      { "<leader>um", group = "Minimap" },
      { "gr", group = "References" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

return M
