# Neovim Keybindings Reference

Press `<leader>` (space) in Neovim to see available mappings through which-key.

## Essential

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | Move between windows |
| `<C-d>` / `<C-u>` | Half-page down/up and recenter |
| `n` / `N` | Next/previous search result and recenter |
| `<` / `>` in visual mode | Indent and reselect |
| `<leader>?` | Show buffer-local keymaps |

## Find And Files

| Key | Action | Plugin |
| --- | --- | --- |
| `<leader>ff` | Find files | Snacks |
| `<leader>fg` | Grep literal text | Snacks |
| `<leader>fr` | Grep regex | Snacks |
| `<leader>fb` | Buffers | Snacks |
| `<leader>fH` | Help tags | Snacks |
| `<leader>ft` | Todos | Snacks |
| `<leader>fd` | Diagnostics | Snacks |
| `<leader>fh` | Harpoon picker | Harpoon/Snacks |
| `<leader>flf` | Find files in current directory | Snacks |
| `<leader>flg` | Grep literal text in current directory | Snacks |
| `<leader>flr` | Grep regex in current directory | Snacks |

## Explorers

| Key | Action | Plugin |
| --- | --- | --- |
| `-` | Open parent directory in floating Oil | Oil |
| `<leader>ee` | Open parent directory in floating Oil | Oil |
| `<leader>el` | Toggle project sidebar | nvim-tree |

## Search And Replace

| Key | Action |
| --- | --- |
| `<leader>ss` | Replace in current buffer, confirm each |
| `<leader>sS` | Replace in current buffer, no confirmation |
| `<leader>sg` | Replace across quickfix files, confirm each |
| `<leader>sG` | Replace across quickfix files, no confirmation |

## Movement And Navigation

| Key | Action | Plugin |
| --- | --- | --- |
| `s` | Leap forward | Leap |
| `S` | Leap backward | Leap |
| `gs` | Leap in current window | Leap |
| `]]` | Next reference under cursor | Illuminate |
| `[[` | Previous reference under cursor | Illuminate |

## Harpoon

| Key | Action |
| --- | --- |
| `<leader>ha` | Add current file |
| `<leader>hl` | List files |
| `<leader>h1` through `<leader>h8` | Select Harpoon item |
| `<leader>hp` | Previous Harpoon item |
| `<leader>hn` | Next Harpoon item |

## LSP And Diagnostics

| Key | Action |
| --- | --- |
| `ga` | Code action |
| `grb` | Format current buffer |
| `grl` | Open file diagnostics in location list |
| `<leader>lf` | Copy relative file path |
| `<leader>ll` | Trigger linting for current file |
| `<leader>ls` | Signature help |
| `grr` | LSP references |
| `gri` | LSP implementations |
| `grh` | LSP document symbols |
| `grdd` | LSP definitions |
| `grdt` | LSP type definitions |

## Run And Services

| Key | Action |
| --- | --- |
| `<leader>rf` | Run current file |
| `<leader>rc` | Run current file with custom command |
| `<leader>rp` | Run project with language-aware picker |
| `<leader>ra` | Run project with arguments |
| `<leader>rb` | Build project |
| `<leader>rd` | Debug Go project with executable picker |
| `<leader>rm` | Launch multiple Go services |
| `<leader>rs` | Start one Go service |
| `<leader>rk` | Stop one managed service |
| `<leader>rr` | Restart one managed service |
| `<leader>rK` | Stop all managed services |
| `<leader>rl` | List managed services |

Supported simple run filetypes: Go, Rust, Ruby, and Lua.

## Testing

| Key | Action | Plugin |
| --- | --- | --- |
| `<leader>tn` | Run nearest test | Neotest |
| `<leader>td` | Debug nearest test | Neotest/DAP |
| `<leader>tf` | Run file tests | Neotest |
| `<leader>ta` | Run test suite | Neotest |
| `<leader>tl` | Run last test | Neotest |
| `<leader>tk` | Stop test | Neotest |
| `<leader>to` | Show test output | Neotest |
| `<leader>tt` | Toggle test summary | Neotest |
| `<leader>tgn` | Run nearest Go test in terminal | ToggleTerm |
| `<leader>tgp` | Run Go package tests in terminal | ToggleTerm |
| `<leader>tgc` | Run Go tests with coverage | ToggleTerm |
| `<leader>tgk` | Stop Go test terminal | ToggleTerm |
| `<leader>trn` | Run nearest Ruby spec in terminal | ToggleTerm |
| `<leader>trk` | Stop RSpec terminal | ToggleTerm |

