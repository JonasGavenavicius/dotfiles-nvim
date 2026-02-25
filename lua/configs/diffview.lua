return {
    -- Git diff viewer
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diffview" },
        { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git File History" },
    },
    config = function()
        local ok, diffview = pcall(require, "diffview")
        if not ok then
            vim.notify("Failed to load diffview", vim.log.levels.ERROR)
            return
        end
        
        diffview.setup({
            keymaps = {
                file_panel = {
                    ["gf"] = function()
                        local ok, diffview_lib = pcall(require, "diffview.lib")
                        if not ok then return end
                        
                        local file = diffview_lib.get_current_view():get_file()
                        if file then
                            vim.cmd('DiffviewClose')
                            vim.cmd('edit ' .. vim.fn.fnameescape(file.path))
                        end
                    end,
                },
            },
        })
    end,
}
