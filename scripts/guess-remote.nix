{ pkgs }:
pkgs.writeShellScriptBin "guess-remote"
  ''
    ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    if ${pkgs.git}/bin/git config remote.upstream.url >/dev/null; then
      echo upstream
      exit 0
    fi
    if ${pkgs.git}/bin/git config remote.origin.url >/dev/null; then
      echo origin
      exit 0
    fi
    exit 1
  ''
