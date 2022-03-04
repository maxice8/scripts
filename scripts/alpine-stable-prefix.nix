{ pkgs }:
pkgs.writeScriptBin "alpine-stable-prefix"
''
#!${pkgs.rc}/bin/rc
if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
if(~ $#* 0) *=(`{${pkgs.git}/bin/git branch --show-current})

for(branch in $*) {
  switch($branch) {
  case 3.10*
    echo 3.10
  case 3.11*
    echo 3.11
  case 3.12*
    echo 3.12
  case 3.13*
    echo 3.13
  case 3.14*
    echo 3.14
  case 3.15*
    echo 3.15
  }
}
''
