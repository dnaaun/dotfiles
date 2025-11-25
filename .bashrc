################ A way to debug slow bashrc ####################
# https://mdjnewman.me/2017/10/debugging-slow-bash-startup-files/
# open file descriptor 5 such that anything written to /dev/fd/5
# is piped through ts and then to /tmp/timestamps
# exec 5> >(ts -i "%.s" >> /tmp/timestamps)

# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
# export BASH_XTRACEFD="5"

# Enable tracing
# set -x xtrace
################                            ####################

# Fig pre block. Keep at the top of this file.
# # If not running interactively, don't do anything
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
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi


# Doens't look like I'll need this on linux.
source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
source /opt/homebrew/etc/bash_completion.d/git-completion.bash

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

## jj/jujutsu aliases
alias jd='jj diff'
alias js='jj status'

# Some systems still have old vi by default
alias vi=vim

# UTF8 issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
alias tmux='tmux -u'

# I don't know where this is getting set, but I need to unset it
export PYTHONPATH=
export PYTHONBREAKPOINT=pdb.set_trace



# Show virtual env in custom prompt
# https://stackoverflow.com/a/20026992
# function virtualenv_info(){
#     # Get Virtual Env
#     if [[ -n "$VIRTUAL_ENV" ]]; then
#         # Strip out the path and just leave the env name
#         venv="${VIRTUAL_ENV##*/}"
        
#         # Strip out everything after the first hyphen.
#         # Poetry creates names with random strings after a hyphen to make things unique.
#         venv=${venv%%-*}
#     else
#         # In case you don't have one activated
#         venv=''
#     fi
#     [[ -n "$venv" ]] && echo "(venv:$venv) "

# } 
# disable the default virtualenv prompt change
# export VIRTUAL_ENV_DISABLE_PROMPT=1 

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
# lowercase
alias lower="tr '[:upper:]' '[:lower:]'"
# Include hidden files by default
alias bat="$BATCMD"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias fd="$FDCMD -H"
  complete -F _complete_alias fd
fi

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
# LETSSEE: If this helps speed.
# jeqq () {
#   jq -C "$@" | less -r
# }


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

# Auto start tmux
# if [ -z "$TMUX" ]; then
#   tm
# fi

FZF_CTRL_T_COMMAND=$FDCMD' . --hidden 2>/dev/null'

# The below is necessary, because I want to include hidden files by default.
_fzf_compgen_path() {
  command $FDCMD . --hidden "$1" 2>/dev/null
}
_fzf_compgen_dir() {
  command $FDCMD . --type d --hidden "$1" 2>/dev/null
}

# If we're on macos
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
# I just installed it using homebrew, so
eval "$(fzf --bash)"


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



# Aint nobody got time for that (neither does anyone(read: me) have a basic understanding of maintaining a secure system, it seems)
export HOMEBREW_NO_AUTO_UPDATE=1

# MacOS has annoying "welcome" messages when I open bash if I don't do this.
export BASH_SILENCE_DEPRECATION_WARNING=1


alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias mbrew='arch -arm64 /opt/homebrew/bin/brew'


# Bandaid for broken python (PATH) setup
alias httpie='python3 -m httpie'



# Ruby
alias be='bundle exec'
alias wbe='watchexec  -n --restart --no-process-group --exts  rb -- bundle exec'

# LETSSEE: If this helps speed.
# if [[ -d $HOME/go/bin/ ]]; then
#   PATH="$HOME/go/bin:$PATH"
# fi

# Acc to instructions spewed out after brew install heroku, to enable heroku 
# bash completion, I need to follow instructions at https://docs.brew.sh/Shell-Completion,
# so lo and behold:
# LETSSEE: If this helps speed.
# if type brew &>/dev/null
# then
#   HOMEBREW_PREFIX="$(brew --prefix)"
#   if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
#   then
#     source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
#   else
#     for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
#     do
#       [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
#     done
#   fi
# fi

export RUST_BACKTRACE=1
PS1='$(~/git/dotfiles/bash_prompt/target/release/bash_prompt)'

# To get autocomplete to work for `exa`, `_filedir` had to be defined, which  necessitated one/both of
# `mbrew uninstall bash-completion && mbrew install bash-completion@2` and
# `mbrew install bash` (upgrading bash).
# After that, it turns out I need to source this to get`_filedir`
# source /opt/homebrew/share/bash-completion/bash_completion


