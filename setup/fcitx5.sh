
# install packages: pacman -S fcitx5-im

cat << EOF >> /etc/environment
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx
GTK_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF


