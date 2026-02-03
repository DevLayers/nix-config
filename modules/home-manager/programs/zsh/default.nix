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
    dotDir = ".config/zsh";
    
    # Antidote plugin manager for better async/deferred loading
    antidote = {
      enable = true;
      plugins = [
        # ZSH utility plugins
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-history-substring-search"
        # ZSH prompt
        "romkatv/powerlevel10k"
        # Extra plugins
        "MichaelAquilina/zsh-you-should-use"
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
    
    initExtra = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Atuin shell history integration (if available)
      if command -v atuin &> /dev/null; then
        eval "$(atuin init zsh)"
      fi

      # Catppuccin theme for zsh-syntax-highlighting
      if [[ -f ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ]]; then
        source ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
      fi

      # Powerlevel10k configuration
      if [[ -f ~/.config/zsh/.p10k.zsh ]]; then
        source ~/.config/zsh/.p10k.zsh
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
