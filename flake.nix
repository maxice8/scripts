{
  description = "my shell scripts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    # User-friendly version
    version = builtins.substring 0 8 self.lastModifiedDate;

    # Systems we support
    supportedSystems = [ "x86_64-linux" ];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
  {
    packages = forAllSystems (system:
    let
      pkgs = nixpkgsFor.${system};
      relative = self.packages.${system};
    in
    {
      printok = pkgs.callPackage ./scripts/printok.nix {};
      printerr = pkgs.callPackage ./scripts/printerr.nix {};
      alpine-stable-prefix = pkgs.callPackage ./scripts/alpine-stable-prefix.nix {};
      guess-remote = pkgs.callPackage ./scripts/guess-remote.nix {};
      main-branch = pkgs.callPackage ./scripts/main-branch.nix {};
      gbr = pkgs.callPackage ./scripts/gbr.nix { inherit relative; };
      atools = pkgs.callPackage ./scripts/atools.nix { inherit relative; };
      unpk = pkgs.callPackage ./scripts/unpk.nix {};
      fgc = pkgs.callPackage ./scripts/fgc.nix {};
      tracking-branch = pkgs.callPackage ./scripts/tracking-branch.nix {};
      dlbr = pkgs.callPackage ./scripts/dlbr.nix { inherit relative; };
    });
    overlay = final: prev: {
      atools = final.pkgs.atools;
    };
  };
}
