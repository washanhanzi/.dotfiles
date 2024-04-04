alias vim=nvim
alias finder="/usr/bin/open"
alias cd=z

# go
export PATH=$HOME/go/bin:$PATH

# vscode
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

# pnpm
export PNPM_HOME="/Users/jingyu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# zoxide
eval "$(zoxide init zsh)"
