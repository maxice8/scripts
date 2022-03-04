{ pkgs, relative }:
let
ae-src = pkgs.writeScriptBin "ae"
''
#!${pkgs.rc}/bin/rc
if(~ $#APORTSDIR 0) APORTSDIR=$PWD
if(~ $#EDITOR 0) EDITOR=${pkgs.neovim}/bin/nvim

# Switch to it early, before we try to use git branch
cd $"APORTSDIR

# No branch given, use our current branch
if(~ $#* 0) *=`{${pkgs.git}/bin/git branch --show-current}

# Check if 
prefix=`{${relative.alpine-stable-prefix}/bin/alpine-stable-prefix $1}

if(! test -z $prefix) {
  *=(`{${pkgs.coreutils}/bin/cut -d - -f 2- <<< $"1})
}

for(repo in main community testing unmaintained non-free) {
  if(test -f $repo/$1/APKBUILD) {
    $EDITOR $repo/$1/APKBUILD ; exit $status
  }
}
${relative.printerr}/bin/printerr no aport named "$1"
'';
ac-src =
let
  runtimeInputs = [ pkgs.apk-tools pkgs.abuild ];
in
  pkgs.writeScriptBin "ac"
  ''
  #!${pkgs.rc}/bin/rc
  PATH=${pkgs.lib.makeBinPath runtimeInputs}:$PATH

  if(~ $#AX_ASUM 0) AX_ASUM=${pkgs.abuild}/bin/abuild
  if(~ $#APORTSDIR 0) APORTSDIR=$PWD
  
  # Switch to it early, before we try to use git branch
  cd $"APORTSDIR
  
  # No branch given, use our current branch
  if(~ $#* 0) *=`{${pkgs.git}/bin/git branch --show-current}
  
  # Check if 
  prefix=`{${relative.alpine-stable-prefix}/bin/alpine-stable-prefix $1}
  
  if(! test -z $prefix) {
    *=(`{${pkgs.coreutils}/bin/cut -d - -f 2- <<< $"1})
  }
  
  for(repo in main community testing unmaintained non-free) {
    if(test -f $repo/$1/APKBUILD) {
      @ {
        cd $repo/$1
        $AX_ASUM checksum
      }
      exit $status
    }
  }
  ${relative.printerr}/bin/printerr no aport named "$1"
  '';
in
pkgs.symlinkJoin {
  name = "atools";
  paths = [
    ac-src
    ae-src
  ];
}
