{ pkgs, relative }:
pkgs.writeShellScriptBin "git-clean-branches"
  ''
    ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    branch="$(${relative.tracking-branch}/bin/tracking-branch)"
    DLBR_LOCAL=1 \
      "${relative.dlbr}/bin/dlbr" $(${pkgs.git}/bin/git branch --merged "$branch" \
        | ${pkgs.gnugrep}/bin/grep -v -E '(master|$branch)' \
        | ${pkgs.gnused}/bin/sed 's/^..//;s/ .*//')
  ''
