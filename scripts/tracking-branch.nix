{ writeShellScriptBin
, git
, coreutils
, gnugrep
}:
writeShellScriptBin "tracking-branch"
  ''
    ${git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    [ $# -lt 1 ] && branch=HEAD || branch="$1"

    #
    # If there is no tracking branch then this will error out, so supress stderr
    # as it will return nothing in that case
    #
    _f="$(${git}/bin/git for-each-ref --format='%(upstream:short)' "$(${git}/bin/git rev-parse --symbolic-full-name $branch)")"

    #
    # If there is no tracking branch then we can safely use our own branch name
    #
    if [ -z "$_f" ] || ${coreutils}/bin/printf '%s' "$_f" | ${gnugrep}/bin/grep -F -q '@{u}'; then
      ${git}/bin/git branch --show-current
      exit 0
    fi

    #
    # We only reach here if we have a tracking branch, which takes the form of
    # <remote>/<branch>, split by the / and take the second value
    #
    ${coreutils}/bin/printf '%s' "$_f" | ${coreutils}/bin/cut -d / -f2
  ''
