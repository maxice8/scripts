{ pkgs }:
pkgs.writeScriptBin "tracking-branch"
''
#!${pkgs.rc}/bin/rc
if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
if(~ $#* 0) { branch=HEAD } else { branch=$1 }

#
# If there is no tracking branch then this will error out, so supress stderr
# as it will return nothing in that case
#
_f=`{${pkgs.git}/bin/git for-each-ref --format='%(upstream:short)' `{${pkgs.git}/bin/git rev-parse --symbolic-full-name $branch}}

#
# If there is no tracking branch then we can safely use our own branch name
#
if(test -z $_f || echo -- $_f | ${pkgs.gnugrep}/bin/grep -F -q '@{u}') {
  ${pkgs.git}/bin/git branch --show-current
  exit 0
}

#
# We only reach here if we have a tracking branch, which takes the form of
# <remote>/<branch>, split by the / and take the second value
#
echo -- $_f | ${pkgs.coreutils}/bin/cut -d / -f2
''
