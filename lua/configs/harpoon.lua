local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ha",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon add file",
    },
    {
      "<leader>hl",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon list files",
    },
    {
      "<leader>h1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon select 1 file",
    },
    {
      "<leader>h2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon select 2 file",
    },
    {
      "<leader>h3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon select 3 file",
    },
    {
      "<leader>h4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon select 4 file",
    },
    {
      "<leader>h5",
      function()
        require("harpoon"):list():select(5)
      end,
      desc = "Harpoon select 5 file",
    },
    {
      "<leader>h6",
      function()
        require("harpoon"):list():select(6)
      end,
      desc = "Harpoon select 6 file",
    },
    {
      "<leader>h7",
      function()
        require("harpoon"):list():select(7)
      end,
      desc = "Harpoon select 7 file",
    },
    {
      "<leader>h8",
      function()
        require("harpoon"):list():select(8)
      end,
      desc = "Harpoon select 8 file",
    },
    {
      "<leader>hp",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon select previous file",
    },
    {
      "<leader>hn",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon select next file",
    },
    {
      "<leader>fh",
      function()
        local harpoon = require("harpoon")
        local picker = require("snacks").picker
        local harpoon_files = harpoon:list()
        local items = {}

        for i, item in ipairs(harpoon_files.items) do
          if item.value and item.value ~= "" then
            table.insert(items, {
              text = string.format("[%d] %s", i, vim.fn.fnamemodify(item.value, ":~:.")),
              value = item.value,
            })
          end
        end

        if #items == 0 then
          vim.notify("No harpoon files", vim.log.levels.WARN)
          return
        end

        picker.pick({
          title = "Harpoon Files",
          items = items,
          format = function(item)
            return item.text
          end,
          on_select = function(item)
            vim.cmd("edit " .. item.value)
          end,
        })
      end,
      desc = "Open harpoon picker",
    },
  },
}

M.config = function()
  local harpoon = require("harpoon")

  harpoon:setup()
end

return M
