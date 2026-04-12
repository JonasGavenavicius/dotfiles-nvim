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

      local function buffer_path(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == "" then
          return nil
        end

        if name:match("^file://") then
          return vim.uri_to_fname(name)
        end

        return name
      end

      local function is_lsp_eligible_buffer(bufnr)
        local path = buffer_path(bufnr)
        if not path or path == "" then
          return false
        end

        if vim.bo[bufnr].buftype ~= "" then
          return false
        end

        if path:match("^%w+://") then
          return false
        end

        return true
      end

      local function root_dir_from_markers(markers)
        local matcher = util.root_pattern(unpack(markers))

        return function(bufnr, on_dir)
          if not is_lsp_eligible_buffer(bufnr) then
            return
          end

          local path = buffer_path(bufnr)
          local root_dir = matcher(path)
          if root_dir then
            on_dir(root_dir)
          end
        end
      end

      -- Setup run and service keymaps (extracted to separate modules)
      require("configs.keymaps.run").setup()
      require("configs.keymaps.services").setup()

      local on_attach = function(_, bufnr)
        if not is_lsp_eligible_buffer(bufnr) then
          return
        end

        local opts = function(desc)
          return { buf = bufnr, desc = "LSP: " .. desc }
        end
        vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts("Code Action"))
        vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts("Show Signature Help"))
        vim.keymap.set("n", "grl", function()
          local current_bufname = vim.api.nvim_buf_get_name(0)
          if current_bufname:match("^%w+://") and not current_bufname:match("^file://") then
            vim.notify("Cannot open diagnostics for non-file buffer: " .. current_bufname, vim.log.levels.WARN)
            return
          end
          vim.diagnostic.setloclist()
          vim.cmd("lopen")
        end, { desc = "Open File Diagnostics (Loclist)" })
      end

      -- Setup LSP servers using official vim.lsp.config API
      
      -- lua_ls (Lua Language Server)
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_dir = root_dir_from_markers({ '.luarc.json', '.luarc.jsonc', '.git' }),
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
        root_dir = root_dir_from_markers({ 'go.work', 'go.mod', '.git' }),
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
        root_dir = root_dir_from_markers({ 'Cargo.toml', 'rust-project.json', '.git' }),
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
        root_dir = root_dir_from_markers({ 'Gemfile', '.git' }),
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- jsonls (JSON Language Server)
      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_dir = root_dir_from_markers({ '.git' }),
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- terraformls (Terraform Language Server)
      vim.lsp.config('terraformls', {
        cmd = { 'terraform-ls', 'serve' },
        filetypes = { 'terraform', 'tf' },
        root_dir = root_dir_from_markers({ '.terraform', '.git' }),
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
