local M = {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "TermExec", "ToggleTerm" },
    keys = {
        {
            [[<c-\>]],
            mode = { "i", "n", "t" },
            desc = "Toggle terminal",
        },
    },
}

M.config = function()
    local terminal_utils = require("utils.terminal")

    require("toggleterm").setup({
        direction = "float",
        float_opts = terminal_utils.get_float_opts(),
        open_mapping = [[<c-\>]],
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
    })
end

return M
