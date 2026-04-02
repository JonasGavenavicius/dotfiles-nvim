return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "Avante", "markdown" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "Avante" },
    },
}
