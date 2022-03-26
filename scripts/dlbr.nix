{ writeShellScriptBin
, git
, printerr
, printok
, tracking-branch
, gbr
}:
writeShellScriptBin "dlbr"
  ''
    # SPDX-License-Identifier: GPL-3.0-only
    # dlbr BRANCH... - Delete local and remote branches matching name
    delete_remote_branch() {
      [ $# -lt 1 ] && return 1
      if ! ${git}/bin/git push --quiet origin --delete $1 2>/dev/null; then 
        ${printerr}/bin/printerr "failed to delete remote '$1'"
        return 0
      fi
      ${printok}/bin/printok "deleted remote '$1'"
    }

    delete_local_branch() {
      [ $# -lt 1 ] && return 1

      if ! ${git}/bin/git rev-parse --quiet --verify $1 >/dev/null 2>&1; then
        return 0
      fi

      if [ "$(${git}/bin/git branch --show-current)" = "$1" ]; then
        #
        # Try to switch to the tracking branch
        # otherwise try to switch to the default branch
        #
        _full="$(${tracking-branch}/bin/tracking-branch "$1")"

        if [ "$_full" = "$1" ]; then
          #
          # We hit this in case we are deleting a branch with the same name
          # as the branch it tracks, like having origin/foo tracking upstream/foo
          # the user wants to delete origin/foo, so we can't switch to 'foo'
          #
          # In this case we default to 'master' for now, this will be solved
          # once we can detect which branch is default (master is overwhelmingly
          # the default right now)
          #
          PRINTOK_QUIET=yes ${gbr}/bin/gbr master
        else
          PRINTOK_QUIET=yes ${gbr}/bin/gbr "$_full"
        fi
      fi

      if ${git}/bin/git branch -D "$1" >/dev/null 2>&1; then
        ${printok}/bin/printok "deleted local '$1'"
      else
        ${printerr}/bin/printerr "failed to delete local '$1'"
        return 1
      fi
    }

    ${git}/bin/git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1
    [ $# -lt 1 ] && exit 1

    # The user might want to delete more than 10 branches
    # most servers have a maximum amount of connections capped
    # at 10 so process 10 of them at once
    connections=0

    for i in "$@"; do
      while [ $connections -gt 9 ]; do sleep 1; done
  
      {
        # keep track of remote connections, we don't
        # want to go over the limit
        if [ -z "''${DLBR_LOCAL+set}" ]; then
          connections=$((connections + 1))
          delete_remote_branch "$i"
          connections=$((connections - 1))
        fi
        delete_local_branch "$i"
      }&
    done
    wait
  ''
