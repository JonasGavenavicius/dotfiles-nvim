local M = {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
}

M.config = function()
  require("git-conflict").setup {
    default_mappings = false,
    disable_diagnostics = true,
    list_opener = "copen",
  }

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function(args)
      local bufnr = args.buf

      if vim.b[bufnr].git_conflict_keymaps_set then
        return
      end

      vim.b[bufnr].git_conflict_keymaps_set = true

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buf = bufnr, desc = desc })
      end

      map("[x", "<cmd>GitConflictPrevConflict<CR>", "Previous conflict")
      map("]x", "<cmd>GitConflictNextConflict<CR>", "Next conflict")
      map("<leader>gco", "<cmd>GitConflictChooseOurs<CR>", "Choose ours")
      map("<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", "Choose theirs")
      map("<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", "Choose both")
      map("<leader>gc0", "<cmd>GitConflictChooseNone<CR>", "Choose none")
      map("<leader>gcl", "<cmd>GitConflictListQf<CR>", "List conflicts")

      vim.notify("Merge conflicts detected. Use ]x/[x to navigate and <leader>gc... to resolve.", vim.log.levels.WARN)
    end,
  })
end

return M
