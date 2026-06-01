# Neovim Configuration

Go, Rust, and Ruby focused Neovim configuration built with Lua and managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

See [KEYBINDINGS.md](KEYBINDINGS.md) for the full keymap reference.

## Quick Installation

```bash
# Clone the configuration
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim, then run :NvimBootstrap once
nvim
```

## Features

- **LSP**: `gopls`, `rust-analyzer`, `ruby-lsp`, and `lua_ls`
- **Completion**: `blink.cmp`, LuaSnip snippets, optional GitHub Copilot suggestions
- **Debugging**: DAP for Go, Rust, and Ruby
- **Testing**: Neotest plus terminal helpers for Go and RSpec
- **Formatting/Linting**: Conform and nvim-lint for Go, Rust, Ruby, and Lua config work
- **Git**: Gitsigns, Diffview, Gitlinker, git-conflict, and native worktree helpers
- **Files**: Oil as the primary explorer, nvim-tree as an optional sidebar
- **Navigation/UI**: Snacks picker, Harpoon 2, Leap, Trouble, lualine, navic winbar
- **Themes**: Catppuccin, Gruvbox, Rose Pine, Cyberdream with transparency toggle

## System Requirements

- **Neovim**: 0.12 or newer
- **Nerd Font**: Required for icons
- **git**: Required by lazy.nvim and git integrations
- **ripgrep**: Required by Snacks grep pickers
- **curl/wget, unzip, tar, gzip**: Required by Mason package installs
- **Node.js**: Required only for Copilot if you use it

## Language Tools

`:NvimBootstrap` installs the Mason-managed tools declared in `lua/configs/mason.lua` and the Treesitter parsers declared in `lua/configs/treesitter.lua`.

| Language | LSP | Debug | Format | Lint/Test |
| --- | --- | --- | --- | --- |
| Go | `gopls` | `delve` / DAP | `gofumpt`, `goimports` | `golangci-lint`, Neotest, terminal helpers |
| Rust | `rust-analyzer` | `codelldb` / DAP | `rustfmt` via Rustup | `cargo`, `clippy`, Neotest |
| Ruby | `ruby-lsp` | `nvim-dap-ruby` / `rdbg` | `rubocop` | `rubocop`, RSpec, Neotest |
| Lua | `lua_ls` | n/a | `stylua` | n/a |

## Configuration Structure

```text
nvim/
├── init.lua                  # Main entry point
├── lazy-lock.json            # Plugin lockfile
├── KEYBINDINGS.md            # Keymap reference
├── lua/
│   ├── autocmds.lua          # Autocommands
│   ├── mappings.lua          # Global keymaps
│   ├── options.lua           # Neovim settings
│   ├── configs/              # Plugin and language configs
│   └── utils/                # Shared helpers
```

## Essential Commands

- `:Lazy`: open plugin manager
- `:Mason`: open external tool installer
- `:NvimBootstrap`: install configured Mason packages and Treesitter parsers
- `:ConformInfo`: inspect configured formatters
- `:ThemePicker`: select a theme
- `:ThemeCycle`: cycle themes
- `:ToggleTransparency`: toggle theme transparency
- `:GitWorktreeSwitch`: switch worktree in the current tab
- `:GitWorktreeCreate`: create a worktree
- `:Copilot auth`: authenticate Copilot, if enabled

## Notes

- Worktree switching blocks when listed buffers have unsaved changes, then clears project buffers before opening Snacks in the selected worktree.
- LSP diagnostics and nvim-lint diagnostics share the same UI.
- Frontend/TypeScript tooling is intentionally not installed or configured by default.
- If a formatter or debugger is missing, run `:NvimBootstrap`, then check `:Mason` for install status.
