#!/usr/bin/env bash

sudo pacman -Syy
sudo pacman -S archlinux-keyring
sudo pacman -Syy

sudo pacman -S linux linux-firmware vim intel-ucode \
    grub efibootmgr networkmanager network-manager-applet \
    wireless_tools wpa_supplicant dialog mtools dosfstools \
    base base-devel linux-headers git reflector bluez bluez-utils \
    pulseaudio-bluetooth pulseaudio cups xdg-utils xdg-user-dirs \
    xf86-input-libinput xf86-video-intel

systemctl enable --now NetworkManager
systemctl enable --now bluetooth
systemctl enable --now cups

sudo pacman -S xorg-server xorg-xwininfo xorg-setxkbmap i3-wm i3blocks i3lock i3status \
    polkit ttf-font-awesome ttf-dejavu xcompmgr xorg-xprop arandr \
    exfat-utils python-qdarkstyle openssh noto-fonts noto-fonts-emoji \
    ntfs-3g pulsemixer pavucontrol maim unclutter unzip xcape xclip \
    yt-dlp zathura zathura-pdf-mupdf poppler fzf \
    xorg-xbacklight firefox zsh system-config-printer gparted \
    ueberzug mediainfo bat ffmpeg ffmpegthumbnailer \
    odt2txt atool zsh-autosuggestions mpd mpv mpc \
    ncmpcpp dunst libnotify python python-pip libreoffice skim \
    socat moreutils alacritty at blueman cmake findutils gawk \
    ripgrep gimp gtk2 gtk3 gtk4 highlight less lxappearance lynx \
    lua pinentry qt5ct tar smbclient sed unrar zip unzip tzdata wget whois \
    xwallpaper ninja curl ttf-linux-libertine ttf-font-awesome ttf-dejavu

mkdir "$HOME/.cache"
mkdir "$HOME/tmp"
mkdir "$HOME/doc"
mkdir "$HOME/img"
mkdir -p "$HOME/.local/share"
mkdir "$HOME/.config"

git clone https://aur.archlinux.org/paru.git "$HOME/tmp/paru"
makepkg -si

paru -S lf-git gtk-theme-arc-gruvbox-git zsh-fast-syntax-highlighting \
    zsh-system-clipboard-git veracrypt-console-bin simple-mtpfs \
    postman-bin htop-vim burpsuite brave-nightly-bin beekeeper-studio-bin \
    artix-dark-theme-git vscodium-bin task-spooler abook nsxiv

sudo pacman -S direnv composer php php-apache php-gd npm nodejs mariadb sqlite
sudo pacman -S signal-desktop
paru -S ferdium-bin

sudo pacman -S mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo mysql -e "CREATE USER 'prospero'@'localhost' IDENTIFIED BY 'prospero';" || exit 1

sudo systemctl enable --now httpd
sudo systemctl enable --now mariadb

sudo chsh
chsh

git clone "https://github.com/pr0sp3ro/dmenu" "$HOME/tmp/dmenu"
cd "$HOME/tmp/dmenu" || exit    
sudo make install

git clone "https://github.com/neovim/neovim/" "$HOME/tmp/neovim"
cd "$HOME/tmp/neovim" || exit    
make CMAKE_BUILD_TYPE=RelWithDebInfo
# git checkout stable
sudo make install

sudo sed -i 's/;\(extension=gd\)/\1/' /etc/php/php.ini
sudo sed -i 's/#\(LoadModule rewrite_module modules\/mod_rewrite\.so\)/\1/' /etc/httpd/conf/httpd.conf
sudo sed -i '/^LoadModule mpm_event_module modules\/mod_mpm_event\.so/s/^/#/' /etc/httpd/conf/httpd.conf
sudo sed -i '/^#LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so\.so/s/^#//' /etc/httpd/conf/httpd.conf
