local function current_line_region()
  local line = vim.fn.line(".")
  return { line_start = line, line_end = line }
end

local function apply_current_hunk()
  MiniDiff.do_hunks(0, "apply", current_line_region())
end

local function reset_current_hunk()
  MiniDiff.do_hunks(0, "reset", current_line_region())
end

local function send_hunks_to_qf(scope)
  local items = MiniDiff.export("qf", { scope = scope or "current" })
  vim.fn.setqflist(items, "r")
  vim.cmd("copen")
end

return {
  "nvim-mini/mini.diff",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local diff = require("mini.diff")

    diff.setup({
      source = diff.gen_source.git(),
      mappings = {
        apply = "",
        reset = "",
        textobject = "",
        goto_first = "",
        goto_prev = "",
        goto_next = "",
        goto_last = "",
      },
    })

    local map = vim.keymap.set

    map("n", "<leader>gxt", MiniDiff.toggle, { desc = "Mini Diff Toggle" })
    map("n", "<leader>gxo", MiniDiff.toggle_overlay, { desc = "Mini Diff Overlay" })
    map("n", "<leader>gxf", function()
      MiniDiff.goto_hunk("first")
    end, { desc = "Mini Diff First Hunk" })
    map("n", "<leader>gxp", function()
      MiniDiff.goto_hunk("prev")
    end, { desc = "Mini Diff Previous Hunk" })
    map("n", "<leader>gxn", function()
      MiniDiff.goto_hunk("next")
    end, { desc = "Mini Diff Next Hunk" })
    map("n", "<leader>gxl", function()
      MiniDiff.goto_hunk("last")
    end, { desc = "Mini Diff Last Hunk" })
    map("n", "<leader>gxa", apply_current_hunk, { desc = "Mini Diff Apply Hunk" })
    map("n", "<leader>gxr", reset_current_hunk, { desc = "Mini Diff Reset Hunk" })
    map("n", "<leader>gxq", function()
      send_hunks_to_qf("current")
    end, { desc = "Mini Diff Current Hunks" })
    map("n", "<leader>gxQ", function()
      send_hunks_to_qf("all")
    end, { desc = "Mini Diff All Hunks" })
  end,
}
