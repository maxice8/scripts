{ writeShellScriptBin
, coreutils
}:
writeShellScriptBin "printok"
  ''
    [ -n "''${PRINTOK_QUIET+set}" ] && exit 0
    [ $# -lt 1 ] && exit 1
    ${coreutils}/bin/printf '\033[0m[ \033[32mOK\033[0m ] %s\n' "$*"
  ''
