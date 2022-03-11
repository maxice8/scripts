{ pkgs }:
pkgs.writeShellScriptBin "unpk"
  ''
    if [ $# -lt 1 ]; then
      ${pkgs.coreutils}/bin/printf "%s '<archives...>'\n" "$0"
      exit 0
    fi

    ret=0
    for i in "$@"; do
      case "$i" in
      *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar|*.xbps|*.apk)
        ${pkgs.gnutar}/bin/tar xfv "$i"
        ;;
      *.lzma)
        ${pkgs.lzma}/bin/unlzma -cd "$i"
        ;;
      *.bz2)
        ${pkgs.bzip2}/bin/bunzip2 -cd "$i"  
        ;;
      *.rar)
        ${pkgs.unrar}/bin/unrar x -ad "$i"
        ;;
      *.gz)
        ${pkgs.gzip}/bin/gunzip "$i"
        ;;
      *.zst)
        ${pkgs.zstd}/bin/unzstd -cq "$i"
        ;;
      *.zip)
        ${pkgs.unzip}/bin/unzip "$i"
        ;;
      *.Z)
        ${pkgs.gzip}/bin/uncompress -c "$i"
        ;;
      *.7z|*.arj|*.cab|*.chm|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xa)
        ${pkgs.p7zip}/bin/7za x "$i"
        ;;
      *.xz)
        ${pkgs.xz}/bin/unxz -cd "$i"
        ;;
      *)
        ${pkgs.coreutils}/bin/printf "file format for '%s' not supported" "$i" >&2
        ret=$((ret + 1))
        ;;
      esac
    done
    exit $ret
  ''
