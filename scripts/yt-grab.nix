{ writeShellScriptBin
, youtube-dl
}:
writeShellScriptBin "yt-grab"
  ''
    [ $# -lt 1 ] && 1
    exec ${youtube-dl}/bin/youtube-dl \
      -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' --merge-output-format mp4 \
      "$@"
  ''
