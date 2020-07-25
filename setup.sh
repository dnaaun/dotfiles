#!/bin/sh

set -e

function main() {
  THIS_DIR="$(dirname "$0")"
  THIS_DIR="$(readlink -f "$THIS_DIR")"
  if [[ -z "$THIS_DIR" ]]; then
          echo "Can't figure out what directory I'm in."
          exit 1
  fi

  setup
}

function setup() {
  mkdir -p ~/.config/

  echo "Setting up symlinks ..."
  mkdir -p ~/.config/nvim 
  rm -f ~/.config/nvim/init.vim
  ln -s "$THIS_DIR/conf/init.vim" ~/.config/nvim/init.vim

  mkdir -p ~/.config/i3 
  rm -f ~/.config/i3/config
  ln -s "$THIS_DIR/conf/i3_config" ~/.config/i3/config

  rm -f ~/.bashrc
  ln -s "$THIS_DIR/conf/bashrc" ~/.bashrc
  rm -f ~/.tmux.conf
  ln -s "$THIS_DIR/conf/tmux.conf" ~/.tmux.conf

  mkdir -p ~/.config/mypy 
  rm -f ~/.config/mypy/config
  ln -s "$THIS_DIR/conf/mypy_config" ~/.config/mypy/config

  rm -f ~/.config/flake8
  ln -s "$THIS_DIR/conf/flake8" ~/.config/flake8

  # Setup global gitignore
  git config --global core.excludesfile ~/dotfiles/conf/gitignore

  echo "Setting up vim plug  ... "
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo "Setting up fzf ..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

  # TODO: i3blocks.conf
  echo "Done! Start a new shell, restart tmux, for new config files to take effect."
}

main
