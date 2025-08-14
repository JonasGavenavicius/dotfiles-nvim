return {
    -- Git diff viewer
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diffview" },
        { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git File History" },
    },
    config = function()
        require('diffview').setup({
            keymaps = {
                file_panel = {
                    ["gf"] = function()
                        local file = require('diffview.lib').get_current_view():get_file()
                        if file then
                            vim.cmd('DiffviewClose')
                            vim.cmd('edit ' .. file.path)
                        end
                    end,
                },
            },
        })
    end,
}
