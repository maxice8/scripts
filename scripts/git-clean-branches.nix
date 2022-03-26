{ writeShellScriptBin
, git
, gnugrep
, gnused
, tracking-branch
, dlbr
}:
writeShellScriptBin "git-clean-branches"
  ''
    ${git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    branch="$(${tracking-branch}/bin/tracking-branch)"
    DLBR_LOCAL=1 \
      "${dlbr}/bin/dlbr" $(${git}/bin/git branch --merged "$branch" \
        | ${gnugrep}/bin/grep -v -E '(master|$branch)' \
        | ${gnused}/bin/sed 's/^..//;s/ .*//')
  ''
