local M = {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeFindFile", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeToggle" },
    keys = {
        { "<leader>el", "<cmd>NvimTreeToggle<CR>", desc = "Toggle project sidebar" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional icons
    config = function()
        local TREE_WIDTH = 38
        
        require("nvim-tree").setup({
            disable_netrw = false,
            hijack_netrw = false,
            view = {
              width = TREE_WIDTH,
            },
            renderer = {
              group_empty = true,
            },
            filters = {
              dotfiles = false,
            },
            update_focused_file = {
              enable = true,
              update_cwd = false, -- (optional) set to true if you want to update Neovim's cwd too
              ignore_list = {},
            },
          })
    end,
  }

return M
