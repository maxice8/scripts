{ writeScriptBin
, rc
, git
, guess-remote
, printerr
, printok
, main-branch
}:
writeScriptBin "gbr"
  ''
    #!${rc}/bin/rc
    # Show git branches and switch to them
    if(! ${git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
    if(~ $#* 0) exit 1

    remote=`{${guess-remote}/bin/guess-remote}

    if(test -z $remote) exit 1

    for(spec in $*) {
      # split the spec we were given on ':'
      spec=(`` ($nl :) {echo -n $spec})

      branch=$spec(1)
      if(test $#spec -gt 1) {
        based=$spec(2)
      }

      if(${git}/bin/git rev-parse --quiet --verify $branch >[1=] >[2=]) {
        # Branch already exists, switch to it
        if(${git}/bin/git switch --quiet $branch) {
          ${printok}/bin/printok switched to ${"''''$branch''''"}
        }  else {
          ${printerr}/bin/printerr failed to switch to ${"''''$branch''''"}
        }
      } else {
        if(test $#based -gt 0) {
          if(${git}/bin/git switch --quiet --force-create $branch $remote/$based) {
            ${printok}/bin/printok switched to newly created ${"''''$branch''''"} based on ${"''''$based''''"}
          } else {
            ${printerr}/bin/printerr failed to create ${"''''$branch''''"}
          }
        } else {
          tbranch=`{${main-branch}/bin/main-branch origin}
          if(${git}/bin/git switch --quiet --force-create $branch $remote/$tbranch) {
            ${printok}/bin/printok switched to newly created ${"''''$branch''''"} based on ${"''''$tbranch''''"}
            } else {
              ${printerr}/bin/printerr failed to create ${"''''$branch''''"}
            }
        }
      }
    }
  ''
