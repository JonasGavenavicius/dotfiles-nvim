return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      inlay_hints = { enabled = true },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      function RunCurrentFileInToggleTerm()
        local file = vim.fn.expand("%:p") -- Use full path for security
        if file == "" or not vim.fn.filereadable(file) then
          vim.notify("No valid file to run", vim.log.levels.WARN)
          return
        end
        
        local ft = vim.bo.filetype
        local commands = {
          go = "go run " .. vim.fn.shellescape(file),
          ruby = "bundle exec ruby " .. vim.fn.shellescape(file),
          rust = "cargo run",
          python = "python " .. vim.fn.shellescape(file),
        }
        
        local cmd = commands[ft]
        if not cmd then
          vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
          return
        end

        -- Wait for key press after execution
        cmd = cmd .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]

        if _RUN_TERM == nil then
          local Terminal = require("toggleterm.terminal").Terminal
          _RUN_TERM = Terminal:new({
            direction = "float",
            on_exit = function() _RUN_TERM = nil end,
          })
        end

        _RUN_TERM.cmd = cmd
        _RUN_TERM:toggle()
      end

      vim.keymap.set("n", "<leader>rf", RunCurrentFileInToggleTerm, { desc = "Run current file in terminal" })

      local on_attach = function(_, bufnr)
        local opts = function(desc)
          return { buffer = bufnr, desc = "LSP: " .. desc }
        end
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts("Code Action"))
        vim.keymap.set("n", "grl", function()
          vim.diagnostic.setloclist()
          vim.cmd("lopen")
        end, { desc = "Open File Diagnostics (Loclist)" })

        local border = "rounded"

        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = border,
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
          { border = border })
      end

      -- gopls
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- rust_analyzer
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
          },
        },
      })

      -- ruby_lsp
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "ruby-lsp" },
        filetypes = { "ruby" },
        root_dir = util.root_pattern("Gemfile", ".git"),
      })
    end,
  },
}
