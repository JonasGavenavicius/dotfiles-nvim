# Neovim Keybindings Reference

> **Quick Start**: Press `<leader>` (space) in Neovim to see all available keybindings with descriptions via which-key.

## Leader Key
**Leader key**: `<space>`

---

## 🚀 Essential Mappings

| Key | Action | Description |
|-----|--------|-------------|
| `<space>` | Leader key | Opens which-key menu |
| `<C-h/j/k/l>` | Window navigation | Navigate between windows |
| `<C-d>` | Page down | Half-page down (centered) |
| `<C-u>` | Page up | Half-page up (centered) |
| `n` | Next search | Next search result (centered) |
| `N` | Previous search | Previous search result (centered) |
| `grb` | Format buffer | Format current buffer |

---

## 📁 File Operations (`<leader>f` - Find)

| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>ff` | Find Files | Snacks |
| `<leader>fg` | Grep (Literal) | Snacks |
| `<leader>fr` | Grep (Regex) | Snacks |
| `<leader>fb` | Buffers | Snacks |
| `<leader>fH` | Help Tags | Snacks |
| `<leader>fT` | Todos (via qflist) | Snacks |
| `<leader>fd` | LSP Diagnostics | Snacks |
| `<leader>fh` | Open harpoon picker | Harpoon |

---

## 🗂️ File Explorers (`<leader>e` - Explorer)

| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>ee` | Oil Open parent directory | Oil |
| `-` | Open parent directory | Oil |
| `<leader>el` | Toggle nvim-tree file explorer | nvim-tree |

---

## 🔍 Search & Replace (`<leader>s`)

### Basic Search/Replace
| Key | Action | Mode |
|-----|--------|------|
| `<leader>ss` | Replace in buffer (confirm each) | Normal |
| `<leader>sS` | Replace in buffer (no confirm) | Normal |
| `<leader>sg` | Replace in all args (confirm each) | Normal |
| `<leader>sG` | Replace in all args (no confirm) | Normal |

### Spectre (Advanced Search/Replace)
| Key | Action | Mode |
|-----|--------|------|
| `<leader>sR` | Toggle Spectre | Normal |
| `<leader>sw` | Replace current word/selection | Normal/Visual |
| `<leader>sf` | Replace in file | Normal |

#### Spectre Internal Mappings
| Key | Action | Context |
|-----|--------|---------|
| `dd` | Toggle current item | Spectre buffer |
| `<cr>` | Go to current file | Spectre buffer |
| `<leader>q` | Send all items to quickfix | Spectre buffer |
| `<leader>c` | Input replace command | Spectre buffer |
| `<leader>o` | Show options | Spectre buffer |
| `<leader>rc` | Replace current line | Spectre buffer |
| `<leader>R` | Replace all | Spectre buffer |

---

## 🎯 Navigation & Motion

### Leap (Enhanced Motion)
| Key | Action | Description |
|-----|--------|-------------|
| `s` | Leap forward | 2-character motion forward |
| `S` | Leap backward | 2-character motion backward |
| `gs` | Leap forward to | Leap in current window |

### Visual Mode
| Key | Action | Description |
|-----|--------|-------------|
| `<` | Indent left | Indent left and reselect |
| `>` | Indent right | Indent right and reselect |

---

## 🔖 Harpoon (`<leader>h`)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ha` | Add file | Harpoon add file |
| `<leader>hl` | List files | Harpoon list files |
| `<leader>h1` - `<leader>h8` | Select file 1-8 | Harpoon select files |
| `<leader>hp` | Previous file | Harpoon select prev file |
| `<leader>hn` | Next file | Harpoon select next file |

---

## 🔧 LSP & Code Actions (`<leader>l`, `gr`)

### LSP Actions
| Key | Action | Context |
|-----|--------|---------|
| `<leader>lf` | Copy relative file path to clipboard | Any buffer |
| `<leader>ll` | Trigger linting for current file | Any buffer |
| `ga` | Code Action | Normal/Visual |
| `grl` | Open File Diagnostics (Loclist) | LSP buffer |
| `<leader>rf` | Run current file in terminal | Supported filetypes |

### LSP References (`gr`)
| Key | Action | Plugin |
|-----|--------|--------|
| `grr` | LSP References | Snacks |
| `gri` | LSP Implementations | Snacks |
| `grh` | LSP Document Symbols | Snacks |
| `grdd` | LSP Definitions | Snacks |
| `grdt` | LSP Type Definitions | Snacks |

---

## 🧪 Testing (`<leader>t`)

