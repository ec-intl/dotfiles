#!/usr/bin/env sh

# Install script for dotfiles
# Check if the first argument is either 'zsh' or 'bash'
if [ "$1" != "zsh" ] && [ "$1" != "bash" ]; then
  echo -e "The $1 shell is unrecognized. The first argument must be either 'zsh' or 'bash'."
  exit 1
fi
dotfiles_dir="${HOME}/dotfiles"
src_dir="${dotfiles_dir}/src/${1}"
update_rc_file() {
cat <<EOF >> "${HOME}/.zshrc"
# Source dotfiles_dirs
source "${src_dir}/functions.sh"
source "${src_dir}/aliases.sh"
set -a
source "${src_dir}/env.env"
# Add custom dotfiles
# Add functions
[ -f ${HOME}/${1}-src/functions.sh ] && source ${HOME}/${1}-src/functions.sh
# Add aliases
[ -f ${HOME}/${1}-src/aliases.sh ] && source ${HOME}/${1}-src/aliases.sh
# Add environment variables
[ -f ${HOME}/${1}-src/env.env ] && source ${HOME}/${1}-src/env.env
[ -f ${HOME}/${1}-src/ecr.env.ecr ] && decrypt ${HOME}/${1}-src/ecr.env.ecr
[ -f ${HOME}/${1}-src/ecr.env ] && source ${HOME}/${1}-src/ecr.env && rm ${HOME}/${1}-src/ecr.env
set +a
EOF
}
# Check if the dotfiles directory exists otherwise clone the repo
if [ ! -d "$dotfiles_dir" ]; then
    cd "$HOME" || exit
    git clone git@github.com:ec-intl/dotfiles.git
    cd "$dotfiles_dir" || exit
fi
# Pull the latest changes from the repo
cd "$dotfiles_dir" || exit
git pull origin main
source "${src_dir}/functions.sh"
imsg "Installing ${1}...\n"
update_rc_file "$1"
kmsg "Installation complete."

