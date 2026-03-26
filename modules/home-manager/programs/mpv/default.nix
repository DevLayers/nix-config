{ pkgs, lib, config, ... }:
let
  # Keep shader paths aligned with Home-Manager's configured XDG base dir
  # (usually ~/.config, but this avoids relying on "~" expansion inside mpv).
  shaderDir = "${config.xdg.configHome}/mpv/shaders";
  mpvScripts =
    if lib.hasAttr "mpvScripts" pkgs then
      pkgs.mpvScripts
    else
      {};
in
{
  config = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    programs.mpv =
      {
        enable = true;

        config = {
          # =========================
          # RENDERING CORE
          # =========================
          vo = "gpu-next";
          hwdec = "auto-safe";
          "gpu-api" = "auto";
          # Your NixOS host enables PipeWire's PulseAudio compatibility, so
          # force mpv to use `ao=pulse` (most mpv builds support this).
          ao = "pulse";

          # =========================
          # HDR / COLOR (TOP-TIER)
          # =========================
          "tone-mapping" = "bt.2446a"; # BEST modern algo
          "hdr-compute-peak" = true;
          "target-peak" = "auto";
          "gamut-mapping-mode" = "perceptual";

          # =========================
          # SCALING (MAX QUALITY)
          # =========================
          scale = "ewa_lanczossharp";
          cscale = "ewa_lanczossharp";
          dscale = "mitchell";

          # =========================
          # IMAGE QUALITY
          # =========================
          deband = true;
          "deband-iterations" = 2;
          # Higher threshold reduces more banding; primarily affects quality,
          # not shader complexity, so it's usually safe for smooth playback.
          "deband-threshold" = 64;
          "deband-range" = 16;

          # Adaptive sharpening
          "sigmoid-upscaling" = true;

          # =========================
          # PLAYBACK SMOOTHNESS
          # =========================
          # Keep stable frame pacing (avoid extra sync/processing load).
          "video-sync" = "audio";
          interpolation = false;
          tscale = "oversample";

          # =========================
          # CACHE / NETWORK
          # =========================
          cache = true;
          "demuxer-max-bytes" = "768MiB";
          "demuxer-max-back-bytes" = "384MiB";

          # =========================
          # STREAMING (BEST QUALITY)
          # =========================
          "ytdl-format" = "bestvideo[height<=2160]+bestaudio/best";
          # Keep this simple and valid for mpv/yt-dlp (avoids parse errors).
          # Your `ytdl-format` already picks the best video+audio.
          "ytdl-raw-options" = "yes-playlist=yes,format-sort=res";

          # =========================
          # UI
          # =========================
          osc = false;
          "osd-bar" = false;
        };

        bindings = {
          # Volume
          UP = "add volume 5";
          DOWN = "add volume -5";

          # Seek
          RIGHT = "seek 5";
          LEFT = "seek -5";

          # Playback
          SPACE = "cycle pause";
          F = "cycle fullscreen";

          # Frame
          "." = "frame-step";
          "," = "frame-back-step";

          # Screenshot
          S = "screenshot";

          # Subtitles
          W = "cycle sub";

          # Speed
          "]" = "add speed 0.1";
          "[" = "add speed -0.1";

          # Toggle interpolation (SVP-like)
          I = "cycle interpolation";

          # Toggle lightweight Anime4K clamp shader (safe enhancement)
          A = "change-list glsl-shaders toggle ${shaderDir}/Anime4K_Clamp_Highlights.glsl";

          # Toggle heavy Anime4K CNN restore (can drop frames at 4K)
          N = "change-list glsl-shaders toggle ${shaderDir}/Anime4K_Restore_CNN.glsl";
        };

        profiles = {
          # 4K / high quality
          highquality = {
            "profile-cond" = "width >= 2560";
            sharpen = 0.2;
          };

          # HDR
          hdr = {
            "profile-cond" = "p['video-params/primaries'] == 'bt.2020'";
            "tone-mapping" = "bt.2446a";
          };

          # Low res
          lowres = {
            "profile-cond" = "width <= 1280";
            sharpen = 0.5;
            deband = true;
          };
        };
      }
      // {
        # Make mpvScripts usage robust across nixpkgs versions.
        # If a script isn't available, we just skip it.
        scripts =
          (lib.optionals (mpvScripts ? uosc) [ mpvScripts.uosc ])
          ++ (lib.optionals (mpvScripts ? thumbfast) [ mpvScripts.thumbfast ])
          ++ (lib.optionals (mpvScripts ? sponsorblock) [ mpvScripts.sponsorblock ])
          ++ (lib.optionals (mpvScripts ? mpris) [ mpvScripts.mpris ])
          ++ (lib.optionals (mpvScripts ? quality-menu) [ mpvScripts."quality-menu" ])
          ++ (lib.optionals (mpvScripts ? autoload) [ mpvScripts.autoload ]);
      };

    # Make sure ytdl-raw-options targets work.
    home.packages = with pkgs; [
      yt-dlp
      ffmpeg
    ];

    # uosc script UI configuration.
    xdg.configFile."mpv/script-opts/uosc.conf".text = ''
      # =========================
      # UI LOOK
      # =========================
      theme=dark
      scale=1.0
      border=2
      corner_radius=12
      shadow=yes
      # 
    '';

    # Ensure the shader directory exists.
    # (Your actual Anime4K .glsl files must still be present in this folder.)
    xdg.configFile."mpv/shaders/.keep".text = "";
  };
}
