return {
  'JonasGavenavicius/codeowners.nvim',
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require('codeowners').setup()
  end
}
