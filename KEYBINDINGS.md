# Neovim Keybindings Reference

> **Quick Start**: Press `<leader>` (space) in Neovim to see all available keybindings with descriptions via which-key.

## Leader Key

**Leader key**: `<space>`

---

## 🚀 Essential Mappings

| Key           | Action            | Description                       |
| ------------- | ----------------- | --------------------------------- |
| `<space>`     | Leader key        | Opens which-key menu              |
| `<C-h/j/k/l>` | Window navigation | Navigate between windows          |
| `<C-d>`       | Page down         | Half-page down (centered)         |
| `<C-u>`       | Page up           | Half-page up (centered)           |
| `n`           | Next search       | Next search result (centered)     |
| `N`           | Previous search   | Previous search result (centered) |
| `grb`         | Format buffer     | Format current buffer             |

---

## 📁 File Operations (`<leader>f` - Find)

| Key          | Action              | Plugin  |
| ------------ | ------------------- | ------- |
| `<leader>ff` | Find Files          | Snacks  |
| `<leader>fg` | Grep (Literal)      | Snacks  |
| `<leader>fr` | Grep (Regex)        | Snacks  |
| `<leader>fb` | Buffers             | Snacks  |
| `<leader>fH` | Help Tags           | Snacks  |
| `<leader>ft` | Todos               | Snacks  |
| `<leader>fd` | LSP Diagnostics     | Snacks  |
| `<leader>fh` | Open harpoon picker | Harpoon |

### Local Directory Search (`<leader>fl`)

| Key           | Action                     | Plugin |
| ------------- | -------------------------- | ------ |
| `<leader>flf` | Find Files (Current Dir)   | Snacks |
| `<leader>flg` | Grep Literal (Current Dir) | Snacks |
| `<leader>flr` | Grep Regex (Current Dir)   | Snacks |

---

## 🗂️ File Explorers (`<leader>e` - Explorer)

| Key          | Action                         | Plugin    |
| ------------ | ------------------------------ | --------- |
| `<leader>ee` | Oil Open parent directory      | Oil       |
| `-`          | Open parent directory          | Oil       |
| `<leader>el` | Toggle nvim-tree file explorer | nvim-tree |

---

## 🔍 Search & Replace (`<leader>s`)

### Basic Search/Replace

| Key          | Action                             | Mode   |
| ------------ | ---------------------------------- | ------ |
| `<leader>ss` | Replace in buffer (confirm each)   | Normal |
| `<leader>sS` | Replace in buffer (no confirm)     | Normal |
| `<leader>sg` | Replace in all args (confirm each) | Normal |
| `<leader>sG` | Replace in all args (no confirm)   | Normal |

---

## 🎯 Navigation & Motion

### Leap (Enhanced Motion)

| Key  | Action          | Description                 |
| ---- | --------------- | --------------------------- |
| `s`  | Leap forward    | 2-character motion forward  |
| `S`  | Leap backward   | 2-character motion backward |
| `gs` | Leap forward to | Leap in current window      |

### Visual Mode

| Key | Action       | Description               |
| --- | ------------ | ------------------------- |
| `<` | Indent left  | Indent left and reselect  |
| `>` | Indent right | Indent right and reselect |

---

## 🔖 Harpoon (`<leader>h`)

| Key                         | Action          | Description              |
| --------------------------- | --------------- | ------------------------ |
| `<leader>ha`                | Add file        | Harpoon add file         |
| `<leader>hl`                | List files      | Harpoon list files       |
| `<leader>h1` - `<leader>h8` | Select file 1-8 | Harpoon select files     |
| `<leader>hp`                | Previous file   | Harpoon select prev file |
| `<leader>hn`                | Next file       | Harpoon select next file |

---

## 🔧 LSP & Code Actions (`<leader>l`, `gr`)

### LSP Actions

| Key          | Action                               | Context       |
| ------------ | ------------------------------------ | ------------- |
| `<leader>lf` | Copy relative file path to clipboard | Any buffer    |
| `<leader>ll` | Trigger linting for current file     | Any buffer    |
| `<leader>ls` | Show signature help                  | LSP buffer    |
| `ga`         | Code Action                          | Normal/Visual |
| `grl`        | Open File Diagnostics (Loclist)      | LSP buffer    |

