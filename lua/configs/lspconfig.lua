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
      
      -- Use terminal utilities module
      local terminal_utils = require("utils.terminal")
      local multi_service = require("utils.multi_service_launcher")
      local process_manager = require("utils.process_manager")

      -- Set up keymaps
      -- Simple run (all languages)
      vim.keymap.set("n", "<leader>rf", terminal_utils.run_current_file, { desc = "Run current file" })
      vim.keymap.set("n", "<leader>rc", terminal_utils.run_with_arguments, { desc = "Run with arguments" })

      -- Smart project run (language-aware)
      vim.keymap.set("n", "<leader>rp", terminal_utils.run_project, { desc = "Run project (smart)" })
      vim.keymap.set("n", "<leader>ra", terminal_utils.run_project_with_arguments, { desc = "Run project with arguments" })
      vim.keymap.set("n", "<leader>rb", terminal_utils.build_project, { desc = "Build project" })
      vim.keymap.set("n", "<leader>rd", function()
        if vim.bo.filetype == "go" then
          require("dap").continue() -- Opens DAP config picker
        else
          vim.notify("Smart debug only supported for Go", vim.log.levels.WARN)
        end
      end, { desc = "Debug project (picker)" })

      -- Multi-service management (Go only for now)
      vim.keymap.set("n", "<leader>rm", function()
        if vim.bo.filetype == "go" then
          multi_service.launch_services()
        else
          vim.notify("Multi-service launcher only supported for Go", vim.log.levels.WARN)
        end
      end, { desc = "Launch multiple services" })

      vim.keymap.set("n", "<leader>rs", function()
        if vim.bo.filetype == "go" then
          multi_service.start_service()
        else
          vim.notify("Service management only supported for Go", vim.log.levels.WARN)
        end
      end, { desc = "Start service" })

      vim.keymap.set("n", "<leader>rk", multi_service.stop_service, { desc = "Stop service" })
      vim.keymap.set("n", "<leader>rr", multi_service.restart_service, { desc = "Restart service" })
      vim.keymap.set("n", "<leader>rK", process_manager.stop_all, { desc = "Stop all services" })
      vim.keymap.set("n", "<leader>rl", process_manager.show_status_ui, { desc = "List services" })

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

      -- Setup LSP servers using official vim.lsp.config API
      
      -- lua_ls (Lua Language Server)
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              },
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- gopls (Go Language Server)
      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- rust_analyzer (Rust Language Server)
      vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
          },
        },
      })

      -- ruby_lsp (Ruby Language Server)
      vim.lsp.config('ruby_lsp', {
        cmd = { 'ruby-lsp' },
        filetypes = { 'ruby' },
        root_markers = { 'Gemfile', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- jsonls (JSON Language Server)
      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- terraformls (Terraform Language Server)
      vim.lsp.config('terraformls', {
        cmd = { 'terraform-ls', 'serve' },
        filetypes = { 'terraform', 'tf' },
        root_markers = { '.terraform', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      -- Enable each configured server
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('gopls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('ruby_lsp')
      vim.lsp.enable('jsonls')
      vim.lsp.enable('terraformls')
    end,
  },
}
