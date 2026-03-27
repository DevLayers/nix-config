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
      scale = "jinc";
      cscale = "jinc";
      dscale = "spline36";
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
      "hdr-peak-percentile" = 99.95;
      "hdr-contrast-recovery" = 0.98;
      "tone-mapping" = "bt.2390";
      "tone-mapping-param" = 1.39;
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

      # ModernZ UI controls
      X = "script-message-to modernz osc-show";
      Y = "script-message-to modernz osc-visibility cycle";

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
      MBTN_RIGHT = "cycle pause";
    };

    scripts =
      (lib.optionals (mpvScripts ? modernz) [ mpvScripts.modernz ])
      ++ (lib.optionals (mpvScripts ? thumbfast) [ mpvScripts.thumbfast ])
      ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
      ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
      ++ (lib.optionals (mpvScripts ? "quality-menu") [ mpvScripts."quality-menu" ])
      ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
  };

  xdg.configFile."mpv/script-opts/modernz.conf".text = ''
    layout=modern
    icon_theme=fluent
    icon_style=filled
    title=''${media-title}
    window_top_bar=auto
    show_title=yes
    cache_info=yes
    jump_amount=5
    speed_button=yes
    speed_button_scroll=0.25
    volume_control=yes
    playlist_button=yes
    info_button=yes
    screenshot_button=yes
    tooltip_hints=yes
    osc_color=#000000
    seekbarfg_color=#7AA2F7
    seekbarbg_color=#3B4261
    seekbar_cache_color=#565F89
    side_buttons_color=#C0CAF5
    middle_buttons_color=#C0CAF5
    playpause_color=#FFFFFF
    hover_effect=size,glow,color
    hover_effect_color=#7DCFFF
    fade_alpha=0
    fade_blur_strength=0
    fade_transparency_strength=0
    window_fade_alpha=0
    window_fade_blur_strength=0
    window_fade_transparency_strength=0
    seek_handle_size=0.9
    slider_rounded_corners=yes
    nibbles_style=single-bar
    persistent_progress=yes
    persistent_progress_height=14
    visibility=auto
  '';

  xdg.configFile."mpv/script-opts/evafast.conf".text = ''
    seek_distance=5
    speed_increase=0.1
    speed_decrease=0.1
    speed_interval=0.05
    speed_cap=2
    subs_speed_cap=2
    multiply_modifier=no
    subs_lookahead=yes
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