Signature help also appears automatically while typing function or method arguments in LSP-backed languages such as Go and Rust.

## 🚀 Run Commands (`<leader>r`)

| Key          | Action                    | Description                            |
| ------------ | ------------------------- | -------------------------------------- |
| `<leader>rf` | Run current file          | Run current file with default command  |
| `<leader>rc` | Run current file (custom) | Run current file with custom arguments |

### Supported File Types for Run Commands

- **Go**: `go run file.go`
- **Rust**: `cargo run`
- **Ruby**: `bundle exec ruby file.rb`
- **Python**: `python file.py`
- **JavaScript**: `node file.js`
- **TypeScript**: `tsx file.ts`
- **Lua**: `lua file.lua`

### LSP References (`gr`)

| Key    | Action               | Plugin |
| ------ | -------------------- | ------ |
| `grr`  | LSP References       | Snacks |
| `gri`  | LSP Implementations  | Snacks |
| `grh`  | LSP Document Symbols | Snacks |
| `grdd` | LSP Definitions      | Snacks |
| `grdt` | LSP Type Definitions | Snacks |

---

## 🧪 Testing (`<leader>t`)

### General Testing (Neotest)

| Key          | Action                 | Description                |
| ------------ | ---------------------- | -------------------------- |
| `<leader>tn` | Run nearest test       | Run test nearest to cursor |
| `<leader>td` | Run nearest test debug | Debug nearest test         |
| `<leader>tf` | Run file tests         | Run all tests in file      |
| `<leader>ta` | Run test suite         | Run all tests              |
| `<leader>tl` | Run last test          | Run last executed test     |
| `<leader>tk` | Stop test              | Stop running tests         |
| `<leader>to` | Show test output       | Show test output panel     |
| `<leader>tt` | Toggle test summary    | Toggle test summary window |

### Ruby Testing (`<leader>tr`)

| Key           | Action                            | Description                |
| ------------- | --------------------------------- | -------------------------- |
| `<leader>trn` | Run nearest ruby test in terminal | Run RSpec test in terminal |
| `<leader>trk` | Kill all running RSpec tests      | Kill all RSpec processes   |

### Go Testing (`<leader>tg`)

| Key           | Action                          | Description                    |
| ------------- | ------------------------------- | ------------------------------ |
| `<leader>tgn` | Run nearest Go test in terminal | Run nearest Go test            |
| `<leader>tgp` | Run Go package tests            | Run package tests in terminal  |
| `<leader>tgc` | Run Go tests with coverage      | Run coverage workflow          |
| `<leader>tgk` | Kill all running Go tests       | Kill all `go test` processes   |

---

## 🐛 Debugging (`<leader>d`)

### DAP (Debug Adapter Protocol)

| Key           | Action                 | Description                 |
| ------------- | ---------------------- | --------------------------- |
| `<F2>`        | Step into              | DAP step into               |
| `<F3>`        | Step over              | DAP step over               |
| `<F4>`        | Step out               | DAP step out                |
| `<F5>`        | Continue               | DAP continue execution      |
| `<F6>`        | Terminate              | DAP terminate session       |
| `<Leader>db`  | Toggle breakpoint      | Toggle breakpoint at cursor |
| `<Leader>dd`  | Conditional breakpoint | Set conditional breakpoint  |
| `<Leader>dlr` | Run last               | Run last debug session      |
| `<Leader>du`  | Toggle DAP UI          | Toggle debug UI             |
| `<Leader>de`  | Open DAP REPL          | Open debug REPL             |
| `<Leader>dlc` | Run to cursor          | Run to cursor position      |

---

## 🌈 Theme & UI (`<leader>u`)

| Key          | Action              | Description                   |
| ------------ | ------------------- | ----------------------------- |
| `<leader>uf` | Toggle focus mode   | Toggle Twilight focus mode    |
| `<leader>uh` | Theme picker        | Open interactive theme picker |
| `<leader>uc` | Cycle theme         | Cycle through all themes      |
| `<leader>ut` | Toggle transparency | Toggle theme transparency     |

