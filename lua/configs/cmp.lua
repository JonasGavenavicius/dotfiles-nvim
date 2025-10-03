return {
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            "ray-x/lsp_signature.nvim",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            -- Load snippets from various sources
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
            
            require("luasnip.loaders.from_snipmate").load()
            require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }
            
            require("luasnip.loaders.from_lua").load()
            require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }
            
            -- Auto-unlink snippet nodes on leaving insert mode
            vim.api.nvim_create_autocmd("InsertLeave", {
                callback = function()
                    if
                        luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
                        and not luasnip.session.jump_active
                    then
                        luasnip.unlink_current()
                    end
                end,
            })

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        show_labelDetails = true, -- set to false to avoid unnecessary visual noise
                        menu = {
                            nvim_lsp = "[LSP]",
                            path = "[Path]",
                            buffer = "[Buffer]",
                            luasnip = "[LuaSnip]",
                        },
                    }),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false, -- Only confirm if explicitly selected
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                }),
            })
        end,
    },
}
