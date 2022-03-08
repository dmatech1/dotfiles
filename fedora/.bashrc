# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
function rmbak {
    rm -v *~
}

# Shell-specific history configuration.
HISTSIZE=100000
HISTTIMEFORMAT="%F %T "

# Allow Ctrl+D in non-login shells.
set +o ignoreeof


