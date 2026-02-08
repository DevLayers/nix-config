{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agenix for secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # Follow the main nixpkgs (nixos-unstable) for Firefox compatibility
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    {
      self,
      catppuccin,
      darwin,
      home-manager,
      nixpkgs,
      agenix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      # Production-grade library helpers
      customLib = import ./lib { inherit lib; };

      # Nixpkgs configuration
      nixpkgsConfig = {
        allowUnfree = true;
      };

      # Define user configurations
users = {
  "sarw.u" = {
    inherit (users.sarw)
      avatar
      email
      fullName
      gitKey
      ;
    name = "sarw.u";
  };

  sarw = {
    avatar = ./files/avatar;
    wallpaper = ./files/wallpaper.jpg;
    email = "sarrwar16@gmail.com";
    fullName = "SARWAR";
    gitKey = "0x3EEFB052E7D186BE";
    name = "sarw";
  };
};


      # Function for NixOS system configuration
      mkNixosConfiguration =
        hostname: username:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nixosModules = "${self}/modules/nixos";
            lib = lib.extend (final: prev: customLib);
          };
          modules = [
            { nixpkgs.config = nixpkgsConfig; }
            ./hosts/${hostname}
            agenix.nixosModules.default

          ];
        };

      # Function for nix-darwin system configuration
      mkDarwinConfiguration =
        hostname: username:
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            darwinModules = "${self}/modules/darwin";
          };
          modules = [
            { nixpkgs.config = nixpkgsConfig; }
            ./hosts/${hostname}
          ];
        };

      # Function for Home Manager configuration
      mkHomeConfiguration =
        system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = nixpkgsConfig;
          };
          extraSpecialArgs = {
            inherit inputs outputs;
            userConfig = users.${username};
            nhModules = "${self}/modules/home-manager";
          };
          modules = [
            ./home/${username}/${hostname}
            catppuccin.homeModules.catppuccin
          ];
        };
    in
    {
      # Export custom library helpers
      lib = customLib;

      nixosConfigurations = {
        energy = mkNixosConfiguration "energy" "sarw";
      };

      darwinConfigurations = {
        "PL-OLX-KCGXHGK3PY" = mkDarwinConfiguration "PL-OLX-KCGXHGK3PY" "sarw.u";
      };

      homeConfigurations = {
        "sarw.u@PL-OLX-KCGXHGK3PY" =
          mkHomeConfiguration "aarch64-darwin" "sarw.u"
            "PL-OLX-KCGXHGK3PY";
        "sarw@energy" = mkHomeConfiguration "x86_64-linux" "sarw" "energy";
      };

<<<<<<< HEAD
      overlays = import ./overlays { inherit inputs; };

      # Development templates
      templates = (import ./templates {}).flake.templates;
=======
>>>>>>> upstream/master
    };
}
