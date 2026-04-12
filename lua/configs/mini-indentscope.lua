local M = {
  "echasnovski/mini.indentscope",
  version = "*",
  event = "BufReadPre",
  config = function()
    require("mini.indentscope").setup({
      symbol = "▏",
      options = {
        try_as_border = true,
      },
      draw = {
        delay = 40,
        animation = require("mini.indentscope").gen_animation.quadratic({
          easing = "out",
          duration = 14,
        }),
      },
    })
  end,
}

return M
