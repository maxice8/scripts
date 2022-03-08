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
  };
  relative = self.packages.${system};
  in
  rec {
    packages = {
      printok = pkgs.callPackage ./scripts/printok.nix {};
      printerr = pkgs.callPackage ./scripts/printerr.nix {};
      guess-remote = pkgs.callPackage ./scripts/guess-remote.nix {};
      main-branch = pkgs.callPackage ./scripts/main-branch.nix {};
      gbr = pkgs.callPackage ./scripts/gbr.nix { inherit relative; };
      unpk = pkgs.callPackage ./scripts/unpk.nix {};
      fgc = pkgs.callPackage ./scripts/fgc.nix {};
      tracking-branch = pkgs.callPackage ./scripts/tracking-branch.nix {};
      dlbr = pkgs.callPackage ./scripts/dlbr.nix { inherit relative; };
      pm = pkgs.callPackage ./scripts/pm.nix {};
      rmlocal = pkgs.callPackage ./scripts/rmlocal.nix {};
    };
    overlays =
    final:
    prev:
    {
      maxice8-scripts = pkgs.buildEnv {
        name = "maxice8-scripts";
        paths =
          [
            packages.gbr
            packages.unpk
            packages.fgc
            packages.dlbr
            packages.pm
            packages.rmlocal
          ];
      };
    };
  });
}
