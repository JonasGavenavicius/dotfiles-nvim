local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      -- layout = { preset = "ivy", layout = { position = "bottom" } },
      win = {
        input = {
          keys = {
            ["<C-t>"] = { "qflist", mode = { "i", "n" } },
            ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          }
        }
      }
    }
  }
}

M.config = function(_, opts)
  require("snacks").setup(opts)

  local map = vim.keymap.set
  local picker = require("snacks").picker
  local todo = require("todo-comments")

  map("n", "<leader>ff", picker.files, { desc = "Find Files" })
  map("n", "<leader>fg", function() picker.grep({ regex = false }) end, { desc = "Grep (Literal)" })
  map("n", "<leader>fr", picker.grep, { desc = "Grep (Regex)" })
  map("n", "<leader>fb", picker.buffers, { desc = "Buffers" })
  map("n", "<leader>fH", picker.help, { desc = "Help Tags" })
  map("n", "<leader>fT", function()
    todo.search()
    picker.qflist()
  end, { desc = "Todos (via qflist)" })

  map("n", "<leader>gt", picker.git_status, { desc = "Git Status" })
  map("n", "<leader>gs", picker.git_log, { desc = "Git Log" })

  map("n", "grr", picker.lsp_references, { desc = "LSP References" })
  map("n", "gri", picker.lsp_implementations, { desc = "LSP Implementations" })
  map("n", "grh", picker.lsp_symbols, { desc = "LSP Document Symbols" })
  map("n", "grdd", picker.lsp_definitions, { desc = "LSP Definitions" })
  map("n", "grdt", picker.lsp_type_definitions, { desc = "LSP Type Definitions" })
  map("n", "<leader>fd", picker.diagnostics, { desc = "LSP Diagnostics" })

  -- Local directory search
  local function get_current_dir()
    -- Check if we're in oil.nvim
    if vim.bo.filetype == "oil" then
      return require("oil").get_current_dir()
    else
      return vim.fn.expand("%:p:h")
    end
  end

  map("n", "<leader>flf", function()
    local current_dir = get_current_dir()
    if current_dir then
      picker.files({ cwd = current_dir })
    else
      vim.notify("Could not determine current directory", vim.log.levels.WARN)
    end
  end, { desc = "Find Files (Current Dir)" })
  
  map("n", "<leader>flg", function()
    local current_dir = get_current_dir()
    if current_dir then
      picker.grep({ cwd = current_dir, regex = false })
    else
      vim.notify("Could not determine current directory", vim.log.levels.WARN)
    end
  end, { desc = "Grep Literal (Current Dir)" })
  
  map("n", "<leader>flr", function()
    local current_dir = get_current_dir()
    if current_dir then
      picker.grep({ cwd = current_dir })
    else
      vim.notify("Could not determine current directory", vim.log.levels.WARN)
    end
  end, { desc = "Grep Regex (Current Dir)" })
end

return M
