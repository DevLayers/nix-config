# ZSH Configuration with Powerlevel10k

This document describes the ZSH configuration improvements implemented in this repository.

## Overview

The ZSH configuration has been updated to match the setup from [SrwR16/dotfiles](https://github.com/SrwR16/dotfiles), featuring:

- **Powerlevel10k** prompt with instant loading
- **Enhanced autocompletion** with hybrid suggestions (history + filesystem)
- **Better plugin management** with antidote
- **Improved completion system** with fuzzy matching

## Changes Made

### 1. Powerlevel10k Integration

- Added `romkatv/powerlevel10k` plugin for a fast, customizable prompt
- Implemented instant prompt for faster shell startup
- Disabled Starship to avoid conflicts

### 2. Plugin Updates

Added the following plugins to enhance ZSH functionality:

- `romkatv/powerlevel10k` - Fast and customizable prompt
- `MichaelAquilina/zsh-you-should-use` - Reminds you to use aliases

### 3. Enhanced Autocompletion

The autocompletion system now:

- **Shows suggestions from both history and filesystem** - When typing `cd D`, it will suggest from recent directories AND directories starting with 'D' in the current path
- Uses menu-driven completion with arrow key navigation
- Supports case-insensitive and fuzzy matching
- Caches completions for better performance
- Groups and describes completion options

**Key configuration:**
```zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
```
This enables hybrid suggestions that search both command history and filesystem.

### 4. Completion Features

- **Menu selection**: Navigate completions with arrow keys
- **Case-insensitive**: `cd desktop` matches `Desktop`
- **Fuzzy matching**: Smart pattern matching for partial matches
- **Grouped results**: Completions are organized by type
- **Approximate matching**: Tolerates minor typos

## First-Time Setup

After rebuilding your NixOS or nix-darwin configuration:

### 1. Configure Powerlevel10k

On first launch, ZSH will run the Powerlevel10k configuration wizard:

```bash
p10k configure
```

This wizard will:
- Ask about your terminal capabilities
- Let you choose your prompt style
- Create a `~/.config/zsh/.p10k.zsh` configuration file

You can re-run the wizard anytime with the same command.

### 2. Optional: Install Catppuccin Theme for Syntax Highlighting

The configuration supports an optional Catppuccin theme for zsh-syntax-highlighting. To use it:

1. Download the theme file:
   ```bash
   curl -o ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh \
     https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
   ```

2. The theme will be automatically loaded if the file exists

## Usage

### Autocompletion Behavior

**Hybrid Suggestions:**
- Type `cd ` - Shows recent directories from history
- Type `cd D` - Shows directories starting with 'D' from both history AND current path
- Use arrow keys to navigate through suggestions
- Press Tab to accept a suggestion

**Menu Completion:**
- Press Tab to show all possible completions
- Use arrow keys to navigate
- Press Enter to select

**Fuzzy Matching:**
- Partial matches work: `gc` can match `git commit`
- Case doesn't matter: `desktop` matches `Desktop`

### Key Bindings

All existing key bindings are preserved:

- `Ctrl+H` - Delete word backward
- `Ctrl+→` - Move forward one word
- `Ctrl+←` - Move backward one word
- `Ctrl+V` - Edit command in $EDITOR
- (macOS) `Alt+C` - FZF directory navigation

## Performance

The configuration is optimized for performance:

- **Instant prompt**: P10k loads instantly, other plugins load asynchronously
- **Lazy loading**: kubectl completion loads only when needed
- **Completion caching**: Reduces repetitive computation
- **Async suggestions**: Autosuggestions don't block typing

## Troubleshooting

### P10k not showing correctly

Make sure your terminal supports:
- 256 colors or true color
- UTF-8 encoding
- A Nerd Font (recommended: MesloLGS NF)

Run `p10k configure` to reconfigure.

### Completions not working

1. Clear the completion cache:
   ```bash
   rm -rf ~/.cache/zsh/zcompcache
   ```

2. Restart your shell or run:
   ```bash
   exec zsh
   ```

### Suggestions only showing history

Check that zsh-autosuggestions is loaded:
```bash
echo $ZSH_AUTOSUGGEST_STRATEGY
```

Should output: `history completion`

If not, rebuild your configuration:
```bash
# For NixOS
sudo nixos-rebuild switch

# For nix-darwin
darwin-rebuild switch

# For home-manager
home-manager switch
```

## Customization

### Modify P10k Prompt

Edit `~/.config/zsh/.p10k.zsh` or run `p10k configure` to reconfigure.

### Add More Plugins

Edit `modules/home-manager/programs/zsh/default.nix`:

```nix
antidote = {
  enable = true;
  plugins = [
    # ... existing plugins ...
    "your-username/your-plugin"
  ];
};
```

### Customize Completion Colors

Modify the `zstyle` settings in `modules/home-manager/programs/zsh/default.nix`.

## References

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [SrwR16/dotfiles](https://github.com/SrwR16/dotfiles)
- [Antidote Plugin Manager](https://getantidote.github.io/)
