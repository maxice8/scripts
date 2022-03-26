{ writeShellScriptBin
, git
, coreutils
}:
writeShellScriptBin "main-branch"
  ''
    ${git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    [ $# -lt 1 ] && set -- origin

    ref="$(${git}/bin/git symbolic-ref refs/remotes/"$1"/HEAD 2>/dev/null || echo master)"
    ref="$(${coreutils}/bin/basename "$ref" 2>/dev/null)"
    ${coreutils}/bin/printf '%s' "$ref"
  ''
