alias ls="eza --icons=always --git"
alias ll='eza -al'
alias tree='eza --tree'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias gl='git log --graph --oneline --decorate'
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
