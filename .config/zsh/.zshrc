autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%21<..<%~%<<%{$fg[red]%}]%{$reset_color%}$%b "

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.config/zsh/.zsh_history

setopt autocd extendedglob nomatch menucomplete
unsetopt BEEP

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)       #include hidden files in autocomplete

bindkey -e      #emacs shortcuts mode

source "$ZDOTDIR/zsh_functions"

zsh_add_file "zsh_aliases"

zsh_add_plugin "zsh-users/zsh-autosuggestions"
bindkey '^@' autosuggest-accept 

zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Command that allows lf to set current dir on exit
lfcd() {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
# and bind new lfcd function to Ctrl+o
bindkey -s '^o' '^ulfcd^M'

# Enable fzf shell integration
if [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
    source /usr/share/fzf/shell/key-bindings.zsh
fi

work() {
    if [ -d "/mnt/c/Users" ]; then
        cd "/mnt/c/Users/dknel/ws_$1"
    else
        cd "~/ws_$1"
    fi
}

# set EDITOR to nvim if present, otherwise vim
if command -v nvim &> /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Add cargo (rust) to path if installed
if [ -d "$HOME/.cargo" ]; then
    path+=("$HOME/.cargo/bin")
fi

path+=("$HOME/scripts")
export PATH