# Docker doesn't work without this on MacOS
# https://stackoverflow.com/questions/64221861/an-error-failed-to-solve-with-frontend-dockerfile-v0
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

export PNPM_HOME="/Users/davidat/Library/pnpm"


PATH=\
$HOME/.local/bin:\
/opt/homebrew/opt/postgresql@13/bin:\
$PNPM_HOME:\
/opt/homebrew/opt/pnpm@8/bin:\
/opt/homebrew/opt/findutils/libexec/gnubin:\
$HOME/.yarn/bin:\
$HOME/go/bin:\
/opt/homebrew/opt/libpq/bin:\
/opt/homebrew/Cellar/ruby@2.7/2.7.6/bin:\
/Users/davidat/Library/Python/3.9/bin:\
/opt/homebrew/bin:\
/usr/local/bin:\
$HOME/git/dotfiles/bin_dir:\
$HOME/.gem/bin:\
$HOME/.swiftly/bin:\
$PATH

# Source customizations that differ across machines
source ~/.bashrc_specific

alias latest_branches="git for-each-ref --sort=-committerdate refs/heads/ | choose 2"


# Switch easily to a tmux session using fzf from bash
function ta() {
  tmux attach-session -t "$(tmux list-sessions -F '#{session_name}' | fzf)"
}

function __fzf_recent_git_branches__() {
  git reflog |
   rg 'checkout: moving from' |  # Filter
   rg -o '\S+$' | # Grep to branch name
   awk '!x[$0]++' | # Remove duplicates
   fzf --height=40%
}

# Switch among recently-checkout-branches. Based off of: https://gist.github.com/jordan-brough/48e2803c0ffa6dc2e0bd#file-git-recent-L74
function gcb() {
  git checkout "$(__fzf_recent_git_branches__)"
}


# A function to imitate how fzf binds Ctrl-T to select files, but for git branches.
gcb-widget ()
{
    local selected="$(__fzf_recent_git_branches__)";
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}";
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}


bind -m emacs-standard -x '"\C-gb": gcb-widget'
bind -m vi-command -x '"\C-gb": gcb-widget'
bind -m vi-insert -x '"\C-gb": gcb-widget'

# Credit: GPT-4
function __git_fzf_commit_hash() {
  git log --pretty=format:"%h %s" |
    fzf --height 40% --reverse --border --prompt 'Select commit: ' |
    cut -d' ' -f1
}

function __insert_git_fzf_commit_hash() {
  local selected="$(__git_fzf_commit_hash)";
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}";
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

bind -m emacs-standard -x '"\C-gc": __insert_git_fzf_commit_hash'
bind -m vi-command -x '"\C-gc": __insert_git_fzf_commit_hash'
bind -m vi-insert -x '"\C-gc": __insert_git_fzf_commit_hash'

PATH=$PATH:$HOME/git/rsq/target/debug/

# Set vi mode
set -o vi

alias python=python3
alias python2=python


# ==== BEGIN: Nice little things ====
cur_commit_hash() {
  git rev-parse HEAD
}
# ==== END: Nice little things ====

# "$HOME/.cargo/env"

# eval `fnm env`

# source <(frum init)
eval "$(rbenv init - bash)"

#  This causes errors right now when cd-ing into a directory with a .nvmrc
#  file.
# eval "$(fnm env --use-on-cd)"

most_recent_mp3_as_tex() {
  $FDCMD  '.*(mp3|MP3)$' ~/Downloads/  | xargs -n1 -d\\n stat -f "%m %N" | sort -rn | sd '^[0-9]*' '' | fzf | sed 's/\.[^.]*$/.tex/'  | sed -E 's/^.*\/(.*)$/\1/' | sed 's/[^a-zA-Z0-9.-]/_/g'
}
alias be="bundle exec"

# GPT-4 wrote this.
# Watch files specified by a regex passed to fd, and then run commands.
# The first arg is that regex, the remaining args is the command.
watcher() {
  local regex="$1"
  shift

  # Run the arguments first
  "$@"

  trap 'break' INT
  while true; do
    fd "$regex" | xargs inotifywait -e modify
    echo "Watch interrupted, will run now ...."
    "$@"
  done
}

# pnpm
export PNPM_HOME="/Users/davidat/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#


# export PAGER=moar Thanks ahkohd for the tip!
export PAGER=nvim_pager

eval "$(zoxide init bash)"


source <(jj util completion bash)

eval "$(direnv hook bash)" # for bash

