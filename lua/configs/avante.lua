return {
  "yetone/avante.nvim",
  build = "make",
  lazy = true,
  cmd = { "AvanteAsk", "AvanteEdit", "AvanteRefresh", "AvanteToggle" },
  keys = {
    { "<leader>aa", desc = "Ask Avante" },
    { "<leader>ae", desc = "Edit with Avante" },
    { "<leader>ar", desc = "Refresh Avante" },
  },
  opts = {
    provider = "openai", -- primary, with claude as fallback
    auto_suggestions = false,
    system_prompt = "You are an expert programming assistant focused on clean, efficient code and best practices.",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {},
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  }
}
