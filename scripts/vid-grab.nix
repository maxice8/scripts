{ writeShellScriptBin
, youtube-dl
}:
writeShellScriptBin "vid-grab"
  ''
    [ $# -lt 1 ] && 1
    exec ${youtube-dl}/bin/youtube-dl -f best "$@"
  ''
