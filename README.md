# Neovim Configuration

Neovim configuration with 40+ plugins. Built with Lua and managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Quick Installation

```bash
# Clone the configuration
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim, then run :NvimBootstrap once to install tools/parsers
nvim
```

> **Keymaps**: See [KEYBINDINGS.md](KEYBINDINGS.md) for complete keymap reference.

## Features

- **LSP**: Language servers via Mason
- **Completion**: nvim-cmp + GitHub Copilot suggestions
- **Debug**: DAP for Go, Rust, Ruby
- **Testing**: Neotest (Jest, RSpec, Go, Rust)
- **Git**: Gitsigns, Diffview, Gitlinker, native worktree management
- **Formatting/Linting**: Conform + nvim-lint
- **Themes**: 3 themes, 8 variants, transparency toggle
- **Files**: nvim-tree + Oil.nvim
- **Navigation**: Harpoon 2, Leap, Snacks picker

## System Requirements

- **Neovim**: ≥ 0.12.0
- **Nerd Font**: For proper icon display

## External Dependencies

### Essential Tools
- **git**: Version control (gitsigns, diffview, gitlinker)
- **curl/wget**: Package downloads (Mason)
- **unzip, tar, gzip**: Archive extraction (Mason)
- **ripgrep**: Fast searching (Snacks picker)
- **Node.js**: JavaScript ecosystem tools (various formatters/linters)

### Language-Specific Tools

#### Go Development
- `gopls`: LSP server (Mason/LSP Config)
- `gofumpt`, `goimports`, `goimports-reviser`: Formatters (Conform)

#### Rust Development  
- `rust-analyzer`: LSP server (Mason/LSP Config)
- `codelldb`: Debugger (Mason/DAP)

#### Ruby Development
- `ruby-lsp`: LSP server (Mason/LSP Config) 
- `readapt`: Debugger (DAP)
- `bundle`, `rspec`: Testing (Neotest)

#### JavaScript/TypeScript
- `prettier`: Formatter (Conform)
- `eslint_d`: Fast linter (nvim-lint)
- `jest`: Testing (Neotest)

#### Python
- `black`, `isort`: Formatters (Conform)

### Optional AI Completion
- **GitHub Copilot**: Subscription + `:Copilot auth`

## Language Support Matrix

| Language | LSP | Debug | Format | Lint | Test |
|----------|-----|-------|--------|------|------|
| **Go** | ✅ gopls | ✅ DAP | ✅ gofumpt | ✅ golangci_lint | ✅ Neotest + terminal |
| **Rust** | ✅ rust-analyzer | ✅ codelldb | ✅ rustfmt | ✅ | ✅ Neotest |
| **Ruby** | ✅ ruby-lsp | ✅ readapt | ✅ rubocop | ✅ rubocop | ✅ RSpec |
| **JavaScript/TS** | ✅ | ❌ | ✅ prettier | ✅ eslint_d | ✅ Jest |
| **Python** | ✅ | ❌ | ✅ black/isort | ❌ | ❌ |
| **Lua** | ✅ lua_ls | ❌ | ❌ | ❌ | ❌ |

### LSP Setup

- Mason is configured for explicit installs via `:NvimBootstrap` or `:Mason`
- nvim-cmp integration
- Keymaps: `ga` (code actions), `grl` (diagnostics)
- Language-specific configs for Go, Rust, Ruby

## Configuration Structure

```
nvim/
├── init.lua                    # Main entry point
├── lazy-lock.json             # Plugin versions lock
├── KEYBINDINGS.md             # Complete keymap reference
├── lua/
│   ├── autocmds.lua           # Auto commands
│   ├── mappings.lua           # Global keymaps
│   ├── options.lua            # Neovim settings
│   └── configs/               # Plugin configurations
│       ├── themes/            # Color schemes
│       ├── theme-picker.lua   # Custom theme manager
│       └── *.lua             # Individual plugin configs
```

## Essential Commands

### Package Management
- `:Lazy`: Open plugin manager
- `:Mason`: Open LSP/tool installer
- `:NvimBootstrap`: Install configured Mason packages and Treesitter parsers

### Copilot Setup
```bash
:Copilot auth
```

### Theme Management
- `:ThemePicker`: Interactive theme selection
- `:ToggleTransparency`: Toggle transparency

### Git Worktrees
- `<leader>gwl`: List available worktrees and switch the current tab to the selected one
- `<leader>gwc`: Create a new worktree by prompting for branch, path, and start point
- `:GitWorktreeSwitch`: Open the worktree switcher
- `:GitWorktreeCreate`: Open the worktree creation flow

Worktree switching is intentionally safe: Neovim blocks the switch if any listed buffer has unsaved changes, and a successful switch clears the current project buffers before opening a Snacks file picker rooted at the target worktree.

### Formatting & Linting

**Conform (Formatting)**
- **Automatic**: Runs on every file save
- **Manual**: `grb` in normal mode to format current buffer
- **Command**: `:ConformInfo` to show configured formatters

**nvim-lint (Linting)**
- **Automatic**: Runs on file open, save, and leaving insert mode
- **Manual**: `<leader>ll` to trigger linting for current file
- **Command**: `:lua require("lint").try_lint()` to manually lint

**Diagnostics sources**: LSP (always active) + nvim-lint (on triggers) appear in the same UI (gutter signs, virtual text, `:lua vim.diagnostic.open_float()`)

## Troubleshooting

**LSP not working**: Run `:NvimBootstrap` or install missing tools via `:Mason`
**Formatters not found**: Install external tools (prettier, stylua, etc.)
**Tests not detected**: Ensure test frameworks available in project  
**Icons missing**: Install a Nerd Font in terminal
**Performance issues**: Use `:Lazy profile` to check load times

## Customization

- **Keymaps**: Edit `lua/mappings.lua` or plugin-specific configs
- **Themes**: Add to `lua/configs/themes/` and update theme picker
- **Plugins**: Each has dedicated config in `lua/configs/`
- **LSP**: Modify `lua/configs/lspconfig.lua` for language-specific settings

---
