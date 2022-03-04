{ pkgs }:
pkgs.writeScriptBin "unpk"
''
#!${pkgs.rc}/bin/rc
if(~ $#* 0) {
  echo -- unpk '<archives...>'
  exit 0
}

ret=0
for(i in $*){
  switch($i){
  case *.tar.bz2 *.tar.gz *.tar.xz *.tbz2 *.tgz *.txz *.tar *.xbps *.apk
    ${pkgs.gnutar}/bin/tar xfv $i
  case *.lzma
    ${pkgs.lzma}/bin/unlzma -cd $i
  case *.bz2
    ${pkgs.bzip2}/bin/bunzip2 -cd $i	
  case *.rar
    ${pkgs.unrar}/bin/unrar x -ad $i
  case *.gz
    ${pkgs.gzip}/bin/gunzip $i
  case *.zst
    ${pkgs.zstd}/bin/unzstd -cq $i
  case *.zip
    ${pkgs.unzip}/bin/unzip $i
  case *.Z
    ${pkgs.gzip}/bin/uncompress -c $i
  case *.7z *.arj *.cab *.chm *.dmg *.iso *.lzh *.msi *.rpm *.udf *.wim *.xa
    ${pkgs.p7zip}/bin/7za x $i
  case *.xz
    ${pkgs.xz}/bin/unxz -cd $i
  case *
    echo -- file format for ${"''''$i''''"}  not supported >[1=2]
    ret=`{expr $ret + 1}
  }
}
exit $ret
''
