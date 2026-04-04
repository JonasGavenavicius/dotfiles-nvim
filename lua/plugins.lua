local specs = {}

local function add(spec)
  if not spec then
    return
  end

  if type(spec[1]) == "table" then
    vim.list_extend(specs, spec)
    return
  end

  table.insert(specs, spec)
end

add(require("configs.themes.catppuccin"))
add(require("configs.themes.gruvbox"))
add(require("configs.themes.rose-pine"))
add(require("configs.themes.cyberdream"))

add({ "nvim-lua/plenary.nvim", lazy = true })
add(require("configs.lspkind"))
add(require("configs.web-icons"))
add(require("configs.which-key"))
add(require("configs.mason"))
add(require("configs.lsp-signature"))
add(require("configs.lspconfig"))
add(require("configs.illuminate"))
add(require("configs.cmp"))
add(require("configs.treesitter"))
add(require("configs.conform"))
add(require("configs.dap.init"))
add(require("configs.lualine"))
add(require("configs.autopairs"))
add(require("configs.nvim-lint"))
add(require("configs.nvim-ufo"))
add(require("configs.harpoon"))
add(require("configs.persistence"))
add(require("configs.breadcrumbs"))
add(require("configs.languages.ruby.init"))
add(require("configs.copilot"))
add(require("configs.neotest"))
add(require("configs.alpha-nvim"))
add(require("configs.nvim-tree"))
add(require("configs.oil-nvim"))
add(require("configs.mini-indentscope"))
add(require("configs.toggleterm"))
add(require("configs.gitsigns"))
add(require("configs.nvim-scrollbar"))
add(require("configs.mini-map"))
add(require("configs.trouble"))
add(require("configs.gitlinker"))
add(require("configs.codeowners"))
add(require("configs.snacks"))
add(require("configs.diffview"))
add(require("configs.twilight"))
add(require("configs.render-markdown"))
add(require("configs.todo"))
add(require("configs.leap"))
add(require("configs.avante"))

return specs
