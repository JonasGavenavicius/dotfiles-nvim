# Neovim Configuration

A modern, feature-rich Neovim configuration built with Lua and managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Features

### Core Functionality
- **LSP Support**: Full Language Server Protocol integration with Mason for automatic server management
- **Syntax Highlighting**: Advanced syntax highlighting with Treesitter
- **Auto-completion**: Intelligent code completion with nvim-cmp
- **Debugging**: Built-in debugging support with DAP (Debug Adapter Protocol)
- **Testing**: Integrated test runner with Neotest
- **Code Formatting**: Automatic code formatting with Conform
- **Linting**: Real-time code linting with nvim-lint

### Navigation & File Management
- **File Explorer**: Dual file managers - nvim-tree and oil-nvim
- **Fuzzy Finding**: Fast file and text search capabilities
- **Quick Navigation**: Harpoon for rapid file switching
- **Session Management**: Persistent sessions with automatic restore

### Git Integration
- **Git Signs**: Inline git status indicators
- **Diff View**: Visual git diff and file history
- **Git Linking**: Quick GitHub/GitLab link generation

### UI & Theming
- **Theme Picker**: Interactive theme switcher with 8 variants across 3 color schemes
- **Themes**: Catppuccin (4 variants), Gruvbox, Rose Pine (3 variants)
- **Status Line**: Customized Lualine status bar
- **Icons**: Web-devicons for file type recognition
- **Indentation**: Visual indent guides with mini-indentscope
- **Scrollbar**: Enhanced scrollbar with diagnostic indicators

### Developer Experience
- **AI Assistance**: Avante.nvim with GPT-4o + Claude fallback
- **GitHub Copilot**: AI-powered code completion
- **Which-key**: Interactive keybinding help
- **Auto-pairs**: Automatic bracket/quote pairing
- **Folding**: Intelligent code folding with nvim-ufo
- **Terminal**: Integrated terminal with toggleterm
- **Todo Comments**: Highlight and navigate TODO comments

## Installation

1. Ensure you have Neovim 0.9+ installed
2. Clone this configuration:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```
3. Launch Neovim - plugins will install automatically via lazy.nvim

## Key Mappings

> **Note**: Press `<leader>` (space) to see all available keybindings with descriptions via which-key.

### Essential Mappings
- **Leader key**: `<space>`
- **Window Navigation**: `<C-h/j/k/l>` - Navigate between windows  
- **File Explorer**: `<leader>ee` (Oil) / `<leader>el` (nvim-tree)
- **Find Files**: `<leader>ff` - Fuzzy find files
- **Find Text**: `<leader>fg` - Search in files
- **Format Code**: `grb` - Format current buffer

### Key Groups (via which-key)
- `<leader>a` - **AI/Avante** (Claude/GPT assistance)
- `<leader>d` - **Debug** (DAP debugging controls)
- `<leader>e` - **Explorer** (File managers)
- `<leader>f` - **Find** (File/text search, fuzzy finder)
- `<leader>g` - **Git** (Git operations, diffs, history)
- `<leader>h` - **Harpoon** (File bookmarks)
- `<leader>l` - **LSP/Lint** (Language server, linting)
- `<leader>r` - **Run** (Execute files/commands)
- `<leader>s` - **Search/Replace** (Text replacement, Spectre)
- `<leader>t` - **Test** (Testing framework)
- `<leader>u` - **UI/Theme** (Themes, interface)
- `gr` - **References** (LSP references, definitions)

### Quick Reference
For a complete list of all keybindings, see [KEYBINDINGS.md](KEYBINDINGS.md) or use `<leader>` in Neovim to explore available options interactively.

## Configuration Structure

```
nvim/
├── init.lua                 # Main configuration entry point
├── lazy-lock.json          # Plugin lock file
└── lua/
    ├── autocmds.lua        # Autocommands
    ├── mappings.lua        # Key mappings
    ├── options.lua         # Neovim options
    └── configs/            # Plugin configurations
        ├── themes/         # Color scheme configurations
        │   ├── catppuccin.lua
        │   ├── gruvbox.lua
        │   └── rose-pine.lua
        ├── theme-picker.lua # Theme switching functionality
        ├── avante.lua      # AI assistance (GPT/Claude)
        └── *.lua          # Individual plugin configs
```

## Plugin Manager

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. Plugins are automatically installed on first launch, and the lock file ensures reproducible plugin versions.

## Themes

### Available Themes
- **Catppuccin**: Latte, Frappe, Macchiato, Mocha
- **Gruvbox**: Dark variant
- **Rose Pine**: Main, Moon, Dawn

### Theme Management
- Use `<leader>th` to open the theme picker and select from all available variants
- Use `<leader>tc` to quickly cycle through themes
- Your theme choice is automatically saved and restored on restart
- Theme preferences are stored in `~/.local/share/nvim/theme_preference.lua`

## Customization

### Adding New Plugins
Add plugin configurations to the `configs/` directory and require them in `init.lua`.

### Modifying Key Mappings
Edit `lua/mappings.lua` to customize keybindings.

## Requirements

- Neovim 0.9+
- Git
- A Nerd Font for icons
- Language servers (installed automatically via Mason)
- Optional: ripgrep for better searching
- Optional: GitHub CLI for git linking features

### API Keys (Optional)
For AI assistance features, set these environment variables:
```bash
export OPENAI_API_KEY="your-openai-api-key"       # Primary AI provider
export ANTHROPIC_API_KEY="your-claude-api-key"    # Fallback AI provider
```

## Language Support

This configuration provides excellent support for:
- TypeScript/JavaScript
- Ruby
- Lua
- Python
- Go
- Rust
- And many more via LSP

Language servers and formatters are automatically installed and configured through Mason.