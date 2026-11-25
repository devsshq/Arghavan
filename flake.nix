# Arghavan/flake.nix
{
  description = "Arghavan: theme assets (Firefox theme, wallpapers)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in
    {
      lib.palette = {
        bg = "#121212";
        surface = "#1B1B1B";
        line = "#2B2B2B";
        muted = "#8C867A";
        fg = "#EDE3BA";

        accentBase = "#9011BF";
        accent = "#BE55E6";
        accentDim = "#3A0F4D";

        error = "#D9604C";
        warning = "#D9A441";
        success = "#7FAE6B";
        info = "#6E9BC4";

        ansi = {
          normal = {
            black = "#1B1B1B";
            red = "#D9604C";
            green = "#7FAE6B";
            yellow = "#D9A441";
            blue = "#6E9BC4";
            magenta = "#BE55E6";
            cyan = "#6FAFA8";
            white = "#C9C0A0";
          };
          bright = {
            black = "#8C867A";
            red = "#E8806C";
            green = "#9CC688";
            yellow = "#E8BC62";
            blue = "#8FB6DC";
            magenta = "#D58AF0";
            cyan = "#8FC9C1";
            white = "#EDE3BA";
          };
        };
      };

      packages = forAll (pkgs: rec {
        default = firefox-theme;

        firefox-theme = pkgs.stdenvNoCC.mkDerivation {
          pname = "arghavan-firefox";
          version = (builtins.fromJSON (builtins.readFile ./arghavan-firefox/manifest.json)).version;
          src = ./arghavan-firefox;
          nativeBuildInputs = [ pkgs.zip ];
          passthru.addonId = "arghavan@dsam";
          installPhase = ''
            d=$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
            mkdir -p $d
            zip -X $d/arghavan@dsam.xpi manifest.json
          '';
        };

        wallpaper = pkgs.stdenvNoCC.mkDerivation {
          pname = "arghavan-wallpaper";
          version = "1";
          src = ./walls;
          installPhase = ''
            d=$out/share/backgrounds/arghavan
            mkdir -p $d $out/share/doc/arghavan-wallpaper
            cp *.png *.svg $d/
            cp LICENSE ATTRIBUTION.md $out/share/doc/arghavan-wallpaper/
          '';
        };
      });
    };
}
