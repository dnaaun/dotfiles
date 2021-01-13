#!/bin/bash

# TODO: Add .ignore files for rg to make this faster.
# https://www.reddit.com/r/i3wm/comments/c17m5e/launcher_to_open_files_with_xdgopen_using_fzf/
xdg-open "$(rg --no-messages --files ~/GoogleDrive ~/papers ~/git ~/Documents ~/Music ~/Downloads ~/Bilder ~/Dockumente  \
     | rofi -threads 0 \
    -theme-str "#window { width: 900;}" \
    -dmenu -sort -sorting-method fzf -i -p "find")"
