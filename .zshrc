# --- Completion ---
autoload -Uz compinit
compinit

# ------- up down key
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# kubectl auto complete
source <(kubectl completion zsh)
# kubectl aliases pack
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

# gnome-keyring
if [ -n "$DESKTOP_SESSION" ]; then
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh
fi

# Smarter completion behavior
setopt MENU_COMPLETE          # show a menu when multiple matches
setopt AUTO_MENU              # keep cycling through menu on repeated Tab
setopt COMPLETE_IN_WORD       # complete in the middle of a word


# --- Starship prompt ---
eval "$(starship init zsh)"

# Colored ls
alias ls='eza --group-directories-first'
alias ll='eza -lh --group-directories-first'
alias la='eza -lha --group-directories-first'

# alias
alias vim='nvim'
alias sudo='sudo '
alias dotfiles='git --git-dir=$HOME/github/.dotfiles --work-tree=$HOME'

# PATH
# .local/bin
export PATH="$HOME/.local/bin:$PATH"

# clipboard
export CLIPBOARD_HISTORY=10y   # 10 years of history

# kitten ssh
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh="kitten ssh"
fi

# Autosuggestions (ghost text based on history)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf history search
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY            # append as you go
setopt SHARE_HISTORY                # if multiple shells
setopt HIST_IGNORE_ALL_DUPS         # remove older duplicates, keep latest
# setopt HIST_IGNORE_DUPS             # skip immediate duplicate commands
# setopt HIST_FIND_NO_DUPS            # during interactive search, don’t show duplicates
fzf-history-widget() {
  # 1. Get history with epoch timestamps ('%s') and no line numbers ('-n')
  # 2. Reverse it (tac) to get oldest-first
  # 3. Use awk to deduplicate based on the command, keeping the *first* (oldest) entry
  # 4. Reverse it again (tac) to get newest-first
  # 5. Use awk to format the epoch time into a human-readable string
  local history_with_dates
  history_with_dates=$(fc -l -t '%s' -n 1 | \
    tac | \
    awk '{ cmd = substr($0, index($0, " ") + 1); if (!seen[cmd]++) print $0 }' | \
    tac | \
    awk '{ ts = $1; $1 = ""; cmd = substr($0, 2); print strftime("%Y-%m-%d %H:%M:%S", ts) "  " cmd }')

  # 1. Pipe the formatted history to fzf
  #    (--tac shows the input (newest-first) at the top)
  # 2. Use awk to strip the date/time prefix from the selected command
  BUFFER=$(echo "$history_with_dates" | \
    fzf --tac --reverse \
    | awk '{$1=""; $2=""; print substr($0,3)}') # Strips YYYY-MM-DD HH:MM:SS
  
  CURSOR=${#BUFFER}
  zle reset-prompt
}
zle -N fzf-history-widget
bindkey '^F' fzf-history-widget

#yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

