# =============================================================================
# Aliases
# =============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# bat (cat replacement)
if command -v batcat &>/dev/null; then
    alias bat='batcat'
    alias cat='batcat -p --paging=never'
elif command -v bat &>/dev/null; then
    alias cat='bat -p --paging=never'
fi

# eza (ls replacement)
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -l --group-directories-first'
    alias la='eza -la --group-directories-first'
    alias lt='eza --tree --level=2'
    alias tree='eza --tree'
else
    alias ll='ls -lh'
    alias la='ls -lah'
fi

# ripgrep
if command -v rg &>/dev/null; then
    alias grep='rg'
fi

# Utility aliases
alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias h='history'
alias c='clear'

alias vi='nvim'
alias vim='nvim'
alias ff='fastfetch'
alias gl='git log --graph --oneline --decorate'
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

