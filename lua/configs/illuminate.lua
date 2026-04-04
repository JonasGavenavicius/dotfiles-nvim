return {
  "RRethy/vim-illuminate",
  event = "LspAttach", -- Lazy load when LSP attaches
  opts = {
    -- Providers to use for highlighting (in priority order)
    providers = {
      'lsp',        -- Use LSP document_highlight (gopls, lua_ls, etc.)
      'treesitter', -- Fallback to Treesitter if LSP doesn't support it
      'regex',      -- Last resort: regex matching
    },

    -- Delay in milliseconds before highlighting references
    -- Set to 0 to highlight immediately (uses vim.opt.updatetime instead)
    delay = 100,

    -- Filetypes to exclude from illumination
    filetypes_denylist = {
      'alpha',          -- Dashboard
      'NvimTree',       -- File tree
      'trouble',        -- Diagnostics window
      'toggleterm',     -- Terminal
      'TelescopePrompt',-- Telescope picker
      'neo-tree',       -- File tree
      'DiffviewFiles',  -- Diff view
      'help',           -- Help pages
    },

    -- Filetypes to always illuminate (even if in denylist by default)
    filetypes_allowlist = {},

    -- File size limit in lines (disable for large files to avoid slowdown)
    large_file_cutoff = 2000,

    -- Modes to illuminate in (n = normal, i = insert, v = visual)
    modes_denylist = {},

    -- Minimum number of matches required to illuminate
    min_count_to_highlight = 1,

    -- Case sensitivity for regex provider
    case_insensitive_regex = false,

    -- Under cursor highlighting (highlight the word under cursor differently)
    under_cursor = true,
  },

  config = function(_, opts)
    require('illuminate').configure(opts)

    -- Set custom highlight colors (optional - uses theme defaults if not set)
    -- Uncomment and customize if you want specific colors
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = '#3b4261' })  -- Variable references
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = '#3b4261' })  -- Read references
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = '#3b4261' }) -- Write references
  end,

  keys = {
    -- Navigate to next/previous reference
    {
      "]]",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "Next Reference",
    },
    {
      "[[",
      function()
        require("illuminate").goto_prev_reference(false)
      end,
      desc = "Previous Reference",
    },
  },
}
