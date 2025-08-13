return {
    -- Visual Git diff viewer
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diffview" },
        { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git File History" },
    },
    config = true,
}
