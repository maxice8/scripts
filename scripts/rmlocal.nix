{ pkgs, relative }:
pkgs.writeShellScriptBin "rmlocal"
  ''
    [ $# -lt 1 ] && set -- "$(${pkgs.git}/bin/git branch --show-current)"
    DLBR_LOCAL=1 ${relative.dlbr}/bin/dlbr "$@"
  ''
