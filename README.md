# NOTE: 
This is definitely a "note-to-self" kinda page, don't expect a coherent and meaningful
README targeted at a general audience (i.e., an audience that's not me).

# Steps to do before running `setup.sh`

Install `picom`. Last I checked, only way is to [build from source](https://github.com/yshui/picom).

Also install, `fd-find`, `ripgrep`

## Install i3blocks (and i3wm of course)
```bash
sudo apt-get install i3blocks
```

## Install Tmux Package Manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Install powerline fonts to prevent tmux being ugly when using the powerline plugin
```bash
sudo apt-get install fonts-powerline
```
# TODOs
 - Figure out why `Cmus` doesn't obey MPRIS so that we don't have to launch
   a process (`cmus-cremote`) to control music.


# Other requirements
## `Litecli` 
`pip install litecli`

## Install `fzf`
 - The version of `fzf` packaged in Ubuntu's apt repos is a few versions behind, so
     install from Git using instructions.

## Other
 - bat
 - delta
 - exa
 - cht.sh
 - entr
 - sd
 - broot


