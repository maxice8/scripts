{ pkgs }:
pkgs.writeScriptBin "fgc"
''
#!${pkgs.rc}/bin/rc
NOAPORTS_LINT=1
NOAPKBUILD_LINT=1
NOSECFIXES_LINT=1
NOPKGVERCHECK=1
exec ${pkgs.git}/bin/git commit --no-edit $*
''
