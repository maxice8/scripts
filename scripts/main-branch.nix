{ pkgs }:
pkgs.writeShellScriptBin "main-branch"
  ''
    ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    [ $# -lt 1 ] && set -- origin

    ref="$(${pkgs.git}/bin/git symbolic-ref refs/remotes/"$1"/HEAD 2>/dev/null || echo master)"
    ref="$(${pkgs.coreutils}/bin/basename "$ref" 2>/dev/null)"
    ${pkgs.coreutils}/bin/printf '%s' "$ref"
  ''
