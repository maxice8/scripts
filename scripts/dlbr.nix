{ pkgs, relative }:
pkgs.writeScriptBin "dlbr"
  ''
    #!${pkgs.rc}/bin/rc
    # SPDX-License-Identifier: GPL-3.0-only
    # dlbr BRANCH... - Delete local and remote branches matching name
    fn delete_remote_branch {
      if(~ $#* 0) return 1
      if(! ${pkgs.git}/bin/git push --quiet origin --delete $1 >[2=]) {
        ${relative.printerr}/bin/printerr failed to delete remote ${"''''$1''''"}
        return 0
      }
      ${relative.printok}/bin/printok deleted remote ${"''''$1''''"}
    }

    fn delete_local_branch {
      if(~ $#* 0) return 1

      if(! ${pkgs.git}/bin/git rev-parse --quiet --verify $1 >[2=] >[1=]) {
        return 0
      }

      if(test `{${pkgs.git}/bin/git branch --show-current} = $1) {
        #
        # Try to switch to the tracking branch
        # otherwise try to switch to the default branch
        #
        _full=`{${relative.tracking-branch}/bin/tracking-branch $1}

        if(test $_full = $1) {
          #
          # We hit this in case we are deleting a branch with the same name
          # as the branch it tracks, like having origin/foo tracking upstream/foo
          # the user wants to delete origin/foo, so we can't switch to 'foo'
          #
          # In this case we default to 'master' for now, this will be solved
          # once we can detect which branch is default (master is overwhelmingly
          # the default right now)
          #
          PRINTOK_QUIET=yes ${relative.gbr}/bin/gbr master
        } else {
          PRINTOK_QUIET=yes ${relative.gbr}/bin/gbr $_full
        }
      }

      if(${pkgs.git}/bin/git branch -D $1 >[2=] >[1=]) {
        ${relative.printok}/bin/printok deleted local ${"''''$1''''"}
      } else {
        ${relative.printerr}/bin/printerr failed to delete local ${"''''$1''''"}
        return 1
      }
    }

    if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
    if(~ $#* 0) exit 1

    # The user might want to delete more than 10 branches
    # most servers have a maximum amount of connections capped
    # at 10 so process 10 of them at once
    connections=0

    for(i in $*) {
      while(test $connections -gt 9) sleep 1
  
      {
        # keep track of remote connections, we don't
        # want to go over the limit
        if(~ $#DLBR_LOCAL 0) {
          connections=`{expr $connections + 1}
          delete_remote_branch $i
          connections=`{expr $connections - 1}
        }
        delete_local_branch $i 
      }&
    }
    wait
  ''
