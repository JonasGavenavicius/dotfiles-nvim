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
        dashboard.button("r", "🔃  Resume Last Session", ":lua require('persistence').load({ last = true })<CR>"),
        dashboard.button("f", "🔎  Find file", ":lua require('snacks').picker.files()<CR>"),
        dashboard.button("e", "📄  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("p", "🗂️  Find project", ":lua require('snacks').picker.recent()<CR>"),
        dashboard.button("d", "📊  Git Diff View", ":DiffviewOpen<CR>"),
        dashboard.button("h", "📈  Git File History", ":DiffviewFileHistory<CR>"),
        dashboard.button("l", "🛠️  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "🚪  Quit NVIM", ":qa<CR>"),
      }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  }
}

return M
