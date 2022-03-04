{ pkgs, relative }:
pkgs.writeScriptBin "gbr"
''
#!${pkgs.rc}/bin/rc
# Show git branches and switch to them
if(! ${pkgs.git}/bin/git rev-parse --is-inside-work-tree >[2=] >[1=]) exit 1
if(~ $#* 0) exit 1

remote=`{${relative.guess-remote}/bin/guess-remote}

if(test -z $remote) exit 1

for(spec in $*) {
  # split the spec we were given on ':'
  spec=(`` ($nl :) {echo -n $spec})

  branch=$spec(1)
  if(test $#spec -gt 1) {
    based=$spec(2)
  }

  if(${pkgs.git}/bin/git rev-parse --quiet --verify $branch >[1=] >[2=]) {
    # Branch already exists, switch to it
    if(${pkgs.git}/bin/git switch --quiet $branch) {
      ${relative.printok}/bin/printok switched to ${"''''$branch''''"}
    }	else {
      ${relative.printerr}/bin/printerr failed to switch to ${"''''$branch''''"}
    }
  } else {
    if(test $#based -gt 0) {
      if(${pkgs.git}/bin/git switch --quiet --force-create $branch $remote/$based) {
        ${relative.printok}/bin/printok switched to newly created ${"''''$branch''''"} based on ${"''''$based''''"}
      } else {
        ${relative.printerr}/bin/printerr failed to create ${"''''$branch''''"}
      }
    } else {
      _base=`{${relative.alpine-stable-prefix}/bin/alpine-stable-prefix $branch}
      if(! ~ $#_base 0) {
        if(${pkgs.git}/bin/git switch --quiet --force-create $branch $remote/$_base-stable) {
          ${relative.printok}/bin/printok switched to newly created ${"''''$branch''''"} based on ${"''''$_base-stable''''"}
        } else {
          ${relative.printerr}/bin/printer failed to create ${"''''$branch''''"}
        }
      } else {
        tbranch=`{${relative.main-branch}/bin/main-branch origin}
        if(${pkgs.git}/bin/git switch --quiet --force-create $branch $remote/$tbranch) {
          ${relative.printok}/bin/printok switched to newly created ${"''''$branch''''"} based on ${"''''$tbranch''''"}
        } else {
          ${relative.printerr}/bin/printerr failed to create ${"''''$branch''''"}
        }
      }
    }
  }
}
''
