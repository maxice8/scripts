{ pkgs }:
pkgs.writeScriptBin "main-branch"
  ''
    #!${pkgs.rc}/bin/rc
    if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
    if(~ $#* 0) *=(origin)

    ref=`{${pkgs.git}/bin/git symbolic-ref refs/remotes/$1/HEAD >[2=] || echo master}
    ref=`{${pkgs.coreutils}/bin/basename $ref >[2=]}
    echo $ref
  ''
