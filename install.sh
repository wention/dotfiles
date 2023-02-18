

#################################
# Common

sudo pacman-mirrors -i -c China -m rank

sudo pacman -S clash proxychains-ng tmux neovim net-tools
sudo pacman -S ranger fzf neofetch yay
sudo pacman -S wqy-microhei wqy-zenhei noto-fonts noto-fonts-cjk adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
sudo pacman -S docker docker-compose
sudo pacman -S qemu virt-manager
sudo pacman -S gopass
sudo pacman -S ibus-rime rime-wubi

sudo pacman -S timeshift timeshift-autosnap-manjaro

sudo pacman -S zerotier-one

yay -S com.qq.weixin.deepin 
yay -S wps-office-cn
yay -S howdy
yay -S --asdeps --needed cups libjpeg-turbo pango curl ttf-wps-fonts ttf-ms-fonts wps-office-fonts wps-office-mime-cn wps-office-mui-zh-cn


##################################
# Dev
sudo pacman -S cmake gcc
sudo pacman -S nodejs npm
sudo pacman -S qt5-declarative qt5-tools python-pyqt5


##################################
# Configure
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

sudo chmod -x /usr/lib/office6/wpsoffice

systemctl --user enable --now clash

sudo usermod -aG docker wention
sudo systemctl enable --now docker

sudo usermod -aG libvirt wention
sudo systemctl enable --now libvirtd

# zerotier-one
sudo systemctl enable --now zerotier-one.service
sudo zerotier-cli join d3ecf5726d708f3e
sudo zerotier-cli orbit a85fb5e35e a85fb5e35e


# docker mirror

cat << EOF > /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]
}
EOF

# pip mirror

# pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple
cat << EOF > ~/.pip/pip.conf
[global]
index-url = https://pypi.mirrors.ustc.edu.cn/simple
EOF
