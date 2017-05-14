# The following lines were added by compinstall

#zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/haris/.zshrc'

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt completeinword
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
setopt SHARE_HISTORY
setopt APPEND_HISTORY
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
hist_find_no_dups
# End of lines configured by zsh-newuser-install

# Colors and prompt
autoload -Uz colors && colors
autoload -Uz promptinit
promptinit
if [[ -x "`whence -p dircolors`" ]]; then
  eval `dircolors`
  alias ls='ls --color=auto'
else
  alias ls='ls -F'
fi

# Editor
export EDITOR=vimS

PROMPT="%F{green}[%2~]%F{blue}[$]%f "

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"