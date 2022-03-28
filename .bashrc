# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FDCMD=fdfind
  BATCMD=batcat
else
  FDCMD=fd
  BATCMD=bat
fi

# Apparently I need to do this to get executables from both M1 and non M1 homebrew in my $PATH
PATH=/usr/local/bin/:/opt/homebrew/bin/:$PATH

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Expand shell variables on bash-compleition
if shopt | grep direxpand > /dev/null; then
	shopt -s direxpand
fi

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# With this, multiline commands are not translated into semicolon-separated
# commands before being written to history.
shopt -s lithist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Discovered that this step takes a lot of time. If ever you feel like
# procasti-optimizing your bash startup time, you know where to look! 
for dir in {$HOME/.bash_completion.d/,/opt/homebrew/etc/bash_completion.d,/usr/local/etc/bash_completion.d}; do
  for comp_file in $dir/*; do
    source "$comp_file"
  done
done

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Some systems still have old vi by default
alias vi=vim

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	eval "$("$BASE16_SHELL/profile_helper.sh")"

# UTF8 issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
alias tmux='tmux -u'

# I don't know where this is getting set, but I need to unset it
export PYTHONPATH=
export PYTHONBREAKPOINT=ipdb.set_trace


# Source customizations that differ across machines
if [[ -f ~/.bashrc_specific  ]]; then
    source ~/.bashrc_specific
    :
fi

# Show virtual env in custom prompt
# https://stackoverflow.com/a/20026992
function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
        
        # Strip out everything after the first hyphen.
        # Poetry creates names with random strings after a hyphen to make things unique.
        venv=${venv%%-*}
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv) "

} 
# disable the default virtualenv prompt change
# export VIRTUAL_ENV_DISABLE_PROMPT=1 

# # Color prompt according to exit code: https://stackoverflow.com/a/16715681
# PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

# set_ps1() {
#     local EXIT="$?"             # This needs to be first
     
#     # Green color code
#     local Gre='\[\e[0;32m\]'

#     VENV="\$(virtualenv_info)"; 
#     PS1="${Gre}$VENV\u@\h:"

#     local RCol='\[\e[0m\]'

#     local Red='\[\e[0;31m\]'
#     local BBlu='\[\e[1;34m\]'

#     if [ $EXIT != 0 ]; then
#         PS1+="${Red}\w\$ ${RCol}"      # Add red if exit code non 0
#     else
#         PS1+="${BBlu}\w\$ ${RCol}"
#     fi
# }

alias python=python3
alias python2=python

auto_change_venv() {
  # Check all parents from $PWD until /
  parent="$PWD"
  found_venv=0
  while  ((${#parent} > 1 )); do
    if [ -d "$parent/.venv" ]; then
      found_venv=1
      break
    fi
    parent=${parent%/*} # (shortest match) parameter subsiution ${param%word}
  done

  if [[  ! -z "$VIRTUAL_ENV" && ("$(which python)" != "$parent/.venv/bin/python") ]];  then
    # TODO: If checking whether 'deactivate' is actually 
    # valid right now would be better (possibly), we should do it.
    deactivate  > /dev/null 2>&1
  fi

  if [ $found_venv = 0 ]; then
    return
  fi
  
  # shellcheck disable=SC1090
  source "$parent/.venv/bin/activate";
}

function cd() {
  builtin cd "$@";
  auto_change_venv
}

# Call it on shell load
auto_change_venv

# TODO: Not needed/called since we're on a starship now.
# __prompt_command() {
#   set_ps1 # This needs to be first to change color based on return value
#   auto_change_venv
# }

export EDITOR=nvim

# Define a shortcut to copy to clipboard
alias copy="xclip -selection clipboard"

# DISABLED: Create / go to tmux session on launch.
# Attach to "def" (for default) tmux session if it already exists
# tmux attach -t def &> /dev/null

# Create a session if not
# if [[ $? != 0 && ! $TERM =~ screen ]]; then
    # tmux new -s def
# fi

## Aliases
# Taskwarrior 
alias t=task
complete -F _complete_alias t 
alias tw=timew
complete -F _complete_alias tw
alias x=xsv
complete -F _complete_alias x
alias xs="xsv select"
alias xh="xsv headers" 
# lowercase
alias lower="tr '[:upper:]' '[:lower:]'"
# Include hidden files by default
alias fd="$FDCMD -H"
alias bat="$BATCMD"
complete -F _complete_alias fd

# NO idea why I have this here.
alias bash="bash --noprofile"

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

## jq
# Setup an alias for previewing JSON
jeqq () {
  jq -C "$@" | less -r
}


## Load .tmuxp sessions automatically if they are in the current directory
tm () {
  if [ -f ".tmuxp.yaml" ]; then
    tmuxp load -y .tmuxp.yaml
  else
    sess_name="${PWD##*/}"
    if tmux list-sessions | grep "$sess_name" > /dev/null; then
      tmux attach-session -t "$sess_name"
    else
      tmux new-session -s "$sess_name"
    fi
  fi
}

