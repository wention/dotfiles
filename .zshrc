#source ~/.zsh/lscolors.zsh
#source ~/.zsh/alias.zsh

export PATH=$HOME/.local/bin:$PATH


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

if [ -e ~/.zshrc_local ];then
    source ~/.zshrc_local
fi
