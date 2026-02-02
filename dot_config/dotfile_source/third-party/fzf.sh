# Load fzf
if [[ "$(command -v fzf)" ]] && [[ -n ${ZSH_NAME} ]]; then
    fzf_version_minor=$(fzf --version | awk '{print $1}' | cut -d. -f2)

    if [[ $fzf_version_minor -ge 47 ]]; then
        eval "$(fzf --zsh)"
    elif [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh

        if [ -f "/usr/share/doc/fzf/examples/completion.zsh" ]; then
            source /usr/share/doc/fzf/examples/completion.zsh
        fi
    fi

elif [[ "$(command -v fzf)" ]] && [[ -n ${BASH} ]]; then
    eval "$(fzf --bash)"
fi

# Configure fzf
if [ "$(command -v fzf)" ]; then
    # Preferred implementation requires fd, bat, and eza to be installed

    if [ "$(command -v fd)" ] && [ "$(command -v bat)" ] && [ "$(command -v eza)" ]; then
        show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_DEFAULT_OPTS="--preview 'bat --color=always --line-range :500 {}'"

        # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
        }

        _fzf_comprun() {
            local command="$1"
            shift

            case "${command}" in
                cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
                export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
                ssh) fzf --preview 'dig {}' "$@" ;;
                *) fzf --preview "${show_file_or_dir_preview}" "$@" ;;
            esac
        }
    fi

fi

### Old config to review
#export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#FZF_COLORS="bg+:-1,\
#fg:gray,\
#fg+:white,\
#border:black,\
#spinner:0,\
#hl:yellow,\
#header:blue,\
#info:green,\
#pointer:red,\
#marker:blue,\
#prompt:gray,\
#hl+:red"

#export FZF_DEFAULT_OPTS="--height 60% \
#--border sharp \
#--layout reverse \
#--color '$FZF_COLORS' \
#--prompt '∷ ' \
#--pointer ▶ \
#--marker ⇒"
#export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
#export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"