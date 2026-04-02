local M = {
    "ray-x/lsp_signature.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        bind = true,
        doc_lines = 2,
        floating_window = true,
        floating_window_above_cur_line = true,
        hint_enable = false,
        handler_opts = {
            border = "rounded",
        },
    },
}

return M
