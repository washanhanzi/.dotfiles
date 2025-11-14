# .dotfiles

### 💡 Core Concept

You create a "bare" Git repository at `~/.dotfiles`. This directory itself *is* the Git database (it contains `objects`, `refs`, `config`, etc., but no `.git` subdirectory). You then use a shell alias (`dotfiles`) to tell Git to use this database while using your `$HOME` directory as the working tree.

  * **Git Database (git-dir):** `$HOME/.dotfiles`
  * **Working Tree (work-tree):** `$HOME`

-----

### 1. First Machine Setup (Creation)

```bash
# 1. Create the bare repository
git init --bare $HOME/.dotfiles

# 2. Define the alias in your shell's rc file (e.g., .zshrc, .bashrc)
# This alias is the key to the whole system.
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
echo "alias dotfiles='\''git --git-dir=$HOME/.dotfiles --work-tree=$HOME'\''' >> ~/.zshrc

# 3. Configure the repo to ignore all untracked files in $HOME
# (Otherwise 'dotfiles status' is unusable)
dotfiles config status.showUntrackedFiles no

# 4. Add a remote (optional, but needed for backup/sync)
dotfiles remote add origin git@github.com:<you>/dotfiles.git

# 5. Start tracking your files
dotfiles add .zshrc .config/nvim/init.vim
dotfiles commit -m "Initial dotfiles"
dotfiles push -u origin main
```

-----

### 2. New Machine Setup (Cloning)

```bash
# 1. Clone the bare repo (this only downloads the database)
git clone --bare git@github.com:<you>/dotfiles.git $HOME/.dotfiles

# 2. Define the alias (same as before)
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
echo "alias dotfiles='\''git --git-dir=$HOME/.dotfiles --work-tree=$HOME'\''' >> ~/.zshrc

# 3. IMPORTANT: Source your rc file or open a new shell to use the new alias
source ~/.zshrc

# 4. Try to check out your files
dotfiles checkout
```

#### The "Checkout Gotcha"

Your `dotfiles checkout` command will almost certainly **fail** with an error:

> `error: The following untracked working tree files would be overwritten...`
> `   .bashrc `
> `   .profile `

This is normal. The new machine has default config files that Git won't overwrite.

**The Fix:**

```bash
# 5. Back up or remove the conflicting files listed in the error
mv $HOME/.bashrc $HOME/.bashrc.bak
mv $HOME/.profile $HOME/.profile.bak

# 6. Run checkout again. It will now succeed.
dotfiles checkout

# 7. Apply the config to hide untracked files (just like on the first machine)
dotfiles config status.showUntrackedFiles no
```

-----

### 3. Day-to-Day Use

You **never** run normal `git` commands for your dotfiles. You **always** use your `dotfiles` alias.

```bash
# Check status
dotfiles status

# Add a new file
dotfiles add .config/kitty/kitty.conf

# Commit and push
dotfiles commit -m "Add kitty config"
dotfiles push
```
