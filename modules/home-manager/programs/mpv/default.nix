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

      # uosc UI controls
      O = "script-binding uosc/open-file";
      K = "script-binding uosc/keybinds";
      A = "script-binding uosc/audio-device";
      Y = "script-binding quality_menu/video_formats_toggle";
      U = "script-binding quality_menu/audio_formats_toggle";

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
      ++ (lib.optionals (mpvScripts ? thumbfast) [ mpvScripts.thumbfast ])
      ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
      ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
      ++ (lib.optionals (mpvScripts ? "quality-menu") [ mpvScripts."quality-menu" ])
      ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
  };

  xdg.configFile."mpv/script-opts/uosc.conf".text = ''
    controls=command:menu:script-binding uosc/menu?Menu,gap,command:high_quality:script-binding quality_menu/video_formats_toggle?Stream quality,video,audio,subtitles,space,speed:1,gap,playlist,chapters,gap,audio-device,fullscreen
    controls_size=36
    controls_margin=8
    controls_spacing=2

    top_bar=no-border
    top_bar_size=40
    top_bar_controls=right
    top_bar_title=''${media-title}
    top_bar_alt_title=''${filename}
    top_bar_alt_title_place=toggle

    volume=left
    volume_size=38
    volume_border=1
    volume_step=2

    timeline_style=line
    timeline_line_width=2
    timeline_size=32
    timeline_step=5
    timeline_cache=yes
    timeline_heatmap=overlay
    progress=never
    progress_size=2
    progress_line_width=20

    menu_item_height=35
    menu_min_width=380
    menu_padding=4
    menu_type_to_search=yes

    scale=1
    scale_fullscreen=1
    font_scale=1
    text_border=1.1
    border_radius=8
    color=foreground=ffffff,background=000000,match=7aa2f7,heatmap=7dcfff
    opacity=timeline=0.80,chapters=0.72,slider=0.80,speed=0.15,menu=0.82,submenu=0.72,title=0,tooltip=0.82,curtain=0,idle_indicator=0.7,audio_indicator=0.7,buffering_indicator=0.7,playlist_position=0.35,heatmap=0.68
    animation_duration=100
    flash_duration=900

    autoload=no
    shuffle=no
    disable_elements=window_border,pause_indicator
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
