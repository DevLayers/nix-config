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

      # SYNC & MOTION
      "video-sync" = "audio";
      interpolation = false;
      tscale = "oversample";
      tscale-window = "sphinx";
      tscale-clamp = 0.0;
      tscale-antiring = 0.01;

      # SCALING
      scale = "jinc";
      cscale = "jinc";
      dscale = "spline36";
      "sigmoid-upscaling" = true;
      scale-clamp = 0.0;
      scale-antiring = 0.0009;
      correct-downscaling = true;
      linear-downscaling = true;

      # DEBANDING
      deband = true;
      "deband-iterations" = 2;
      "deband-threshold" = 32;
      "deband-range" = 16;
      "deband-grain" = 6;

      # DITHERING
      dither = "fruit";
      "dither-depth" = 16;
      "dither-size-fruit" = 8;
      temporal-dither = true;
      "temporal-dither-period" = 4;

      # CACHE
      cache = true;
      "demuxer-max-bytes" = "512MiB";
      "demuxer-max-back-bytes" = "256MiB";

      #BT.2390 HDR & ACES-like filmic
      "hdr-compute-peak" = true;
      "hdr-peak-percentile" = 99.95;
      "hdr-contrast-recovery" = 0.98;
      "tone-mapping" = "bt.2390";
      "tone-mapping-param" = 1.39;
      "target-colorspace-hint" = true;
      "gamut-mapping-mode" = "perceptual";
      "target-peak" = "auto";

      # AUDIO
      ao = "pulse";
      "audio-exclusive" = false;
      "audio-channels" = "auto";
      "volume-max" = 130;
      "gapless-audio" = true;
      "audio-pitch-correction" = true;
      "audio-normalize-downmix" = true;
      "audio-buffer" = 0.4;

      # YTDL
      "ytdl-format" = "bestvideo[height<=2160]+bestaudio/best";
      "ytdl-raw-options" = "yes-playlist=yes,format-sort=res";

      # OSC & UI
      osc = false;
      "osd-bar" = false;

      # PLAYBACK
      "save-position-on-quit" = true;
      "keep-open" = true;
      "slang" = "eng,en";
      "alang" = "jpn,jp,eng,en";
      "sub-auto" = "fuzzy";

      # SEEKING
      hr-seek = true;
      "hr-seek-framedrop" = false;
      force-seekable = true;

      # SUBTITLE DEFAULTS
      "sub-font" = "Segoe UI Light";
      "sub-font-size" = 60;
      "sub-color" = "#ffff00";
      "sub-border-size" = 1.0;
      "sub-outline-color" = "#ff0000";
      "sub-shadow-color" = "#000000";
      "sub-shadow-offset" = 0.5;
      "sub-blur" = 0.0;
      "sub-back-color" = "#00000000";
      "sub-fix-timing" = true;
      "blend-subtitles" = true;
      "sub-clear-on-seek" = true;
    };

    # KEY BINDINGS
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

      # uosc UI
      O = "script-binding uosc/open-file";
      K = "script-binding uosc/keybinds";
      A = "script-binding uosc/audio-device";
      Y = "script-binding quality_menu/video_formats_toggle";
      U = "script-binding quality_menu/audio_formats_toggle";

      "Ctrl+f" = "script-binding quality_menu/video_formats_toggle";
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";

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

    # SCRIPTS
    scripts =
      (lib.optionals (mpvScripts ? uosc) [ mpvScripts.uosc ])
      ++ (lib.optionals (mpvScripts ? thumbfast) [ mpvScripts.thumbfast ])
      ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
      ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
      ++ (lib.optionals (mpvScripts ? "quality-menu") [ mpvScripts."quality-menu" ])
      ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
  };

  # uosc config
  xdg.configFile."mpv/script-opts/uosc.conf".text = ''
    controls=command:menu:script-binding uosc/menu?Menu,gap,stream-quality,video,audio,subtitles,space,speed:1.0,gap,playlist,chapters,audio-device,fullscreen
    controls_size=38
    controls_margin=10
    controls_spacing=3
    controls_persistency=

    top_bar=no-border
    top_bar_size=42
    top_bar_controls=right
    top_bar_title=''${media-title}
    top_bar_alt_title=''${filename}
    top_bar_alt_title_place=toggle

    volume=left
    volume_size=40
    volume_border=1
    volume_step=2

    timeline_style=line
    timeline_line_width=3
    timeline_size=36
    timeline_step=5
    timeline_border=0
    timeline_cache=yes
    timeline_heatmap=overlay
    progress=always
    progress_size=3
    progress_line_width=20

    menu_item_height=36
    menu_min_width=420
    menu_padding=4
    menu_type_to_search=yes

    speed_step=0.05
    speed_step_is_factor=no
    scale=1
    scale_fullscreen=1
    font_scale=1
    text_border=1.2
    border_radius=10
    color=foreground=e6e8ef,foreground_text=11121a,background=0f1117,background_text=e6e8ef,match=7aa2f7,heatmap=7dcfff
    opacity=timeline=0.86,chapters=0.78,slider=0.86,slider_gauge=1,speed=0.22,menu=0.90,submenu=0.78,border=1,title=0,tooltip=0.9,curtain=0,idle_indicator=0.72,audio_indicator=0.72,buffering_indicator=0.72,playlist_position=0.45,heatmap=0.72
    animation_duration=110
    flash_duration=1000
    autohide=yes
    pause_indicator=flash

    autoload=no
    shuffle=no
    disable_elements=window_border
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