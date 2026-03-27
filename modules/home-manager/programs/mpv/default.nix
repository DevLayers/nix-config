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
    timeline_line_width=2
    controls_size=35
    controls_margin=8
    controls_spacing=2
    controls=command:menu:script-binding uosc/menu?Menu,gap,command:high_quality:script-binding quality_menu/video_formats_toggle?Stream quality,editions,video,audio,command:auto_stories:script-binding uosc/chapters#chapters>0?Chapters,subtitles,space,speed:1,gap,command:replay:no-osd ab-loop?A-B loop,loop-file,loop-playlist,toggle:read_more:autoload@uosc?Autoload,shuffle,gap,command:history:script-binding memo-history?History,prev,items,next,gap,toggle:move_up:ontop?Ontop,fullscreen
    volume=left
    volume_size=37
    volume_border=1
    volume_step=2
    speed_step=0.05
    speed_step_is_factor=no
    menu_item_height=35
    menu_min_width=360
    menu_padding=4
    menu_type_to_search=yes
    top_bar=no-border
    top_bar_size=40
    top_bar_controls=right
    top_bar_title=''${media-title}
    top_bar_alt_title=''${filename}
    top_bar_alt_title_place=toggle
    timeline_style=line
    timeline_size=30
    timeline_step=5
    timeline_cache=yes
    timeline_heatmap=overlay
    progress=never
    progress_size=2
    progress_line_width=20
    scale=1
    scale_fullscreen=1
    font_scale=1
    text_border=1.2
    border_radius=4
    color=heatmap=ffffff
    opacity=timeline=0.775,chapters=0.675,slider=0.775,speed=0,menu=0.775,submenu=0.675,title=0,tooltip=0.775,curtain=0,idle_indicator=0.675,audio_indicator=0.675,buffering_indicator=0.675,playlist_position=0.3,heatmap=0.675
    animation_duration=100
    flash_duration=1000
    pause_indicator=flash
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
