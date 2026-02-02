# Nano - Fallback text editor configuration
{
  programs.nano = {
    enable = true;
    syntaxHighlight = true;
    nanorc = ''
      ## Auto-indentation
      set autoindent

      ## Display cursor position constantly
      set const

      ## Enable history for search/replace strings
      set historylog

      ## Enable mouse support
      set mouse

      ## Ctrl+Right moves to word ends instead of word starts
      set afterends

      ## Recognize '_' as part of a word
      set wordchars "_"

      ## Delete selected text as a whole
      set zap

      ## Multiple file buffers
      set multibuffer

      ## Extended regex searches by default
      set regexp

      ## Smart Home key behavior
      set smarthome

      ## Smooth scrolling
      set smooth

      ## Allow suspension
      set suspend

      ## Tab settings
      set tabsize 4
      set tabstospaces

      ## Side-bar for position indicator
      set indicator

      ## Key bindings (modern shortcuts)
      bind M-R  redo            main
      bind ^C   copy            main
      bind ^X   cut             main
      bind ^V   paste           main
      bind ^K   zap             main
      bind ^H   chopwordleft    all
      bind ^Q   exit            all
      bind ^Z   suspend         main
      bind M-/  comment         main
      bind ^Space complete      main

      bind M-C  location        main
      bind ^E   wherewas        all
      bind M-E  findprevious    all
      bind ^R   replace         main
      bind ^B   pageup          all
      bind ^F   pagedown        all
      bind ^G   firstline       all
      bind M-G  lastline        all

      bind M-1    help          all
      bind Sh-M-C constantshow  main
      bind Sh-M-F formatter     main
      bind Sh-M-B linter        main

      ## INI file syntax highlighting
      syntax "ini" "\.ini(\.old|~)?$"
      color brightred "=.*$"
      color green "="
      color brightblue "-?[0-9\.]+\s*($|;)"
      color brightmagenta "ON|OFF|On|Off|on|off\s*($|;)"
      color brightcyan "^\s*\[.*\]"
      color cyan "^\s*[a-zA-Z0-9_\.]+"
      color brightyellow ";.*$"
    '';
  };
}
