# Neovim Configuration

A modern, feature-rich Neovim configuration built with Lua and managed by [lazy.nvim](https://github.com/folke/lazy.nvim). This configuration provides a comprehensive development environment with 43 plugins supporting multiple languages, AI assistance, robust testing, and extensive customization.

## Quick Installation

```bash
# Clone the configuration
git clone <your-repo-url> ~/.config/nvim

# Launch Neovim - plugins will install automatically
nvim
```

> **Keymaps**: See [KEYBINDINGS.md](KEYBINDINGS.md) for complete keymap reference.

## Key Features

- **LSP Support**: Full Language Server Protocol integration with Mason
- **AI Assistance**: GitHub Copilot + Avante.nvim (GPT-4o/Claude)
- **Debugging**: DAP integration for Go, Rust, Ruby
- **Testing**: Neotest framework for Jest, RSpec, Go, Rust
- **Git Integration**: Gitsigns, Diffview, Gitlinker
- **Code Quality**: Formatting (Conform), Linting (nvim-lint)
- **Themes**: 3 themes with 8 variants + transparency toggle
- **File Management**: nvim-tree + Oil.nvim
- **Enhanced Navigation**: Harpoon 2, Leap motion, Snacks picker
- **Smart Completion**: nvim-cmp with multiple sources and snippets

## System Requirements

- **Neovim**: ≥ 0.11.0 (uses modern LSP features)
- **Nerd Font**: For proper icon display

## External Dependencies

### Essential Tools
- **git**: Version control (gitsigns, diffview, gitlinker)
- **curl/wget**: Package downloads (Mason)
- **unzip, tar, gzip**: Archive extraction (Mason)
- **ripgrep**: Fast searching (Snacks picker, Spectre)
- **sed**: Text processing (Spectre)
- **make**: Building native extensions (Avante.nvim)
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

#### Lua
- `stylua`: Formatter (Conform)

### AI Services
- **GitHub Copilot**: Subscription + `:Copilot auth` (Copilot)
- **OpenAI API**: `OPENAI_API_KEY` env var (Avante.nvim)
- **Anthropic API**: `ANTHROPIC_API_KEY` env var (Avante.nvim fallback)

## Language Support Matrix

| Language | LSP | Debug | Format | Lint | Test |
|----------|-----|-------|--------|------|------|
| **Go** | ✅ gopls | ✅ DAP | ✅ gofumpt | ✅ | ✅ Neotest |
| **Rust** | ✅ rust-analyzer | ✅ codelldb | ✅ rustfmt | ✅ | ✅ Neotest |
| **Ruby** | ✅ ruby-lsp | ✅ readapt | ✅ | ✅ | ✅ RSpec |
| **JavaScript/TS** | ✅ | ❌ | ✅ prettier | ✅ eslint_d | ✅ Jest |
| **Python** | ✅ | ❌ | ✅ black/isort | ✅ | ❌ |
| **Lua** | ✅ lua_ls | ❌ | ✅ stylua | ✅ | ❌ |

### LSP Configuration Details

The configuration provides comprehensive LSP support with these key features:

- **Automatic Server Installation**: Mason auto-installs and manages language servers
- **Enhanced Capabilities**: nvim-cmp integration for better completions
- **Custom Keymaps**: `ga` for code actions, `grl` for diagnostics
- **Language-Specific Setup**: 
  - **Go**: Full LSP with gopls, custom run commands
  - **Rust**: rust-analyzer with enhanced settings
  - **Ruby**: ruby-lsp integration with Rails support

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

### AI Setup
```bash
# Set API keys
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"

# Authenticate Copilot
:Copilot auth
```

### Theme Management  
- `:ThemePicker`: Interactive theme selection
- `:ToggleTransparency`: Toggle transparency

## Troubleshooting

**LSP not working**: Run `:Mason` and install missing language servers
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

This configuration provides a complete, modern development environment optimized for multi-language programming with comprehensive tooling, AI assistance, and beautiful themes.