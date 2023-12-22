#!/bin/bash
# Install script for dotfiles
dotfiles_dir="$HOME"/dotfiles
update_rc_file() {
cat <<EOF >> "$HOME"/.zshrc
# Source dotfiles
source "$src_dir"/functions.sh
source "$src_dir"/aliases.sh
set -a
source "$src_dir"/env.env
# Add custom dotfiles
# Add functions
[ -f $HOME/$1-src/functions ] && source $HOME/$1-src/functions
# Add aliases
[ -f $HOME/$1-src/aliases ] && source $HOME/$1-src/aliases
# Add environment variables
[ -f $HOME/$1-src/env.env ] && source $HOME/$1-src/env.env
[ -f $HOME/$1-src/ecr.env.ecr ] && decrypt $HOME/$1-src/ecr.env.ecr
[ -f $HOME/$1-src/ecr.env ] && source $HOME/$1-src/ecr.env && rm $HOME/$1-src/ecr.env
set +a
EOF
}
# Check if the dotfiles directory exists otherwise clone the repo
if [ ! -d "$dotfiles_dir" ]; then
    echo -e "The dotfiles directory does not exist. Attempting to clone repo..."
    cd "$HOME" || exit
    git clone git@github.com:ec-intl/dotfiles.git
    cd "$dotfiles_dir" || exit
fi
# Pull the latest changes from the repo
echo -e "Pulling latest changes from the repo..."
cd "$dotfiles_dir" || exit
git pull origin master

# Check if the first argument is either 'zsh' or 'bash'
if [ "$1" != "zsh" ] && [ "$1" != "bash" ]; then
    echo -e "The $1 shell is unrecognized. The first argument must be either 'zsh' or 'bash'."
    exit 1
fi

echo -e "Installing $1...\n"
src_dir="$dotfiles_dir"/src/"$1"
update_rc_file "$1"

# shellcheck disable=SC1090
source "$HOME"/."$1"rc
kmsg "Installation complete."

