{ pkgs, lib, config, ... }:

let
  shaderDir = "${config.xdg.configHome}/mpv/shaders";
  mpvScripts = if lib.hasAttr "mpvScripts" pkgs then pkgs.mpvScripts else {};
in
{
  # =========================
  # MPV PROGRAM CONFIG
  # =========================
  programs.mpv = {
    enable = true;

    config = {
      # --- Core Hardware Settings ---
      vo = "gpu-next"; 
      "gpu-api" = "auto";
      hwdec = "auto-safe";
      ao = "pulse";

      # --- Critical Fix for Smooth Motion & Anti-Blur ---
      "video-sync" = "audio";
      interpolation = false; 
      tscale = "oversample"; 

      # --- High-Quality Built-in Scaling ---
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      "sigmoid-upscaling" = true;

      # --- Clean Presentation ---
      deband = true;
      "deband-iterations" = 2;
      "deband-threshold" = 32;
      "deband-range" = 16;

      cache = true;
      "demuxer-max-bytes" = "512MiB"; # Increased cache for 4K streaming
      "demuxer-max-back-bytes" = "256MiB";

      "ytdl-format" = "bestvideo[height<=2160]+bestaudio/best";
      "ytdl-raw-options" = "yes-playlist=yes,format-sort=res";

      # Disable default UI so uosc can run cleanly
      osc = false;
      "osd-bar" = false;

      # --- Quality of Life Additions ---
      "save-position-on-quit" = true;
      "keep-open" = true;
      "slang" = "eng,en";
      "alang" = "jpn,jp,eng,en";
      "sub-auto" = "fuzzy";
    };

    profiles = {
      hdr = {
        "profile-cond" = "p['video-params/primaries'] == 'bt.2020'";
        "tone-mapping" = "bt.2446a";
        "hdr-compute-peak" = true;
        "target-peak" = "auto";
        "gamut-mapping-mode" = "perceptual";
      };

      highquality = {
        "profile-cond" = "width >= 2560";
        sharpen = 0.2;
      };

      lowres = {
        "profile-cond" = "width <= 1280";
        sharpen = 0.4;
        deband = true;
      };

      image = {
        "profile-cond" = "p['video-params/frame-count'] == 1";
        interpolation = false;
        "video-sync" = "audio"; 
        deband = false;
        cache = false;
        "tone-mapping" = "clip";
        "glsl-shaders" = "";
      };
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
      S = "screenshot video";
      "Shift+S" = "screenshot";
      W = "cycle sub";
      "]" = "add speed 0.1";
      "[" = "add speed -0.1";
      I = "cycle interpolation";
      
      # Quality Menu trigger for YouTube videos
      "Ctrl+f" = "script-binding quality_menu/video_formats_toggle";
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";

      # Shaders
      A = "change-list glsl-shaders toggle ${shaderDir}/Anime4K_Clamp_Highlights.glsl";
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
      
      # Map the ModernZ menu to Right Click
      MBTN_RIGHT = "script-binding select/menu";
    };

    scripts =
      (lib.optionals (mpvScripts ? modernz) [ mpvScripts.modernz ])
      ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
      ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
      ++ (lib.optionals (mpvScripts ? "quality-menu") [ mpvScripts."quality-menu" ])
      ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
  };

  # =========================
  # XDG FILES (UI & Script Tuning)
  # =========================
  
  # ModernZ OSC styling (visual-only defaults)
  xdg.configFile."mpv/script-opts/modernz.conf".text = ''
    layout=modern
    icon_theme=fluent
    icon_style=mixed

    show_title=true
    show_chapter_title=true
    cache_info=false

    seekbarfg_color=#FB8C00
    seekbarbg_color=#94754F
    osc_color=#000000
    fade_alpha=130
  '';

  
  xdg.configFile."mpv/shaders/.keep".text = "";
}