# ZSH Performance Optimization Recommendations

## Quick Wins (Immediate Performance Improvements)

### 1. Switch from `initContent` to `initExtra`

**Why:** The reference repository uses `initExtra`, which runs AFTER plugins are loaded. The current repo uses `initContent`, which has different timing semantics in home-manager's zsh module.

**Current:**
```nix
initContent = ''
  # code here
'';
```

**Should be:**
```nix
initExtra = ''
  # code here
'';
```

### 2. Simplify Autosuggestion Strategy (MAJOR IMPACT)

**Why:** Dual-source suggestions (`history completion`) are significantly slower than history-only suggestions. Each keystroke triggers both history search AND filesystem completion, causing lag.

**Current:**
```zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
```

**Recommended (Option 1 - Fastest):**
```zsh
# Remove configuration entirely to use faster defaults
# (defaults to history-only strategy)
```

**Recommended (Option 2 - Keep async optimizations):**
```zsh
# Keep async and manual rebind but use history-only
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Remove the STRATEGY line entirely or set to:
# ZSH_AUTOSUGGEST_STRATEGY=(history)
```

### 3. Remove or Minimize Completion System Configuration

**Why:** 40+ lines of zstyle configuration runs on every shell startup. The reference repo has ZERO completion configuration and feels faster.

**Current (lines 122-156):**
```zsh
# Improved zsh completion system
# Enable menu-driven completion with arrow key navigation
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# ... 30+ more lines ...
```

**Recommended (Minimal):**
```zsh
# Essential completion settings only
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
```

**Or even simpler (Recommended):**
```zsh
# Remove all zstyle configuration and use defaults
```

## Medium Priority Optimizations

### 4. Verify P10k Instant Prompt Setup

**Why:** Instant prompt is configured but may not be working correctly. If it's not working, the shell feels slow even though it loads asynchronously.

**Action Items:**
- Verify `~/.cache/p10k-instant-prompt-${USER}.zsh` exists after first run
- Ensure instant prompt code is at the VERY TOP of initialization
- Test with: `p10k-instant-prompt-test` (if available)

**If instant prompt isn't working, consider:**
```bash
# Run p10k configure to regenerate instant prompt
p10k configure
```

### 5. Simplify Atuin Integration

**Current:**
```zsh
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi
```

**Reference:**
```zsh
eval "$(atuin init zsh)"
```

**Recommendation:**
If atuin is always installed via Nix, remove the conditional:
```zsh
eval "$(atuin init zsh)"
```

If it's optional, the current approach is fine but adds minimal overhead.

### 6. Consider Disabling Features You Don't Use

**Review these lines and remove if not needed:**

```zsh
# If you don't use approximate completions, remove:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# If you don't need grouped/formatted completions, remove:
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
# ... etc
```

## Low Priority / Advanced Optimizations

### 7. Consider Switching to Starship (Alternative Approach)

**Why:** If P10k instant prompt continues to cause issues, Starship is a simpler, faster alternative.

**Current State:**
- Starship is disabled (`enable = false`)
- Powerlevel10k is active

**To switch:**
```nix
# In modules/home-manager/programs/starship/default.nix
programs.starship = {
  enable = true;  # Change from false
  enableZshIntegration = true;
  # ... rest of config
};

# In modules/home-manager/programs/zsh/default.nix
antidote = {
  plugins = [
    # Remove this line:
    # "romkatv/powerlevel10k"
    # ... keep other plugins
  ];
};
```

### 8. Add Missing Reference Plugin (Optional)

The reference repo includes an additional plugin:

```nix
antidote = {
  plugins = [
    # ... existing plugins ...
    "MichaelAquilina/zsh-you-should-use"  # Add this
  ];
};
```

**Note:** This adds functionality (tells you when you should use an alias) but won't improve performance.

## Testing Your Changes

After making changes, measure the impact:

```bash
# Baseline test (run 10 times)
for i in {1..10}; do /usr/bin/time -f "%E" zsh -i -c exit 2>&1; done | awk '{sum+=$1; count+=1} END {print "Average:", sum/count, "seconds"}'

# Test instant prompt
ls -la ~/.cache/p10k-instant-prompt-*

# Check what's actually slow
zsh -xv 2>&1 | ts -i '%.s' | head -100

# Or use zsh profiling
time ZSH_PROF= zsh -i -c exit
```

## Implementation Priority

**Do these in order for maximum impact:**

1. ✅ **Switch `initContent` → `initExtra`** (5 minutes, high impact)
2. ✅ **Remove or simplify autosuggestion strategy** (2 minutes, VERY high impact)
3. ✅ **Minimize completion configuration** (10 minutes, high impact)
4. ⚠️ **Verify P10k instant prompt** (15 minutes, high impact if broken)
5. 📝 **Document actual performance before/after** (5 minutes)

## Expected Results

After implementing recommendations 1-3:

- **Startup time:** Should decrease by 200-500ms
- **Typing responsiveness:** Significantly improved due to history-only suggestions
- **Tab completion:** Slightly slower initial completion but faster overall shell

## Comparison with Reference

| Aspect | Current | Reference | Recommendation |
|--------|---------|-----------|----------------|
| Init method | `initContent` | `initExtra` | Use `initExtra` |
| Autosuggest strategy | history+completion | default (history) | Use history only |
| Completion config | ~40 lines | 0 lines | Minimal (<5 lines) |
| P10k instant prompt | Yes | No | Keep but verify it works |
| kubectl loading | Lazy (good) | Immediate | Keep current |
| Atuin check | Conditional | Unconditional | Keep current |

## Notes

- The reference config is faster because it's SIMPLER, not more optimized
- Your current config has better practices (lazy kubectl, conditional atuin)
- The slowness comes from feature-richness, not poor optimization
- Simplifying to match reference will improve speed
- Consider whether you actually use the advanced completion features

## Rollback Plan

If changes make things worse:

```bash
# Restore from git
git checkout modules/home-manager/programs/zsh/default.nix

# Rebuild
home-manager switch --flake .#your-config
```
