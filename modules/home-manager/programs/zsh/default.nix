{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # XDG compliance: Move zsh config to ~/.config/zsh
    dotDir = "${config.xdg.configHome}/zsh";
    
    # Antidote plugin manager for better async/deferred loading
    antidote = {
      enable = true;
      plugins = [
        # ZSH utility plugins
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-history-substring-search"
        # Extra plugins
        # Note: zsh-you-should-use removed due to compatibility issues with antidote
        # The plugin has a non-standard structure that causes loading errors
        "nix-community/nix-zsh-completions"
        "z-shell/zsh-eza"
      ];
      useFriendlyNames = true;
    };

    shellAliases = {
      ff = "fastfetch";
      open = "xdg-open";

      # git
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";

      # kubectl
      k = "kubectl";
      kctx = "kubectx";
      kgno = "kubectl get node";
      kdno = "kubectl describe node";
      kgp = "kubectl get pods";
      kep = "kubectl edit pods";
      kdp = "kubectl describe pods";
      kdelp = "kubectl delete pods";
      kgs = "kubectl get svc";
      kes = "kubectl edit svc";
      kds = "kubectl describe svc";
      kdels = "kubectl delete svc";
      kgi = "kubectl get ingress";
      kei = "kubectl edit ingress";
      kdi = "kubectl describe ingress";
      kdeli = "kubectl delete ingress";
      kgns = "kubectl get namespaces";
      kens = "kubectl edit namespace";
      kdns = "kubectl describe namespace";
      kdelns = "kubectl delete namespace";
      kgd = "kubectl get deployment";
      ked = "kubectl edit deployment";
      kdd = "kubectl describe deployment";
      kdeld = "kubectl delete deployment";
      kgsec = "kubectl get secret";
      kdsec = "kubectl describe secret";
      kdelsec = "kubectl delete secret";

      lg = "lazygit";

      pt = "podman-tui";

      repo = "cd $HOME/Documents/repositories";
      temp = "cd $HOME/Downloads/temp";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree
    };
    
    initContent = ''
      # ZSH Autosuggestions configuration for gray suggestions while typing
      # Strategies: history (from command history) + completion (includes folder/file paths)
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      ZSH_AUTOSUGGEST_USE_ASYNC=1
      ZSH_AUTOSUGGEST_MANUAL_REBIND=1
      
      # Enable fuzzy matching and case-insensitive completion for better suggestions
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      
      # Configure completion menu and tag ordering to prioritize directory suggestions
      zstyle ':completion:*' menu select
      zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
      zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
      zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
      zstyle ':completion:*' group-name ''
      zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
      
      # Atuin shell history integration (if available)
      if command -v atuin &> /dev/null; then
        eval "$(atuin init zsh)"
      fi

      # Homebrew integration for macOS
      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        if [[ -f /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      ''}

      # Lazy-load kubectl completion for better startup performance
      # Only loads when kubectl is first used
      kubectl() {
        unfunction kubectl
        source <(command kubectl completion zsh)
        kubectl "$@"
      }

      # bindings
      bindkey -e
      bindkey '^H' backward-delete-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # open commands in $EDITOR with C-v
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^v" edit-command-line

      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        # Enable ALT-C fzf keybinding on Mac
        bindkey 'ć' fzf-cd-widget
      ''}
    '';
  };
}
