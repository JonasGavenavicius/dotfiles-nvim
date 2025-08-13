return {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
        { "<leader>sR", "<cmd>lua require('spectre').toggle()<CR>", desc = "Replace (Spectre)" },
        { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", desc = "Replace current word (Spectre)", mode = "n" },
        { "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>", desc = "Replace selection (Spectre)", mode = "v" },
        { "<leader>sf", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", desc = "Replace in file (Spectre)" },
    },
    opts = {
        open_cmd = "noswapfile vnew",
        live_update = false, -- auto execute search again when you write to any file in vim
        line_sep_start = '┌-----------------------------------------',
        result_padding = '¦  ',
        line_sep       = '└-----------------------------------------',
        highlight = {
            ui = "String",
            search = "DiffChange",
            replace = "DiffDelete"
        },
        mapping = {
            ['toggle_line'] = {
                map = "dd",
                cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                desc = "toggle current item"
            },
            ['enter_file'] = {
                map = "<cr>",
                cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                desc = "goto current file"
            },
            ['send_to_qf'] = {
                map = "<leader>q",
                cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                desc = "send all items to quickfix"
            },
            ['replace_cmd'] = {
                map = "<leader>c",
                cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                desc = "input replace command"
            },
            ['show_option_menu'] = {
                map = "<leader>o",
                cmd = "<cmd>lua require('spectre').show_options()<CR>",
                desc = "show options"
            },
            ['run_current_replace'] = {
                map = "<leader>rc",
                cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                desc = "replace current line"
            },
            ['run_replace'] = {
                map = "<leader>R",
                cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                desc = "replace all"
            },
        },
    },
}