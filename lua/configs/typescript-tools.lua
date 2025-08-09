local M = {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        on_attach = function(client, bufnr)
            -- Disable formatting if you want to use prettier via conform
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                },
                preferences = {
                    importModuleSpecifier = "relative",
                    includePackageJsonAutoImports = "auto",
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                },
                preferences = {
                    importModuleSpecifier = "relative",
                    includePackageJsonAutoImports = "auto",
                },
            },
        },
    },
}

return M
