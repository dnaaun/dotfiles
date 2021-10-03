# Dotfiles
These dotfiles are for either a Linux OS, or MacOS.


## Installing

### Prerequisites
- The `neovim` setup assumes you have installed
    [`packer.nvim`](https://github.com/wbthomason/packer.nvim).
- The `tmux` setup assumes you have installed [tmux plugin
    manager](https://github.com/tmux-plugins/tpm).
- The `bash` setup assumes that you already have installed
 [`fzf`](https://github.com/junegunn/fzf).
- The `i3wm` setup assumes that you have [`picom`](https://github.com/yshui/picom) (a
compositor) installed.

### Actual Installing
The installation of the dotfiles is through symbolic links. There's a python app that
will setup the symbolic links, and, if you'd like, keep watching the dotfiles directory
and setup any new files that you will add to the dotfiles directory. The reason I wrote
this is because I found myself editing my dotfiles often, and the process of setting up
the symlinks manually every time was laborious.

Here's how you'd go about using the python app:
```bash
pip install -e setupdotfiles
python -m setupdotfiles  --daemonize --verbose
```



