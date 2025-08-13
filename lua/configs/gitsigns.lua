local M = {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup {
      current_line_blame = true,  -- Show inline blame (author + timestamp)
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set

        -- Git hunk navigation
        map("n", "]h", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Next git hunk" })

        map("n", "[h", function()
          if vim.wo.diff then return "[c" end  
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Previous git hunk" })

        -- Git hunk actions
        map("n", "<leader>ghs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        map("n", "<leader>ghr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        map("v", "<leader>ghs", function() 
          gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) 
        end, { buffer = bufnr, desc = "Stage selected lines" })

        -- Git buffer actions
        map("n", "<leader>gbs", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
        map("n", "<leader>gbr", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })

        -- Git blame and preview
        map("n", "<leader>gbl", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
        map("n", "<leader>ghp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
        
        -- Undo stage hunk
        map("n", "<leader>ghu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
        
        -- Toggle word diff
        map("n", "<leader>gld", gs.toggle_word_diff, { buffer = bufnr, desc = "Toggle word diff" })
      end,
    }
  end
}

return M