## Debugging

| Key | Action |
| --- | --- |
| `<F2>` | Step into |
| `<F3>` | Step over |
| `<F4>` | Step out |
| `<F5>` | Continue or quick-start Go debug |
| `<F6>` | Terminate |
| `<leader>db` | Toggle breakpoint |
| `<leader>dd` | Conditional breakpoint |
| `<leader>dlr` | Run last debug session |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Open DAP REPL |
| `<leader>dlc` | Run to cursor |

## Git

| Key | Action | Plugin |
| --- | --- | --- |
| `]h` / `[h` | Next/previous hunk | Gitsigns |
| `<leader>ghp` | Preview hunk | Gitsigns |
| `<leader>ghd` | Diff current buffer | Gitsigns |
| `<leader>ghq` | Repository hunks to quickfix | Gitsigns |
| `<leader>ghs` | Stage hunk | Gitsigns |
| `<leader>ghr` | Reset hunk | Gitsigns |
| `<leader>ghu` | Undo stage hunk | Gitsigns |
| `<leader>gbs` | Stage buffer | Gitsigns |
| `<leader>gbr` | Reset buffer | Gitsigns |
| `<leader>gbl` | Toggle line blame | Gitsigns |
| `<leader>gwd` | Toggle word diff | Gitsigns |
| `ih` | Select git hunk | Gitsigns |
| `<leader>gt` | Git status | Snacks |
| `<leader>gs` | Git log | Snacks |
| `<leader>gd` | Open Diffview | Diffview |
| `<leader>gD` | Open staged Diffview | Diffview |
| `<leader>gm` | Diff against default branch | Diffview |
| `<leader>gq` | Close Diffview | Diffview |
| `<leader>gh` | Repository file history | Diffview |
| `<leader>gH` | Current file history | Diffview |
| `<leader>gly` | Copy GitHub link | Gitlinker |
| `<leader>glb` | Open GitHub link | Gitlinker |

### Worktrees

| Key | Action |
| --- | --- |
| `<leader>gwl` | List and switch worktrees |
| `<leader>gwc` | Create worktree |
| `:GitWorktreeSwitch` | Open worktree switcher |
| `:GitWorktreeCreate` | Open worktree creation flow |

### Merge Conflicts

| Key | Action |
| --- | --- |
| `]x` / `[x` | Next/previous conflict |
| `<leader>gco` | Choose ours |
| `<leader>gct` | Choose theirs |
| `<leader>gcb` | Choose both |
| `<leader>gc0` | Choose none |
| `<leader>gcl` | List conflicts |

## Trouble

| Key | Action |
| --- | --- |
| `<leader>xx` | Toggle workspace diagnostics |
| `<leader>xb` | Toggle buffer diagnostics |
| `<leader>xe` | Toggle errors only |
| `<leader>xq` | Toggle quickfix list |
| `<leader>xl` | Toggle location list |

## UI And Themes

| Key | Action |
| --- | --- |
| `<leader>uf` | Toggle focus mode |
| `<leader>uh` | Theme picker |
| `<leader>uc` | Cycle theme |
| `<leader>ut` | Toggle transparency |

Themes: Catppuccin Latte/Frappe/Macchiato/Mocha, Gruvbox, Rose Pine Main/Moon/Dawn, Cyberdream.

## Completion

| Key | Action |
| --- | --- |
| `<C-p>` / `<C-n>` | Previous/next completion item |
| `<C-d>` / `<C-f>` | Scroll completion docs |
| `<C-Space>` | Trigger completion or documentation |
| `<C-e>` | Hide completion menu |
| `<CR>` | Confirm explicitly selected item |
| `<Tab>` / `<S-Tab>` | Next/previous completion item or snippet jump |
| `<C-a>` | Accept Copilot suggestion |
| `<C-j>` / `<C-k>` | Next/previous Copilot suggestion |

## Folding And Pickers

| Key | Action |
| --- | --- |
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zK` | Peek fold or hover |
| `<C-t>` in Snacks picker | Send picker results to quickfix |
| `<C-h>` in Snacks picker | Toggle hidden files |
