local function toggle_focus_mode()
  local ok, minimap = pcall(require, "mini.map")
  if ok then
    minimap.close()
  end

  require("twilight").toggle()
end

return {
  "folke/twilight.nvim",
  cmd = { "FocusMode", "Twilight" },
  keys = {
    { "<leader>uf", toggle_focus_mode, desc = "Toggle focus mode" },
  },
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
    vim.api.nvim_create_user_command("FocusMode", toggle_focus_mode, { desc = "Toggle focus mode" })
  end,
}
