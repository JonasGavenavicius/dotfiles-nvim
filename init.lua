-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
require "options"
require "autocmds"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({
    -- Themes
    { require "configs.themes.catppuccin" },
    { require "configs.themes.gruvbox" },
    { require "configs.themes.rose-pine" },
    { require "configs.themes.cyberdream" },

    -- Plugins
    { "nvim-lua/plenary.nvim" }, -- Utility library (dependency for many plugins)
    { require "configs.lspkind" },
    { require "configs.web-icons" },
    { require "configs.which-key" },
    { require "configs.mason" },
    { require "configs.lspconfig" },
    { require "configs.cmp" },
    { require "configs.treesitter" },
    { require "configs.conform" },
    { require "configs.dap.init" },
    { require "configs.lualine" },
    { require "configs.autopairs" },
    { require "configs.nvim-lint" },
    { require "configs.nvim-ufo" },
    { require "configs.harpoon" },
    { require "configs.persistence" },
    { require "configs.breadcrumbs" },
    { require "configs.languages.ruby.init" },
    { require "configs.copilot" },
    { require "configs.neotest" },
    { require "configs.alpha-nvim" },
    { require "configs.nvim-tree" },
    { require "configs.oil-nvim" },
    { require "configs.mini-indentscope" },
    { require "configs.toggleterm" },
    { require "configs.gitsigns" },
    { require "configs.nvim-scrollbar" },
    { require "configs.mini-map" },
    { require "configs.trouble" },
    { require "configs.gitlinker" },
    { require "configs.codeowners" },
    { require "configs.snacks" },
    { require "configs.diffview" },
    { require "configs.twilight" },
    { require "configs.render-markdown" },
    { require "configs.todo" },
    { require "configs.leap" },
    { require "configs.avante" },
})

-- Initialize theme picker
require("configs.theme-picker").setup()

vim.schedule(function()
    require "mappings"
end)