if command -v nvim > /dev/null; then
  # Use neovim as a pager, if it's available
  # vless is a script in .local/bin/
  #export PAGER=vless
  #export MANPAGER="vless -c 'set filetype=man'"
  :
fi

# Auto start tmux
if [ -z "$TMUX" ]; then
  tm
fi

# Doing --path instead of - will break some commmands (pyenv shell).  https://github.com/pyenv/pyenv/issues/1906#issuecomment-835027647
# But aint nobody got time to fix something they don't use.

# This section must come below the sourcing of /etc/bash/completion
# above
export FZF_DEFAULT_COMMAND="$FDCMD --type f --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Fzf completion when typing in ** doesn't use $FZF_DEFAULT_COMMAND. The below
# is necessary.
_fzf_compgen_path() {
  command $FDCMD . --hidden "$1" 2>/dev/null
}
_fzf_compgen_dir() {
  command $FDCMD . --type d --hidden "$1" 2>/dev/null
}

# If we're on macos
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

CARGO_PATH="$HOME/.cargo/env"
[ -f $CARGO_PATH ] && source $CARGO_PATH;

# On ubuntu
RVM_INIT=/etc/profile.d/rvm.sh
[ -f $RVM_INIT ] && source $RVM_INIT;

# We need to set this here (despite having an .inputrc saying the same thing)
# because fzf bindings get messed up if we set -o vi after we souurce the fzf bindings scripts.
set -o vi
# If we're on ubuntu
FZF_BASH_BINDINGS=/usr/share/doc/fzf/examples/key-bindings.bash 
FZF_COMPLETION_BINDINGS=/usr/share/doc/fzf/examples/completion.bash
if [[ -f $FZF_COMPLETION_BINDINGS ]]; then
  source $FZF_BASH_BINDINGS
  source $FZF_COMPLETION_BINDINGS
fi


# On ubuntu, gem requires sudo if this is nto there.
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin/:$PATH

# Aint nobody got time for that (neither does anyone(read: me) have a basic understanding of maintaining a secure system, it seems)
export HOMEBREW_NO_AUTO_UPDATE=1

# MacOS has annoying "welcome" messages when I open bash if I don't do this.
export BASH_SILENCE_DEPRECATION_WARNING=1


alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias mbrew='arch -arm64 /opt/homebrew/bin/brew'


# Will ad-hoc PATH modifications ever end?
export PATH="/usr/local/opt/node@14/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/node@14/lib"
export CPPFLAGS="-I/usr/local/opt/node@14/include"

# Apparently, they won't.
export PATH="/Users/davidat/Library/Python/3.8/bin/:$PATH" # MacOS's "command line tools" installation location for py3
export PATH="/opt/homebrew/Cellar/ruby@2.7/2.7.5/bin/:$PATH" # Homebrew installed ruby.
# export PATH="/usr/local/Cellar/ruby@2.7/2.7.4/bin/:$PATH" # Homebrew installed ruby.


# Bandaid for broken python (PATH) setup
alias httpie='python3 -m httpie'

export PATH="/Users/davidat/Library/Python/3.9/bin:$PATH"
. "$HOME/.cargo/env"


# Ruby
alias be='bundle exec'

if [[ -d $HOME/go/bin/ ]]; then
  PATH="$HOME/go/bin:$PATH"
fi

# Acc to instructions spewed out after brew install heroku, to enable heroku 
# bash completion, I need to follow instructions at https://docs.brew.sh/Shell-Completion,
# so low and behold:
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Scripts in dotfiles/bin/
for bin_dir in {$HOME/git/dotfiles/bin,$HOME/.local/bin}; do
	if [[ -d "$bin_dir"  ]]; then
	    export PATH=$bin_dir:$PATH
	fi
done

alias luamake=/Users/davidat/src/lua-language-server/3rd/luamake/luamake

eval "$(starship init bash)"
eval "$(zoxide init bash)"
# eval "$(complete_bundle_bash_command init)" # This broke at some point. Not sure why.

##### Use fzf to make gitting easier ####
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
  cut -c4- | sed 's/.* -> //'
}

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

##### Now for the keybindings
if [[ $- =~ i ]]; then
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(_gf)\n"'
  bind '"\C-g\C-b": "$(_gb)\n"'
  bind '"\C-g\C-t": "$(_gt)\n"'
  bind '"\C-g\C-h": "$(_gh)\n"'
  bind '"\C-g\C-r": "$(_gr)\n"'
  bind '"\C-g\C-s": "$(_gs)\n"'
fi

# To get autocomplete to work for `exa`, `_filedir` had to be defined, which  necessitated one/both of
# `mbrew uninstall bash-completion && mbrew install bash-completion@2` and
# `mbrew install bash` (upgrading bash).
# After that, it turns out I need to source this to get`_filedir`
source /opt/homebrew/share/bash-completion/bash_completion


# Docker doesn't work without this on MacOS
# https://stackoverflow.com/questions/64221861/an-error-failed-to-solve-with-frontend-dockerfile-v0
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0
