#!/bin/bash

set -e


# Read cmd line args
for i in "$@";do
  case "$i" in
    -d|--dry-run)
      DRY_RUN="TRUE"
      shift
      ;;
  esac
done

main() {
  
  THIS_DIR="$(dirname "$0")"

	if [[ -z "$THIS_DIR" ]]; then
		echo "Can't determine the directory which this is getting called from."
		echo "Probably has to do with how this script was invoked."
	else
		setup_symlinks
	fi
}

# The ${DRY_RUN_ECHO:+"$DRY_RUN_ECHO"} is to work around bash passing
# an empty string as one of the arguments to xargs when DRY_RUN_ECHO
# is empty.

setup_symlinks() {
  # Make directory structure
  find . -type d |
    grep -v '/.git.*' |
    sed 's+^./++' |
    xargs -d\\n -I{} \
     ${DRY_RUN:+"echo"} mkdir -p "$HOME/{}"

  # Delete existing files
  find . -type f |
    grep -Ev '/.git|README|setup.sh' |
    sed 's+./++' |
    xargs -I{} \
     ${DRY_RUN:+echo} rm -f "$HOME/{}"

  # Symlink the files in this dir
  find . -type f |
    grep -Ev '/.git|README|setup.sh' |
    sed 's+./++' |
    xargs -I{} \
      ${DRY_RUN:+echo} ln -s "$HOME/git/dotfiles/{}" "$HOME/{}"
}

main
