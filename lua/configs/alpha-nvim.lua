local M = {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- icons for dashboard
      "folke/snacks.nvim", -- for picker functionality
    },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                          ]],
        [[                    wow                   ]],
        [[         ▄              ▄                ]],
        [[        ▌▒█           ▄▀▒▌               ]],
        [[        ▌▒▒█        ▄▀▒▒▒▐               ]],
        [[       ▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐               ]],
        [[     ▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐    much code  ]],
        [[   ▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌               ]],
        [[  ▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌              ]],
        [[  ▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐              ]],
        [[ ▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌   so nvim   ]],
        [[ ▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌             ]],
        [[▌▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐             ]],
        [[▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌   very wow  ]],
        [[▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐             ]],
        [[ ▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒▒▒▒▌              ]],
        [[  ▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒▒▄▒▒▐               ]],
        [[   ▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀                ]],
        [[     ▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀                  ]],
        [[        ▀▀▀▀▀▀▀▄▄▄▄▀▀                    ]],
        [[                                          ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("r", "󰋚  Resume session", ":lua require('persistence').load({ last = true })<CR>"),
        dashboard.button("f", "󰱼  Find file", ":lua require('snacks').picker.files()<CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("p", "󰄉  Recent files", ":lua require('snacks').picker.recent()<CR>"),
        dashboard.button("d", "󰕴  Diff view", ":DiffviewOpen<CR>"),
        dashboard.button("h", "󰊢  File history", ":DiffviewFileHistory<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
      }
      dashboard.section.buttons.opts.spacing = 1
      dashboard.section.footer.val = {
        "",
        "Press <space> to browse commands",
      }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  }
}

return M
