{ writeShellScriptBin
, git
}:
writeShellScriptBin "fgc"
  ''
    NOAPORTS_LINT=1 \
    NOAPKBUILD_LINT=1 \
    NOSECFIXES_LINT=1 \
    NOPKGVERCHECK=1 \
    exec ${git}/bin/git commit --no-edit $*
  ''
