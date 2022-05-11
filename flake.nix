{
  description = "my shell scripts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          # Have each package we defined available for eachother to use
          # so that packages like 'x' can use 'y' even though both
          # are defined at the same time
          overlays = [ (final: prev: self.packages.${system}) ];
        };
      in
      {
        packages =
          # Read each file in scripts/ and create a package for each
          builtins.listToAttrs
            (map
              (x: {
                # Remove the '.nix' suffix for the package
                name = builtins.replaceStrings [ ".nix" ] [ "" ] x;
                value = pkgs.callPackage (./scripts + "/${x}") { };
              })
              (builtins.attrNames (builtins.readDir ./scripts))) //
          {
            maxice8-scripts = pkgs.buildEnv {
              name = "maxice8-scripts";
              paths =
                with self.packages.${system}; [
                  gbr
                  unpk
                  fgc
                  dlbr
                  pm
                  rmlocal
                  gha
                  git-clean-branches
                  vid-grab
                  yt-grab
                  uedit
                ];
            };
          };
      });
}
