# --- Completion ---
autoload -Uz compinit
compinit

# --- Starship prompt ---
eval "$(starship init zsh)"

# Colored ls
alias ls='eza --group-directories-first'
alias ll='eza -lh --group-directories-first'
alias la='eza -lha --group-directories-first'

# --- History settings ---
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=$HOME/.zsh_history
setopt HIST_IGNORE_DUPS       # don’t record duplicate commands
setopt SHARE_HISTORY          # share history between shells

# alias
alias vim='nvim'
alias sudo='sudo '
alias dotfiles='git --git-dir=$HOME/github/.dotfiles --work-tree=$HOME'

# Autosuggestions (ghost text based on history)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
