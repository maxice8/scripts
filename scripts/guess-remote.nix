{ pkgs }:
pkgs.writeScriptBin "guess-remote"
''
#!${pkgs.rc}/bin/rc
if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
if(${pkgs.git}/bin/git config remote.upstream.url >[1=]) {
  echo upstream
  exit 0
}
if(${pkgs.git}/bin/git config remote.origin.url >[1=]) {
  echo origin
  exit 0
}
exit 1
''
