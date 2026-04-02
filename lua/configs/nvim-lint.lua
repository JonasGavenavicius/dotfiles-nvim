return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      kotlin = { "ktlint" },
      terraform = { "tflint" },
      ruby = { "rubocop" },
    }

    local function available_linters(filetype)
      local linters = lint.linters_by_ft[filetype] or {}
      local available = {}

      for _, name in ipairs(linters) do
        local linter = lint.linters[name]
        local cmd = linter and linter.cmd

        if type(cmd) == "function" then
          table.insert(available, name)
        elseif type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
          table.insert(available, name)
        end
      end

      return available
    end

    local function try_lint_current_buffer()
      local linters = available_linters(vim.bo.filetype)
      if #linters == 0 then
        return
      end

      lint.try_lint(linters)
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = try_lint_current_buffer,
    })

    vim.keymap.set("n", "<leader>ll", function()
      try_lint_current_buffer()
    end, { desc = "Trigger linting for current file" })
  end,
}
