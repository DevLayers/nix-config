#
# .NET Development Environment
#
# C# and F# development with .NET SDK
#
{
  description = ".NET Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # .NET SDK
            dotnet-sdk_8         # .NET 8 SDK

            # Additional tools
            omnisharp-roslyn     # Language server for C#

            # Database
            postgresql           # PostgreSQL client
            sqlite               # SQLite

            # Utilities
            jq                   # JSON processor

            # Build tools
            gnumake              # Make
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║            🔷 .NET Development Environment 🔷              ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • .NET SDK: $(dotnet --version)"
            echo ""
            echo "🔧 Quick Start:"
            echo "  • dotnet new console -o MyApp    - Create console app"
            echo "  • dotnet new webapi -o MyApi     - Create Web API"
            echo "  • dotnet build                   - Build project"
            echo "  • dotnet run                     - Run project"
            echo "  • dotnet test                    - Run tests"
            echo ""
            echo "📦 Project Templates:"
            echo "  • console      - Console application"
            echo "  • classlib     - Class library"
            echo "  • webapi       - ASP.NET Core Web API"
            echo "  • mvc          - ASP.NET Core MVC"
            echo "  • blazorserver - Blazor Server App"
            echo "  • xunit        - xUnit test project"
            echo ""

            export PROJECT_ROOT=$PWD
            export DOTNET_ROOT=${pkgs.dotnet-sdk_8}
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
          '';
        };
      });
}
