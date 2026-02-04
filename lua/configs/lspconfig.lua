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

      -- Setup run and service keymaps (extracted to separate modules)
      require("configs.keymaps.run").setup()
      require("configs.keymaps.services").setup()

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
      -- Enhance capabilities with semantic tokens for rich Go highlighting
      local gopls_capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        {
          textDocument = {
            semanticTokens = {
              dynamicRegistration = false,
              tokenTypes = {
                "namespace", "type", "class", "enum", "interface",
                "struct", "typeParameter", "parameter", "variable",
                "property", "enumMember", "event", "function", "method",
                "macro", "keyword", "modifier", "comment", "string",
                "number", "regexp", "operator"
              },
              tokenModifiers = {
                "declaration", "definition", "readonly", "static",
                "deprecated", "abstract", "async", "modification",
                "documentation", "defaultLibrary"
              },
              formats = { "relative" },
              requests = {
                range = true,
                full = { delta = true },
              },
            },
          },
        }
      )

      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        capabilities = gopls_capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            semanticTokens = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
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
