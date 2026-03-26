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
      vo = "gpu-next";
      "gpu-api" = "auto";
      hwdec = "auto-safe";
      ao = "pulse";

      "video-sync" = "audio";
      interpolation = true;
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
      "demuxer-max-bytes" = "256MiB";
      "demuxer-max-back-bytes" = "128MiB";

      "ytdl-format" = "bestvideo[height<=2160]+bestaudio/best";
      "ytdl-raw-options" = "yes-playlist=yes,format-sort=res";

      osc = false;
      "osd-bar" = false;
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
        "video-sync" = "display-resample";
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
    };

    scripts =
      (lib.optionals (mpvScripts ? uosc) [ mpvScripts.uosc ])
      ++ (lib.optionals (mpvScripts ? thumbfast) [ mpvScripts.thumbfast ])
      ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
      ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
      ++ (lib.optionals (mpvScripts ? "quality-menu") [ mpvScripts."quality-menu" ])
      ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
  };

  # =========================
  # XDG FILES (OUTSIDE programs.mpv)
  # =========================
  xdg.configFile."mpv/script-opts/uosc.conf".text = ''
    theme=dark
    scale=1.0
    border=2
    corner_radius=12
    shadow=yes
  '';

  xdg.configFile."mpv/shaders/.keep".text = "";
}