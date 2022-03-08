{ pkgs }:
pkgs.writeShellScriptBin "guess-remote"
  ''
    if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1) exit 1
    if(${pkgs.git}/bin/git config remote.upstream.url >/dev/null) {
      echo upstream
      exit 0
    }
    if(${pkgs.git}/bin/git config remote.origin.url >/dev/null) {
      echo origin
      exit 0
    }
    exit 1
  ''
