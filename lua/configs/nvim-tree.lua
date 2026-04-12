local M = {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeFindFile", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeToggle" },
  keys = {
    { "<leader>el", "<cmd>NvimTreeToggle<CR>", desc = "Toggle project sidebar" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local TREE_WIDTH = 36

    require("nvim-tree").setup({
      disable_netrw = false,
      hijack_netrw = false,
      view = {
        width = TREE_WIDTH,
        signcolumn = "yes",
        cursorline = true,
      },
      renderer = {
        add_trailing = false,
        group_empty = true,
        root_folder_label = false,
        symlink_destination = false,
        highlight_git = "name",
        highlight_opened_files = "name",
        highlight_modified = "name",
        indent_markers = {
          enable = true,
          inline_arrows = false,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          padding = {
            icon = "  ",
            folder_arrow = " ",
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
            modified = true,
            diagnostics = false,
            bookmarks = false,
          },
          glyphs = {
            modified = "●",
            folder = {
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "",
              unmerged = "",
              renamed = "",
              untracked = "",
              deleted = "",
              ignored = "",
            },
          },
        },
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {},
      },
    })
  end,
}

return M
