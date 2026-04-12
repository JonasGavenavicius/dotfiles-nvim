local opt = vim.opt
local g = vim.g

-- GENERAL -------------------------------------------------------------------

g.mapleader = " "
g.toggle_theme_icon = "   " -- Custom global var for UI (used in statusline, etc.)
g.ui_transparency_enabled = false

opt.termguicolors = true

-- UI ------------------------------------------------------------------------

opt.cursorline = true
opt.laststatus = 3
opt.showmode = false
opt.showtabline = 0
opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.ruler = false
opt.signcolumn = "yes:1"
opt.cursorlineopt = "number"
opt.fillchars = {
  eob = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  msgsep = " ",
}
opt.winborder = "rounded"
opt.wrap = false
opt.mouse = "a"
opt.pumblend = 8
opt.pumheight = 12
local SCROLL_OFFSET = 10
local SIDE_SCROLL_OFFSET = 8

opt.scrolloff = SCROLL_OFFSET
opt.sidescrolloff = SIDE_SCROLL_OFFSET

-- STARTUP -------------------------------------------------------------------

opt.shortmess:append("sI")

-- INDENTATION ---------------------------------------------------------------

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

-- SEARCH --------------------------------------------------------------------

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- NAVIGATION ----------------------------------------------------------------

opt.splitright = true
opt.splitbelow = true
local TIMEOUT_LEN = 400

opt.timeoutlen = TIMEOUT_LEN
opt.whichwrap:append("<>[]")
opt.diffopt:append({
  "vertical",
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
  "context:4",
})

-- FILE HANDLING -------------------------------------------------------------

opt.clipboard = "unnamedplus"
opt.undofile = true
opt.autoread = true
opt.autowrite = false
-- Time in ms for CursorHold event and swap file writes (default 4000ms, reduced for faster LSP/diagnostics)
local UPDATE_TIME = 250
-- Max time in ms for syntax highlighting/redrawing (prevents freezing on large/complex files)
local REDRAW_TIME = 10000
-- Max memory in KB for pattern matching (prevents OOM on pathological regex patterns)
local MAX_MEM_PATTERN = 20000

opt.updatetime = UPDATE_TIME

-- PERFORMANCE --------------------------------------------------------------
opt.redrawtime = REDRAW_TIME
opt.maxmempattern = MAX_MEM_PATTERN

-- DIAGNOSTICS ---------------------------------------------------------------

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '', -- Error sign
            [vim.diagnostic.severity.WARN]  = '', -- Warning sign
            [vim.diagnostic.severity.HINT]  = '󰌵', -- Hint sign
            [vim.diagnostic.severity.INFO]  = '', -- Info sign
        },
    },
    underline = false,
    update_in_insert = false, -- Don’t update diagnostics while typing
    severity_sort = true,     -- Sort diagnostics by severity
    virtual_text = {
        spacing = 2,
        source = "if_many",
        prefix = "●",
    },
    float = {
        border = "rounded",
        source = "if_many",
    },
})
