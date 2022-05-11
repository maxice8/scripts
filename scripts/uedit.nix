{ writeShellScriptBin
, coreutils
, diffutils
, sudo
}:
writeShellScriptBin "uedit"
  ''
    set -eu

    for arg; do
      case "$arg" in
        --) shift; break;;
        -*) echo "unrecognized option: $arg" >&2; exit 2;;
        *) break;;
      esac
    done

    prog="$1"
    args=( "''${@:2}" )
    if [[ ''${#args[@]} -le 0 ]]; then
      echo "needs an argument to open" >&2
      exit 2
    fi

    last=$(( ''${#args[@]} - 1 ))

    filename=''${args[last]}

    tmpdir=$(${coreutils}/bin/mktemp -t ''${XDG_RUNTIME_DIR+"-p" "$XDG_RUNTIME_DIR"} -d unprivopen.XXXX)

    tmpfile="$tmpdir/$(${coreutils}/bin/basename -- "$filename").tmp"
    args[last]="$tmpfile"

    if [ -e "$filename" ]; then
      ${coreutils}/bin/cp -Tf -- "$filename" "$tmpfile"
    else
      ${coreutils}/bin/touch -- "$tmpfile"
    fi

    syncer() {
      if ! ${diffutils}/bin/diff "$tmpfile" "$filename" >/dev/null 2>&1; then
        ${sudo}/bin/sudo ${coreutils}/bin/timeout -s kill 2 ${coreutils}/bin/dd "if=$tmpfile" "of=$filename" >/dev/null 2>&1
      elif [ -z "$(${coreutils}/bin/cat "$tmpfile")" ]; then
        ${sudo}/bin/sudo ${coreutils}/bin/timeout -s kill 2 ${coreutils}/bin/rm -- "$filename"
      else
        exitc=1
      fi
    }

    cleaner() {
      ${coreutils}/bin/rm    -- "$tmpfile"
      ${coreutils}/bin/rmdir -- "$tmpdir"

      exit ''${exitc-0}
    }

    trap syncer USR1
    trap cleaner EXIT

    "$prog" "''${args[@]}" &
    mainpid=$!

    while [ -e /proc/$mainpid ]; do
      inotifywait -qq -e modify -- "$tmpfile" &
      wait -n || true
      syncer
    done
  ''