### General Testing (Neotest)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>tn` | Run nearest test | Run test nearest to cursor |
| `<leader>td` | Run nearest test debug | Debug nearest test |
| `<leader>tf` | Run file tests | Run all tests in file |
| `<leader>ta` | Run test suite | Run all tests |
| `<leader>tl` | Run last test | Run last executed test |
| `<leader>ts` | Stop test | Stop running tests |
| `<leader>to` | Show test output | Show test output panel |
| `<leader>tt` | Toggle test summary | Toggle test summary window |

### Ruby Testing (`<leader>tr`)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>trn` | Run nearest ruby test in terminal | Run RSpec test in terminal |
| `<leader>trk` | Kill all running RSpec tests | Kill all RSpec processes |

---

## 🐛 Debugging (`<leader>d`)

### DAP (Debug Adapter Protocol)
| Key | Action | Description |
|-----|--------|-------------|
| `<F2>` | Step into | DAP step into |
| `<F3>` | Step over | DAP step over |
| `<F4>` | Step out | DAP step out |
| `<F5>` | Continue | DAP continue execution |
| `<F6>` | Terminate | DAP terminate session |
| `<Leader>db` | Toggle breakpoint | Toggle breakpoint at cursor |
| `<Leader>dd` | Conditional breakpoint | Set conditional breakpoint |
| `<Leader>dlr` | Run last | Run last debug session |
| `<Leader>du` | Toggle DAP UI | Toggle debug UI |
| `<Leader>de` | Open DAP REPL | Open debug REPL |
| `<Leader>dlc` | Run to cursor | Run to cursor position |

---

## 🌈 Theme & UI (`<leader>u`)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>uh` | Theme picker | Open interactive theme picker |
| `<leader>uc` | Cycle theme | Cycle through all themes |

### Available Themes
- **Catppuccin**: Latte, Frappe, Macchiato, Mocha
- **Gruvbox**: Dark variant
- **Rose Pine**: Main, Moon, Dawn

### Theme Commands
- `:ThemePicker` - Open theme picker
- `:ThemeCycle` - Cycle to next theme

---

## 🔄 Git Operations (`<leader>g`)

| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>gd` | Git Diffview | Diffview |
| `<leader>gh` | Git File History | Diffview |
| `<leader>gld` | Toggle Word Diff | Gitsigns |
| `<leader>gt` | Git Status | Snacks |
| `<leader>gs` | Git Log | Snacks |
| `<leader>gy` | Copy GitHub link to current line | Gitlinker |
| `<leader>gb` | Open GitHub link in browser | Gitlinker |

---

## ⌨️ Auto-completion (Insert Mode)

### nvim-cmp Mappings
| Key | Action | Context |
|-----|--------|---------|
| `<C-p>` | Select previous item | Completion menu |
| `<C-n>` | Select next item | Completion menu |
| `<C-d>` | Scroll docs up | Completion menu |
| `<C-f>` | Scroll docs down | Completion menu |
| `<C-Space>` | Complete | Insert mode |
| `<C-e>` | Abort completion | Completion menu |
| `<CR>` | Confirm selection | Completion menu |
| `<Tab>` | Next item/expand snippet | Completion/snippet |
| `<S-Tab>` | Previous item/jump back | Completion/snippet |

---

## 🤖 Copilot

| Key | Action | Context |
|-----|--------|---------|
| `<C-a>` | Accept suggestion/panel | Insert mode |
| `<C-j>` | Next suggestion/jump next | Insert/panel mode |
| `<C-k>` | Previous suggestion/jump prev | Insert/panel mode |
| `<C-e>` | Dismiss suggestion | Insert mode |
| `<M-CR>` | Open panel | Insert mode |
| `r` | Refresh panel | Copilot panel |

---

## 📂 Code Folding

| Key | Action | Plugin |
|-----|--------|--------|
| `zR` | Open all folds | nvim-ufo |
| `zM` | Close all folds | nvim-ufo |
| `zK` | Peek Fold | nvim-ufo |

---

## 🔧 Snacks Picker Internal

| Key | Action | Context |
|-----|--------|---------|
| `<C-t>` | Send to qflist | Snacks picker |
| `<C-h>` | Toggle hidden files | Snacks picker |

---

## 📝 Notes

- **Leader key timing**: Default timeout is 400ms (configurable in `options.lua`)
- **Which-key help**: Press `<leader>` and wait to see available options
- **Plugin-specific help**: Many plugins have their own help (`:help plugin-name`)
- **Custom functions**: Some keybindings execute custom Lua functions defined in plugin configs

---

*Last updated: Based on configuration analysis*