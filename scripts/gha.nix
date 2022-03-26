{ writeShellScriptBin
, git
, findutils
}:
writeShellScriptBin "gha"
  ''
    ${git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    [ $# -lt 1 ] && set -- HEAD
    ${git}/bin/git rev-parse "$@" | ${findutils}/bin/xargs
  ''
