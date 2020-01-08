#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "$HOME/.config/zprezto/init.zsh" ]]; then
  source "${HOME}/.config/zprezto/init.zsh"
fi

# Customize to your needs...

# Load Kitty

autoload -Uz compinit
compinit
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# Load zmv

autoload zmv
