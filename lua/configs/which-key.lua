local M = {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup({
            plugins = { spelling = true },
            key_labels = { ["<leader>"] = "SPC" },
            window = {
                border = "rounded",
                position = "bottom",
                margin = { 1, 0, 1, 0 },
                padding = { 1, 2, 1, 2 },
            },
        })
        
        -- Register key groups for better organization
        wk.register({
            ["<leader>a"] = { name = "+AI/Avante" },
            ["<leader>d"] = { name = "+Debug" },
            ["<leader>e"] = { name = "+Explorer" },
            ["<leader>f"] = { name = "+Find" },
            ["<leader>g"] = { name = "+Git" },
            ["<leader>h"] = { name = "+Harpoon" },
            ["<leader>l"] = { name = "+LSP/Lint" },
            ["<leader>r"] = { name = "+Run" },
            ["<leader>s"] = { name = "+Search/Replace" },
            ["<leader>t"] = { name = "+Test" },
            ["<leader>tr"] = { name = "+Test Ruby" },
            ["<leader>u"] = { name = "+UI/Theme" },
            ["gr"] = { name = "+References" },
        })
    end,
}

return M
