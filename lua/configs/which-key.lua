
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
            notify = false, -- Disable overlap warnings
            ignore_missing = true,
        })

        -- Updated to new which-key spec
        wk.add({
            { "<leader>a", group = "AI/Avante" },
            { "<leader>d", group = "Debug" },
            { "<leader>e", group = "Explorer" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>l", group = "LSP/Lint" },
            { "<leader>r", group = "Run" },
            { "<leader>s", group = "Search/Replace" },
            { "<leader>t", group = "Test" },
            { "<leader>tr", group = "Test Ruby" },
            { "<leader>ts", group = "Test Scan" },
            { "<leader>u", group = "UI/Theme" },
            { "gr", group = "References" },
        })
    end,
}

return M

