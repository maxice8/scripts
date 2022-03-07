{ pkgs }:
pkgs.writeShellScriptBin "pm"
''
# pm - ports merge
# uses `glab` to merge a merge request

opts=""
mrs=""

for arg; do
  case "$arg" in
    --help)
      ${pkgs.glab}/bin/glab --help
      exit 0
      ;;
    -*) opts="$opts $arg" ;;
    *) mrs="$mrs $arg" ;;
  esac
done

[ "$mrs" = "" ] && mrs="$(${pkgs.git}/bin/git branch --show-current)"

if [ -n "$AMR_DRY_RUN" ]; then
  printf -- 'Merge Requests: !%s\n' $mrs
  printf -- 'Opts: %s\n' $opts
fi

for mr in $mrs; do
  ${pkgs.glab}/bin/glab \
    mr merge \
    --yes \
    --rebase \
    --when-pipeline-succeeds="$(printf '%s' "$mrs" | grep -q '[[:space:]]' && echo true || echo false)" \
    $opts $mr
done
''
