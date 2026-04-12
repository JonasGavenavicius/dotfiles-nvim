local M = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set

        map("n", "]h", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buf = bufnr, desc = "Next git hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buf = bufnr, desc = "Previous git hunk" })

        map("n", "<leader>ghs", gs.stage_hunk, { buf = bufnr, desc = "Stage hunk" })
        map("n", "<leader>ghr", gs.reset_hunk, { buf = bufnr, desc = "Reset hunk" })
        map("v", "<leader>ghs", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { buf = bufnr, desc = "Stage selected lines" })

        map("n", "<leader>gbs", gs.stage_buffer, { buf = bufnr, desc = "Stage buffer" })
        map("n", "<leader>gbr", gs.reset_buffer, { buf = bufnr, desc = "Reset buffer" })

        map("n", "<leader>gbl", gs.toggle_current_line_blame, { buf = bufnr, desc = "Toggle line blame" })
        map("n", "<leader>ghp", gs.preview_hunk, { buf = bufnr, desc = "Preview hunk" })
        map("n", "<leader>ghd", gs.diffthis, { buf = bufnr, desc = "Diff this buffer" })
        map("n", "<leader>ghq", function()
          gs.setqflist("all")
        end, { buf = bufnr, desc = "Repository hunks to quickfix" })
        map("n", "<leader>ghu", gs.undo_stage_hunk, { buf = bufnr, desc = "Undo stage hunk" })

        map("n", "<leader>gwd", gs.toggle_word_diff, { buf = bufnr, desc = "Toggle word diff" })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buf = bufnr, desc = "Git hunk" })
      end,
    }
  end,
}

return M
