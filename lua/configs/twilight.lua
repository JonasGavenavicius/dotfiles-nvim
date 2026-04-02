return {
  "folke/twilight.nvim",
  opts = {
    context = 12,
    dimming = {
      alpha = 0.35,
    },
    exclude = {
      "alpha",
      "lazy",
      "mason",
      "NvimTree",
      "oil",
    },
  },
  config = function(_, opts)
    local twilight = require("twilight")

    twilight.setup(opts)

    local function toggle_focus_mode()
      local ok, minimap = pcall(require, "mini.map")
      if ok then
        minimap.close()
      end

      twilight.toggle()
    end

    vim.keymap.set("n", "<leader>uf", toggle_focus_mode, { desc = "Toggle focus mode" })
    vim.api.nvim_create_user_command("FocusMode", toggle_focus_mode, { desc = "Toggle focus mode" })
  end,
}
