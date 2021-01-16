#!/bin/bash

set -e


# Read cmd line args
DRY_RUN_ECHO=""
for i in "$@";do
  case "$i" in
    -d|--dry-run)
      DRY_RUN_ECHO="echo"
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
		do_setup
	fi
}

# The ${DRY_RUN_ECHO:+"$DRY_RUN_ECHO"} is to work around bash passing
# an empty string as one of the arguments to xargs when DRY_RUN_ECHO
# is empty.

do_setup() {
  # Make directory structure
  find . -type d |
    grep -v '/.git.*' |
    sed 's+^./++' |
    xargs -d\\n -I{} \
     ${DRY_RUN_ECHO:+"$DRY_RUN_ECHO"} mkdir -p "$HOME/{}"

  # Delete existing files
  find . -type f |
    grep -Ev '/.git|README|setup.sh' |
    sed 's+./++' |
    xargs -I{} \
     ${DRY_RUN_ECHO:+"$DRY_RUN_ECHO"} rm -f "$HOME/{}"

  # Symlink the files in this dir
  find . -type f |
    grep -Ev '/.git|README|setup.sh' |
    sed 's+./++' |
    xargs -I{} \
      ${DRY_RUN_ECHO:+"$DRY_RUN_ECHO"} ln -s "$HOME/git/dotfiles/{}" "$HOME/{}"
}

main
