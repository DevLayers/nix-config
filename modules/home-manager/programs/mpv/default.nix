{ pkgs, lib, config, ... }:

let
  shaderDir = "${config.xdg.configHome}/mpv/shaders";
  mpvScripts = if lib.hasAttr "mpvScripts" pkgs then pkgs.mpvScripts else {};
in
{
  programs.mpv = {
    enable = true;

    config = {
      vo = "gpu-next";
      "gpu-api" = "auto";
      hwdec = "auto-safe";
      ao = "pulse";

      "video-sync" = "audio";
      interpolation = false;
      tscale = "oversample";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      "sigmoid-upscaling" = true;
      deband = true;
      "deband-iterations" = 2;
      "deband-threshold" = 32;
      "deband-range" = 16;
      cache = true;
      "demuxer-max-bytes" = "512MiB";
      "demuxer-max-back-bytes" = "256MiB";

      # BT.2390 HDR + ACES-like filmic intent
      "hdr-compute-peak" = true;
      "hdr-peak-percentile" = 99.995;
      "hdr-contrast-recovery" = 0.10;
      "tone-mapping" = "bt.2390";
      "tone-mapping-param" = 1.25;
      "target-colorspace-hint" = true;
      "gamut-mapping-mode" = "perceptual";
      "target-peak" = "auto";

      "ytdl-format" = "bestvideo[height<=2160]+bestaudio/best";
      "ytdl-raw-options" = "yes-playlist=yes,format-sort=res";

      osc = false;
      "osd-bar" = false;

      "save-position-on-quit" = true;
      "keep-open" = true;
      "slang" = "eng,en";
      "alang" = "jpn,jp,eng,en";
      "sub-auto" = "fuzzy";
    };

    bindings = {
      UP = "add volume 5";
      DOWN = "add volume -5";
      RIGHT = "seek 5";
      LEFT = "seek -5";
      SPACE = "cycle pause";
      F = "cycle fullscreen";
      "." = "frame-step";
      "," = "frame-back-step";
      "Shift+S" = "screenshot";
      W = "cycle sub";
      "]" = "add speed 0.1";
      "[" = "add speed -0.1";
      I = "cycle interpolation";

      # Menu & Utility Shortcuts
      O = "script-binding uosc/open-file";
      Y = "script-binding uosc_youtube_search/open-menu";
      H = "script-binding memo-history";
      K = "script-binding uosc/keybinds";
      V = "script-binding uosc_video_settings/open-menu";
      A = "script-binding uosc/audio-device";
      S = "script-binding uosc_subtitle_settings/open-menu";
      P = "script-binding uosc_screenshot/open-menu";

      "Ctrl+f" = "script-binding quality_menu/video_formats_toggle";
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";

      N = "change-list glsl-shaders toggle ${shaderDir}/Anime4K_Restore_CNN.glsl";
      R = "change-list glsl-shaders clear";

      "Ctrl+UP" = "add video-zoom 0.2";
      "Ctrl+DOWN" = "add video-zoom -0.2";
      "Alt+LEFT" = "add video-pan-x -0.05";
      "Alt+RIGHT" = "add video-pan-x 0.05";
      "Alt+UP" = "add video-pan-y -0.05";
      "Alt+DOWN" = "add video-pan-y 0.05";
      "Shift+RIGHT" = "playlist-next";
      "Shift+LEFT" = "playlist-prev";
      MBTN_RIGHT = "script-binding uosc/menu";
    };

    scripts =
      (lib.optionals (mpvScripts ? uosc) [ mpvScripts.uosc ])
      ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
      ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
      ++ (lib.optionals (mpvScripts ? "quality-menu") [ mpvScripts."quality-menu" ])
      ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
  };

  xdg.configFile."mpv/script-opts/uosc.conf".text = ''
    theme=dark
    scale=1.0
    border=2
    corner_radius=14
    shadow=yes
    timeline_style=line
    timeline_size=34
    timeline_cache=yes
    progress=always
  '';

  xdg.configFile."mpv/shaders/.keep".text = "";

  # Clean up legacy mpv symlink/dir before HM links individual files.
  home.activation.resetMpvPath =
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      if [ -e "$HOME/.config/mpv" ] || [ -L "$HOME/.config/mpv" ]; then
        rm -rf "$HOME/.config/mpv"
      fi
    '';
}
