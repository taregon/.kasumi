#!/bin/bash
# ╒════════════════════════════════════════════════════════════╕
# │          SCRIPT DE INSTALACIÓN BASE - ARCH LINUX           │
# ╘════════════════════════════════════════════════════════════╛
echo ">> Actualizar mirrors"
sudo pacman -S --needed reflector
sudo reflector --verbose --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

echo ">> Actualización inicial del sistema"
sudo pacman -Syu

echo ">> Verificacion de idioma y teclado"
localectl status

echo ">> Utilidades de terminal"
sudo pacman -S --needed \
    bat \
    exa \
    fzf \
    git-delta \
    grc \
    iputils \
    iw \
    jq \
    kitty \
    less \
    lsd \
    toilet \
    zoxide \
    zsh \
    zsh-completions

echo ">> Cambiar shell predeterminada a zsh"
chsh -s "$(which zsh)"
echo "[!] Reinicia la sesión para aplicar el cambio de shell"
# ────────────────────────────────────────────────────────────
echo ">> Fuentes y tipografías"
sudo pacman -S --needed \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ttf-iosevka-nerd \
    ttf-jetbrains-mono-nerd \
    ttf-recursive-nerd

paru -S --needed \
    fontforge \
    ttf-alegreya-sans \
    ttf-ms-fonts \
    ttf-pragmasevka-nerd-font \
    ttf-signika \
    ttf-sofia-sans
# Este  entra en conflicto con ttf-ms-fonts
paru -S ttf-ms-win10-auto
# ────────────────────────────────────────────────────────────
echo ">> Herramientas del sistema"
sudo pacman -S --needed \
    blueman \
    btop \
    cava \
    gotop \
    lm_sensors

# Administración de red
sudo pacman -S --needed networkmanager
sudo systemctl enable --now NetworkManager

# Documentación y manuales
sudo pacman -S --needed \
    man man-pages-es man-db

# Visor de PDF y OCR
sudo pacman -S --needed \
    zathura \
    zathura-pdf-mupdf \
    tesseract-data-eng \
    tesseract-data-spa

# Ranger y complementos
sudo pacman -S --needed \
    ranger ueberzug \
    atool imagemagick mediainfo poppler python-pillow trash-cli python-chardet

# Gestión de archivos
sudo pacman -S --needed \
    exfat-utils \
    gvfs \
    gvfs-gphoto2 \
    gvfs-mtp \
    imv \
    mpv \
    mtpfs \
    ntfs-3g \
    thunar \
    thunar-volman \
    tumbler \
    udisks2
# revisa esta demencia
sudo pacman -S gvfs udisks2 polkit-gnome ntfs-3g gvfs

sudo systemctl enable udisks2.service
sudo systemctl start udisks2.service

# Gestión de archivos comprimidos
sudo pacman -S --needed \
    zip unzip unrar p7zip engrampa

# Temas e interfaz
grim mako

sudo pacman -S --needed \
    gtk-engine-murrine \
    gtk-engines \
    nwg-look

paru -S --needed matcha-gtk-theme arc-gtk-theme zukitwo-themes-git

echo ">>  Editores: nvim y vscode:"
sudo pacman -S --needed neovim luarocks nodejs npm
paru -S --needed visual-studio-code-bin obsidian

# Estética y logout
paru -S --needed wlogout figlet figlet-fonts-extra

# Utilidades de entorno gráfico (Wayland)
sudo pacman -S --needed wl-clipboard hyprpicker

# Para compartir archivos
paru -S localsend-bin