### Minimap (`<leader>um`)

| Key           | Action               | Description                  |
| ------------- | -------------------- | ---------------------------- |
| `<leader>umt` | Toggle minimap       | Show or hide minimap         |
| `<leader>umr` | Refresh minimap      | Refresh minimap content      |
| `<leader>umf` | Toggle minimap focus | Focus or return from minimap |

### Available Themes

- **Catppuccin**: Latte, Frappe, Macchiato, Mocha
- **Gruvbox**: Dark variant
- **Rose Pine**: Main, Moon, Dawn
- **Cyberdream**: Dark variant

### Theme Commands

- `:FocusMode` - Toggle focused editing mode
- `:NvimBootstrap` - Install configured Mason packages and Treesitter parsers
- `:ThemePicker` - Open theme picker
- `:ThemeCycle` - Cycle to next theme
- `:ToggleTransparency` - Toggle theme transparency

---

## 🔄 Git Operations (`<leader>g`)

### Git Navigation & Workflow

| Key           | Action               | Plugin   |
| ------------- | -------------------- | -------- |
| `]h`          | Next git hunk        | Gitsigns |
| `[h`          | Previous git hunk    | Gitsigns |
| `<control> f` | scroll down          | Snacks   |
| `<control> b` | scroll up            | Snacks   |
| `<leader>ghp` | Preview hunk changes | Gitsigns |
| `<leader>ghd` | Diff current buffer  | Gitsigns |
| `<leader>ghq` | Repository hunks     | Gitsigns |
| `ih`          | Select git hunk      | Gitsigns |

### Git Worktrees (`<leader>gw`)

| Key           | Action           | Notes                                            |
| ------------- | ---------------- | ------------------------------------------------ |
| `<leader>gwl` | List/switch      | Shows all worktrees, switches cwd, opens Snacks  |
| `<leader>gwc` | Create worktree  | Prompts for branch, path, and start point        |

### Git Hunk Actions

| Key                    | Action               | Plugin   |
| ---------------------- | -------------------- | -------- |
| `<leader>ghs`          | Stage current hunk   | Gitsigns |
| `<leader>ghr`          | Reset current hunk   | Gitsigns |
| `<leader>ghu`          | Undo stage hunk      | Gitsigns |
| `<leader>ghs` (Visual) | Stage selected lines | Gitsigns |

### Git Buffer Operations

| Key           | Action              | Plugin   |
| ------------- | ------------------- | -------- |
| `<leader>gbs` | Stage entire buffer | Gitsigns |
| `<leader>gbr` | Reset entire buffer | Gitsigns |
| `<leader>gbl` | Toggle line blame   | Gitsigns |

### Git Worktree Commands

- `:GitWorktreeSwitch` - Open the worktree picker and switch the current tab to the selected worktree
- `:GitWorktreeCreate` - Create a new worktree using prompted branch, path, and start point

Switching worktrees is a clean handoff: if any buffer is modified, the switch is blocked until you save or discard those changes.

### Git Views & History

| Key           | Action           | Plugin   |
| ------------- | ---------------- | -------- |
| `<leader>gd`  | Git Diffview     | Diffview |
| `<leader>gD`  | Git Staged Diff  | Diffview |
| `<leader>gm`  | Git Branch Diff  | Diffview |
| `<leader>gq`  | Close Diffview   | Diffview |
| `<leader>gh`  | Git File History | Diffview |
| `<leader>gH`  | Current File History | Diffview |
| `<leader>gwd` | Toggle Word Diff | Gitsigns |
| `<leader>gt`  | Git Status       | Snacks   |
| `<leader>gs`  | Git Log          | Snacks   |

### Merge Conflicts (`<leader>gc`)

| Key           | Action            | Plugin        |
| ------------- | ----------------- | ------------- |
| `]x`          | Next conflict     | git-conflict  |
| `[x`          | Previous conflict | git-conflict  |
| `<leader>gco` | Choose ours       | git-conflict  |
| `<leader>gct` | Choose theirs     | git-conflict  |
| `<leader>gcb` | Choose both       | git-conflict  |
| `<leader>gc0` | Choose none       | git-conflict  |
| `<leader>gcl` | List conflicts    | git-conflict  |

