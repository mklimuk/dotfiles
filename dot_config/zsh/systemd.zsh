#!/usr/bin/env zsh
# Systemd-specific configuration and aliases

# Service management aliases
alias sc='systemctl'
alias scu='systemctl --user'
alias scs='systemctl status'
alias scr='sudo systemctl restart'
alias scstart='sudo systemctl start'
alias scstop='sudo systemctl stop'
alias scenable='sudo systemctl enable'
alias scdisable='sudo systemctl disable'

# Journal aliases
alias jctl='journalctl'
alias jctlf='journalctl -f'
alias jctlu='journalctl -u'
