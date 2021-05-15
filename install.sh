#!/bin/bash

TOPDIR=`realpath $(dirname $0)`

echo $TOPDIR

# XDG CONFIG MAP
for CFG in `ls $TOPDIR/.config`
do
	if [ -d $HOME/.config/$CFG ];then
		if [ -L $HOME/.config/$CFG ] && [ "$(realpath $HOME/.config/$CFG)" = "$TOPDIR/.config/$CFG" ];then
			echo "Already updated: $HOME/.config/$CFG -> $TOPDIR/.config/$CFG"
		else
			echo "Updated: $HOME/.config/$CFG -> $TOPDIR/.config/$CFG"
			rm -rf $HOME/.config/$CFG
			ln -Tsf $TOPDIR/.config/$CFG $HOME/.config/$CFG
		fi
	else
		echo "Installed: $HOME/.config/$CFG -> $TOPDIR/.config/$CFG"
		ln -Tsf $TOPDIR/.config/$CFG $HOME/.config/$CFG
	fi
done

for CFG in .gitconfig .zshrc .zsh
do
	if [ -d $HOME/$CFG ];then
		echo "linking $HOME/$CFG -> $TOPDIR/$CFG"
		ln -Tsf $TOPDIR/$CFG $HOME/$CFG
	fi
done
