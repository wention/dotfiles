#!/usr/bin/env bash
#vim:ts=2:sw=2:expandtab
echo "Installing prerequisites for paru..."
sudo pacman -S base-devel fakeroot jshon expac cower wget

echo "Installing base packages..."
pacman -S \
  alacritty \
  bash-completion \
  xorg-xinit \
  xorg-xset

echo "Installing Python dependencies..."
pacman -S \
  python-basiciw \
  python-netifaces \
  python-yaml \
  python-pillow \
  python-urllib3 \

echo "Installing window manager dependencies..."
pacman -S \
  xcb-util-keysyms \
  xcb-util-wm \
  xcb-util-cursor \
  yajl \
  startup-notification \
  libev

echo "Installing tools..."
pacman -S \
  i3lock \
  i3-gaps \
  i3stauts \
  wireless_tools \
  xorg-xbacklight \
  gsimplecal \
  evolution \
  gnome-keyring \
  libsecret \
  seahorse \
  feh \
  acpi \
  xdotool \
  pulseaudio-ctl \
  pavucontrol \
  network-manager-applet \
  networkmanager-openvpn \
  imagemagick \
  dunst \
  python \
  python-pip \
  picom \
  gopass \
  ttf-font-awesome-4 \
  ohsnap \
  ttf-hack \
  ttf-roboto \
  thunar \
  thunar-archive-plugin \
  file-roller \
  tumbler \
  eog \
  tk \
  evince \
  rofi \
  libmtp \
  gvfs-mtp \
  openssh \
  arandr \
  xclip \
  authy-snap \
  xedgewarp-git \
  unclutter-xfixes-git \
  thefuck \
  youtube-dl \
  slop \
  maim \
  neofetch \
  w3m \
  htop \
  bluez \
  bluez-utils \
  pulseaudio-bluetooth \
  blueman \
  redshift \
  lm_sensors \
  ttf-windows \
  gopass \
  authy \
  starship-bin \
  wmctrl

echo "Installing some python stuff..."
pacman -S \
  python-pillow \
  python-urllib3

echo "Installing some perl stuff..."
pacman -S \
  perl-anyevent-i3 \
  perl-json-xs

echo "Installing AUR stuff..."
paru -S \
  google-chrome \
  numix-gtk-theme-git \
  numix-icon-theme-git

