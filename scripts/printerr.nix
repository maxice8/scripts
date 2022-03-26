{ writeShellScriptBin
, coreutils
}:
writeShellScriptBin "printerr"
  ''
    [ -n "''${PRINTERR_QUIET+set}" ] && exit 0
    [ $# -lt 1 ] && exit 1
    ${coreutils}/bin/printf '\033[0m[ \033[31mERR\033[0m ] %s\n' "$*" >&2
    exit 1
  ''
