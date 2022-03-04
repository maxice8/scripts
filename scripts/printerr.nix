{ pkgs }:
pkgs.writeScriptBin "printerr"
''
#!${pkgs.rc}/bin/rc
if(test $#PRINTERR_QUIET -ne 0) {exit 0}
if(~ $#* 0) {exit 1}
${pkgs.coreutils}/bin/printf '\033[0m[ \033[31mERR\033[0m ] %s\n' $"* >[1=2]
exit 1
''
