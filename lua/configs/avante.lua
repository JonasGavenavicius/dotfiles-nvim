return {
  "yetone/avante.nvim",
  build = "make",  -- this builds avante_templates
  lazy = false,
  config = function()
    require("avante").setup({
      -- Try Claude first, fallback to OpenAI
      provider = "claude",
      auto_suggestions = false,
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20241022",
        temperature = 0,
        max_tokens = 4096,
        api_key_name = "ANTHROPIC_API_KEY", -- environment variable name
      },
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",
        temperature = 0,
        max_tokens = 4096,
        api_key_name = "OPENAI_API_KEY", -- environment variable name
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30, -- percentage of available width
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      },
      -- System prompt for better code assistance
      system_prompt = [[
You are an expert programming assistant. Focus on:
- Writing clean, efficient, and well-documented code
- Following best practices and conventions
- Providing clear explanations for complex logic
- Suggesting optimizations and improvements
- Helping with debugging and troubleshooting
]],
      show_prompt = true,
      show_model = true,
    })
    
    -- Add keybindings for Avante
    vim.keymap.set("n", "<leader>aa", function() require("avante.api").ask() end, { desc = "Avante: Ask" })
    vim.keymap.set("v", "<leader>aa", function() require("avante.api").ask() end, { desc = "Avante: Ask" })
    vim.keymap.set("n", "<leader>ar", function() require("avante.api").refresh() end, { desc = "Avante: Refresh" })
    vim.keymap.set("n", "<leader>ae", function() require("avante.api").edit() end, { desc = "Avante: Edit" })
    vim.keymap.set("v", "<leader>ae", function() require("avante.api").edit() end, { desc = "Avante: Edit" })
  end, 
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  }
}