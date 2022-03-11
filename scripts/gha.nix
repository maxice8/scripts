{ pkgs }:
pkgs.writeShellScriptBin "gha"
  ''
    ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    [ $# -lt 1 ] && set -- HEAD
    ${pkgs.git}/bin/git rev-parse "$@" | ${pkgs.findutils}/bin/xargs
  ''
