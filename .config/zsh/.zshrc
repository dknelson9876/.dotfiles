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
_comp_options+=(globdots)	#include hidden files in autocomplete

bindkey -e	#emacs shortcuts mode

source "$ZDOTDIR/zsh_functions"

zsh_add_file "zsh_aliases"

zsh_add_plugin "zsh-users/zsh-autosuggestions"
bindkey '^J' autosuggest-accept

zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Use lf to switch directories and bind it to Ctrl-o
lfcd() {
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
	fi
}
bindkey -s '^o' '^ulfcd^M'

cade() {
	ssh u1126277@lab1-"$1".eng.utah.edu
}

work() {
	cd /mnt/c/Users/dknel/Workspace_"$1"
}

path+=('/home/ubuntu/scripts')
path+=('/home/ubuntu/projects/riscv/install/rv32e')
path+=('/home/ubuntu/projects/riscv/rvddt/src')
export PATH