### Fugitive Comparison (`<leader>gv`)

Mirrors the Diffview suffixes so you can compare workflows directly.

| Key           | Action                        | Plugin   |
| ------------- | ----------------------------- | -------- |
| `<leader>gvd` | Fugitive Diff                 | Fugitive |
| `<leader>gvD` | Fugitive Staged Diff          | Fugitive |
| `<leader>gvm` | Fugitive Branch Diff          | Fugitive |
| `<leader>gvq` | Close Fugitive View           | Fugitive |
| `<leader>gvh` | Fugitive Repo History         | Fugitive |
| `<leader>gvH` | Fugitive Current File History | Fugitive |

### Mini Diff Comparison (`<leader>gx`)

`mini.diff` is hunk-focused, not a full diff/history UI. These maps keep it separate from `gitsigns`, `diffview`, and `fugitive`.

| Key           | Action                  | Plugin    |
| ------------- | ----------------------- | --------- |
| `<leader>gxt` | Mini Diff Toggle        | mini.diff |
| `<leader>gxo` | Mini Diff Overlay       | mini.diff |
| `<leader>gxf` | Mini Diff First Hunk    | mini.diff |
| `<leader>gxp` | Mini Diff Previous Hunk | mini.diff |
| `<leader>gxn` | Mini Diff Next Hunk     | mini.diff |
| `<leader>gxl` | Mini Diff Last Hunk     | mini.diff |
| `<leader>gxa` | Mini Diff Apply Hunk    | mini.diff |
| `<leader>gxr` | Mini Diff Reset Hunk    | mini.diff |
| `<leader>gxq` | Mini Diff Current Hunks | mini.diff |
| `<leader>gxQ` | Mini Diff All Hunks     | mini.diff |

### GitHub Integration

| Key           | Action                           | Plugin    |
| ------------- | -------------------------------- | --------- |
| `<leader>gly` | Copy GitHub link to current line | Gitlinker |
| `<leader>glb` | Open GitHub link in browser      | Gitlinker |

---

## ⌨️ Auto-completion (Insert Mode)

### nvim-cmp Mappings

| Key         | Action                                          | Context            |
| ----------- | ----------------------------------------------- | ------------------ |
| `<C-p>`     | Select previous item                            | Completion menu    |
| `<C-n>`     | Select next item                                | Completion menu    |
| `<C-d>`     | Scroll docs up                                  | Completion menu    |
| `<C-f>`     | Scroll docs down                                | Completion menu    |
| `<C-Space>` | Complete                                        | Insert mode        |
| `<C-e>`     | Abort completion                                | Completion menu    |
| `<CR>`      | Confirm selection (only if explicitly selected) | Completion menu    |
| `<Tab>`     | Next item/expand snippet                        | Completion/snippet |
| `<S-Tab>`   | Previous item/jump back                         | Completion/snippet |

---

## 🤖 Copilot Completion

| Key     | Action              | Context     |
| ------- | ------------------- | ----------- |
| `<C-a>` | Accept suggestion   | Insert mode |
| `<C-j>` | Next suggestion     | Insert mode |
| `<C-k>` | Previous suggestion | Insert mode |
| `<C-e>` | Dismiss suggestion  | Insert mode |

---

## 📂 Code Folding

| Key  | Action          | Plugin   |
| ---- | --------------- | -------- |
| `zR` | Open all folds  | nvim-ufo |
| `zM` | Close all folds | nvim-ufo |
| `zK` | Peek Fold       | nvim-ufo |

---

## 🔧 Snacks Picker Internal

| Key     | Action              | Context       |
| ------- | ------------------- | ------------- |
| `<C-t>` | Send to qflist      | Snacks picker |
| `<C-h>` | Toggle hidden files | Snacks picker |

---

## 📝 Notes

- **Leader key timing**: Default timeout is 400ms (configurable in `options.lua`)
- **Which-key help**: Press `<leader>` and wait to see available options
- **Plugin-specific help**: Many plugins have their own help (`:help plugin-name`)
- **Custom functions**: Some keybindings execute custom Lua functions defined in plugin configs

---

_Last updated: Based on configuration analysis_
