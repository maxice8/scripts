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
          overlays = [
            (final: prev:
              # attrSet that includes all defined packages
              builtins.listToAttrs
                (map
                  (x: {
                    name = x;
                    value = self.packages.${system}.${x};
                  })
                  (builtins.attrNames self.packages.${system})))
          ];
        };
      in
      rec {
        packages = {
          printok = pkgs.callPackage ./scripts/printok.nix { };
          printerr = pkgs.callPackage ./scripts/printerr.nix { };
          guess-remote = pkgs.callPackage ./scripts/guess-remote.nix { };
          main-branch = pkgs.callPackage ./scripts/main-branch.nix { };
          gbr = pkgs.callPackage ./scripts/gbr.nix { };
          unpk = pkgs.callPackage ./scripts/unpk.nix { };
          fgc = pkgs.callPackage ./scripts/fgc.nix { };
          tracking-branch = pkgs.callPackage ./scripts/tracking-branch.nix { };
          dlbr = pkgs.callPackage ./scripts/dlbr.nix { };
          pm = pkgs.callPackage ./scripts/pm.nix { };
          rmlocal = pkgs.callPackage ./scripts/rmlocal.nix { };
          gha = pkgs.callPackage ./scripts/gha.nix { };
          git-clean-branches = pkgs.callPackage ./scripts/git-clean-branches.nix { };
          maxice8-scripts = pkgs.buildEnv {
            name = "maxice8-scripts";
            paths =
              [
                self.packages.${system}.gbr
                self.packages.${system}.unpk
                self.packages.${system}.fgc
                self.packages.${system}.dlbr
                self.packages.${system}.pm
                self.packages.${system}.rmlocal
                self.packages.${system}.gha
                self.packages.${system}.git-clean-branches
              ];
          };
        };
      });
}
