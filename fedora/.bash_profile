# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

# Set these variables and export them for the whole session.
declare -x PATH=$PATH:$HOME/.local/bin:$HOME/bin
declare -x PS1="\\[\\033]0;\\u@\\h: \\w\\007\\]\\[\\033[0m\\033[32m\\]\\u\\[\\033[1;32m\\]@\\[\\033[0;32m\\]\\h\\[\\033[1;32m\\]:\\[\\033[0;37m\\]\\w\\[\\033[01;37m\\]\\\$ \\[\\033[00m\\]"
declare -x QT_AUTO_SCREEN_SCALE_FACTOR=0

# Ignore Ctrl+D in login shells.
set -o ignoreeof
