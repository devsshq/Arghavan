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
