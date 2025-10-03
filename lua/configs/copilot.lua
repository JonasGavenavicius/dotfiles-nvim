return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            local copilot_node_command = vim.fn.executable("mise") == 1 and "/opt/homebrew/bin/node" or "node"

            require("copilot").setup({
                copilot_node_command = copilot_node_command,
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = {
                        jump_next = "<c-n>",
                        jump_prev = "<c-p>",
                        accept = "<c-cr>",
                        refresh = "r",
                        open = "<M-CR>",
                    },
                    layout = {
                        position = "bottom", -- | top | left | right
                        ratio = 0.4,
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<c-a>",
                        accept_word = false,
                        accept_line = false,
                        next = "<c-j>",
                        prev = "<c-k>",
                        dismiss = "<C-e>",
                    },
                },
            })
        end,
    },
}