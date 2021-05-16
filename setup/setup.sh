#!/usr/bin/env bash
set -e

ask() {
  # http://djm.me/ask
  while true; do

    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    # Ask the question
    read -p "$1 [$prompt] " REPLY

    # Default?
    if [ -z "$REPLY" ]; then
       REPLY=$default
    fi

    # Check if the reply is valid
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac

  done
}

link_install() {
    local src=$1
    local dst=$2
    
    echo "Installed: dst -> src"
    ln -sfn $src $dst 
}

topdir=`realpath $(dirname $0)/..`
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

distro=`lsb_release -si`
if [ ! -f "dependencies-${distro}" ]; then
  echo "Could not find file with dependencies for distro ${distro}. Aborting."
  exit 2
fi

ask "Install packages?" Y && bash ./dependencies-${distro}

ask "Install python3 modules?" Y && {
  sudo pip3 install pyyaml
}

ask "Install symlink for .gitconfig?" Y && link_install ${topdir}/.gitconfig ${HOME}/.gitconfig
#ask "Install symlink for .bashrc?" Y && link_install ${dir}/.bashrc ${HOME}/.bashrc
#ask "Install symlink for .bash_profile?" Y && link_install ${dir}/.bash_profile ${HOME}/.bash_profile
#ask "Install symlink for .vimrc?" Y && link_install ${dir}/.vimrc ${HOME}/.vimrc
#ask "Install symlink for .Xresources?" Y && link_install ${dir}/.Xresources ${HOME}/.Xresources
#ask "Install symlink for .xinitrc?" Y && link_install ${dir}/.xinitrc ${HOME}/.xinitrc
#ask "Install symlink for .compton.conf?" Y && link_install ${dir}/.compton.conf ${HOME}/.compton.conf
#ask "Install symlink for .gtkrc-2.0?" Y && link_install ${dir}/.gtkrc-2.0 ${HOME}/.gtkrc-2.0
ask "Install symlink for .npmrc?" Y && link_install ${dir}/.npmrc ${HOME}/.npmrc

ask "Install symlink for ~/.config/i3/?" Y && link_install ${dir}/.config/i3 ${HOME}/.config/i3
ask "Install symlink for .nvim/?" Y && link_install ${dir}/.config/nvim ${HOME}/.config/nvim
ask "Install symlink for .bash.d/?" Y && link_install ${dir}/.bash.d ${HOME}/.bash.d
#ask "Install symlink for .config/?" Y && ln -sfn ${dir}/.config ${HOME}/.config

# Setup neovim
# After nvim has been symlinked!
if [ ! -d "${HOME}/.config/nvim/dein.vim" ]; then
#  echo "Installing dein.vim..."
#  echo "Please run :call dein#install() from vim after this!"
#  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/deinvim-installer.sh
#  sh /tmp/deinvim-installer.sh ${HOME}/.vim/dein.vim
#fi
