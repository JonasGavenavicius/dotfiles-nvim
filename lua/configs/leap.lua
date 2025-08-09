return {
    "ggandor/leap.nvim",
    keys = { "s", "S", "gs" },
    config = function()
        local leap = require('leap')
        
        -- Set up leap with default mappings
        leap.add_default_mappings()
        
        -- Customize leap settings
        leap.opts.highlight_unlabeled_phase_one_targets = true
        leap.opts.case_sensitive = false
        
        -- Custom colors for leap targets
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'LeapMatch', { 
            fg = 'white',
            bold = true, 
            nocombine = true 
        })
        
        -- Add repeat functionality
        vim.keymap.set('n', 'gs', function()
            local current_window = vim.fn.win_getid()
            leap.leap { target_windows = { current_window } }
        end, { desc = "Leap forward to" })
    end,
}