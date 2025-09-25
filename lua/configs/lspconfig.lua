return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      inlay_hints = { enabled = true },
    },
    config = function()
      local util = require("lspconfig.util")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Program execution utilities
      local M = {}
      
      -- Default run commands for different file types
      M.run_commands = {
        go = function(file) return "go run " .. vim.fn.shellescape(file) end,
        rust = function(_) return "cargo run" end,
        ruby = function(file) return "bundle exec ruby " .. vim.fn.shellescape(file) end,
        python = function(file) return "python " .. vim.fn.shellescape(file) end,
        javascript = function(file) return "node " .. vim.fn.shellescape(file) end,
        typescript = function(file) return "tsx " .. vim.fn.shellescape(file) end,
        lua = function(file) return "lua " .. vim.fn.shellescape(file) end,
      }
      
      -- Create or reuse terminal for running programs
      M.get_run_terminal = function()
        if _RUN_TERM == nil then
          local Terminal = require("toggleterm.terminal").Terminal
          _RUN_TERM = Terminal:new({
            direction = "float",
            close_on_exit = false,
            on_exit = function() _RUN_TERM = nil end,
          })
        end
        return _RUN_TERM
      end
      
      -- Run current file with default command
      M.run_current_file = function()
        local file = vim.fn.expand("%:p")
        if file == "" or not vim.fn.filereadable(file) then
          vim.notify("No valid file to run", vim.log.levels.WARN)
          return
        end
        
        local ft = vim.bo.filetype
        local command_fn = M.run_commands[ft]
        if not command_fn then
          vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
          return
        end

        local cmd = command_fn(file)
        -- Add pause after execution
        cmd = cmd .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]

        local terminal = M.get_run_terminal()
        terminal.cmd = cmd
        terminal:toggle()
      end
      
      -- Run program with custom arguments
      M.run_with_arguments = function()
        local file = vim.fn.expand("%:p")
        if file == "" or not vim.fn.filereadable(file) then
          vim.notify("No valid file to run", vim.log.levels.WARN)
          return
        end
        
        local ft = vim.bo.filetype
        local command_fn = M.run_commands[ft]
        if not command_fn then
          vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
          return
        end
        
        local default_cmd = command_fn(file)
        
        vim.ui.input({
          prompt = "Run command: ",
          default = default_cmd .. " ",
        }, function(command)
          if command and command ~= "" then
            local terminal = M.get_run_terminal()
            -- Add pause after execution
            terminal.cmd = command .. [[; echo ""; read -n 1 -s -r -p "Press any key to close..."]]
            terminal:toggle()
          end
        end)
      end

      -- Set up keymaps
      vim.keymap.set("n", "<leader>rf", M.run_current_file, { desc = "Run current file" })
      vim.keymap.set("n", "<leader>rc", M.run_with_arguments, { desc = "Run current file with custom arguments" })

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

      -- Setup LSP servers using modern vim.lsp.config API
      
      -- gopls
      vim.lsp.config.gopls = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- rust_analyzer
      vim.lsp.config.rust_analyzer = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
          },
        },
      }

      -- ruby_lsp
      vim.lsp.config.ruby_lsp = {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,
  },
}
