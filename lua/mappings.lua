local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })


-- LSP / Buffer
map("n", "grb", function()
  vim.lsp.buf.format()
end, { desc = "Format current buffer" })

-- Copy relative file path
map("n", "<leader>lf", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("Copied: " .. path)
end, { desc = "Copy relative file path to clipboard" })

-- Helper: interactive string replace
local function replace_cmd(scope, confirm)
  return function()
    local scope_label = scope == "%" and "buffer" or "quickfix files"
    local confirm_label = confirm and "confirm each" or "no confirm"

    vim.ui.input({ prompt = string.format("Find string (%s, %s): ", scope_label, confirm_label) }, function(source)
      if not source or source == "" then
        return
      end

      vim.ui.input({ prompt = "Replace with: " }, function(target)
        if target == nil then
          return
        end

        source = vim.fn.escape(source, [[\/|]])
        target = vim.fn.escape(target, [[\/&|]])

        local flags = confirm and "gc" or "g"
        local cmd
        if scope == "%" then
          cmd = string.format("keeppatterns %%s/%s/%s/%s", source, target, flags)
        else
          cmd = string.format("cfdo keeppatterns %%s/%s/%s/%s | update", source, target, flags)
        end

        vim.cmd(cmd)
      end)
    end)
  end
end

-- Replace mappings
map("n", "<leader>sS", replace_cmd("%", false), { desc = "Replace in buffer (no confirm)" })
map("n", "<leader>ss", replace_cmd("%", true), { desc = "Replace in buffer (confirm each)" })
map("n", "<leader>sG", replace_cmd("quickfix", false), { desc = "Replace in quickfix files (no confirm)" })
map("n", "<leader>sg", replace_cmd("quickfix", true), { desc = "Replace in quickfix files (confirm each)" })
