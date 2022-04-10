{ writeShellScriptBin
, psmisc
, util-linux
, ydotool
, coreutils
}:
writeShellScriptBin "keep-pressing"
  ''
    [ $# -lt 1 ] && set -- 0xC0
    lockfile="''${XDG_RUNTIME_DIR:=$TMPDIR}/keep-pressing.lock"
    (
      ${util-linux}/bin/flock --exclusive --nonblock 200 || {
        ${psmisc}/bin/fuser -k "$lockfile"
        exit 1 ;
      }
      while true; do
        ${ydotool}/bin/ydotool click "$1"
        ${coreutils}/bin/sleep 0.01
      done
    ) 200>"$lockfile"
  ''
