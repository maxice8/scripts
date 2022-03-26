{ writeShellScriptBin
, git
, dlbr
}:
writeShellScriptBin "rmlocal"
  ''
    [ $# -lt 1 ] && set -- "$(${git}/bin/git branch --show-current)"
    DLBR_LOCAL=1 ${dlbr}/bin/dlbr "$@"
  ''
