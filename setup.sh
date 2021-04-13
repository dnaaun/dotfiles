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
		install_things
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

install_things() {
	sudo apt install -y \
		git \
		tmux \
		neovim \
		fzf

	# Setup tmux plugin manager.
	# The if statement is to get around the "set -e" at beggining of script. If the below fails,
	# it's most likely cuz tpm already exists, so we don't want to exit the whole script.
	if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; then
		:
	else
		echo "Tmux Plugin Manager installation failed. Most likely already installed."
	fi
  if git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell; then
		:
	else
		echo "Base16 installation failed. Most likely already installed."
	fi

	# Install vim-plug for neovim. Instructions from: https://github.com/junegunn/vim-plug#neovim
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

main
