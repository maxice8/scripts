{ writeShellScriptBin
, coreutils
, gnutar
, lzma
, bzip2
, unrar
, gzip
, zstd
, unzip
, p7zip
, xz
}:
writeShellScriptBin "unpk"
  ''
    if [ $# -lt 1 ]; then
      ${coreutils}/bin/printf "%s '<archives...>'\n" "$0"
      exit 0
    fi

    ret=0
    for i in "$@"; do
      case "$i" in
      *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar|*.xbps|*.apk)
        ${gnutar}/bin/tar xfv "$i"
        ;;
      *.lzma)
        ${lzma}/bin/unlzma -cd "$i"
        ;;
      *.bz2)
        ${bzip2}/bin/bunzip2 -cd "$i"  
        ;;
      *.rar)
        ${unrar}/bin/unrar x -ad "$i"
        ;;
      *.gz)
        ${gzip}/bin/gunzip "$i"
        ;;
      *.zst)
        ${zstd}/bin/unzstd -cq "$i"
        ;;
      *.zip)
        ${unzip}/bin/unzip "$i"
        ;;
      *.Z)
        ${gzip}/bin/uncompress -c "$i"
        ;;
      *.7z|*.arj|*.cab|*.chm|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xa)
        ${p7zip}/bin/7za x "$i"
        ;;
      *.xz)
        ${xz}/bin/unxz -cd "$i"
        ;;
      *)
        ${coreutils}/bin/printf "file format for '%s' not supported" "$i" >&2
        ret=$((ret + 1))
        ;;
      esac
    done
    exit $ret
  ''
