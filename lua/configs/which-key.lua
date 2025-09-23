
local M = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        spec = {
            { "<leader>a", group = "AI/Avante" },
            { "<leader>d", group = "Debug" },
            { "<leader>e", group = "Explorer" },
            { "<leader>f", group = "Find" },
            { "<leader>fl", group = "Search in Local Directory" },
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
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}

return M

