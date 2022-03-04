{ pkgs }:
pkgs.writeScriptBin "printok"
''
#!${pkgs.rc}/bin/rc
if(test $#PRINTOK_QUIET -ne 0) { exit 0 }
if(~ $#* 0) { exit 1 }
${pkgs.coreutils}/bin/printf '\033[0m[ \033[32mOK\033[0m ] %s\n' $"*
''
