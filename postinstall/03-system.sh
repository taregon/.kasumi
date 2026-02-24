#!/usr/bin/env bash
# ┌──────────────────────────────────────────────────────────┐
#   Script: POST INSTALL ARCH
#   Descripción: Instala grupos de aplicaciones usando paru,
#   abarcando tanto repos oficiales como AUR.
#   Sistema: Arch Linux / Manjaro
#   Requiere: paru instalado previamente
# └──────────────────────────────────────────────────────────┘

# ─[ CONFIGURACIÓN GENERAL ]──────────────────────────────────
set -e          # Detiene el script si ocurre un error
set -u          # Error si se usa una variable no declarada
set -o pipefail # Propaga errores en tuberías

# Determina el usuario real que ejecuta el script:
# - Usa SUDO_USER si se invocó con sudo
# - Si no, recurre a logname (usuario de sesión)
# - Como último recurso, toma la variable $USER
REAL_USER="${SUDO_USER:-$(logname 2> /dev/null || echo "$USER")}"

# Elevación automática de privilegios:
# relanza con sudo si no es root
if [[ $EUID -ne 0 ]]; then
    echo "  Elevando privilegios..."
    exec sudo -- "$0" "$@"
fi

# Mantiene activa la sesión sudo mientras el script se ejecuta:
# - Lanza un proceso en segundo plano que renueva sudo cada 60s
# - Guarda el PID del proceso auxiliar
# - Al salir del script, mata el proceso para limpiar correctamente
(
    while true; do
        sudo -v
        sleep 60
    done
) 2> /dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

# Confirmación interactiva antes de aplicar cambios en el sistema
confirmar() {
    read -rp "¿Desea volver a la instalación? [s/N]: " respuesta
    [[ "$respuesta" =~ ^[sS]$ ]] || {
        echo "  Cancelado."
        exit 0
    }
}

# Comprueba que las listas que entren en paru no estén vacías
instalar() {
    local paquetes=("$@")
    if [[ ${#paquetes[@]} -gt 0 ]]; then
        paru -S --needed --noconfirm "${paquetes[@]}"
    fi
}

# ╒════════════════════════════════════════════════════════════╕
# │                         REFLECTOR                          │
# ╘════════════════════════════════════════════════════════════╛
update_mirror() {
    echo ">> Estableciendo los 20 mirrors más rápidos"
    pacman -S --needed reflector
    reflector --verbose --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    echo ">> ACTUALIZACIÓN DE MIRRORS COMPLETADA"
}

# ╒════════════════════════════════════════════════════════════╕
# │                  COMPROBACIÓN OBLIGATORIA                  │
# ╘════════════════════════════════════════════════════════════╛
# Verificación del entorno y condiciones previas de instalación
prepare_system() {
    echo "  Comprobando conexión a Internet"
    if ping -c 1 archlinux.org &> /dev/null; then
        echo "  Conexión activa"
    else
        echo "  No hay conexión a Internet. Revisa tu red antes de continuar."
        return 1
    fi

    echo "  Actualizando el sistema"
    pacman -Syu

    echo "  Verificando configuración de idioma y teclado"
    localectl status

    echo "  Verificando disponibilidad de paru"
    if ! command -v paru &> /dev/null; then
        echo "  Paru no está instalado. Se recomienda instalarlo antes de continuar."
        return 1
    fi

    echo "  Comprobando sincronización de reloj"
    timedatectl show | grep "NTPSynchronized=yes" &> /dev/null || {
        echo "  NTP no sincronizado. Ejecuta: sudo timedatectl set-ntp true"
    }

    echo "  VERIFICACIÓN DEL SISTEMA COMPLETADA"
}

# ╒════════════════════════════════════════════════════════════╕
# │                    FUNCIONES POR ÁREAS                     │
# ╘════════════════════════════════════════════════════════════╛
install_app_browser() {
    echo ">> Instalando navegador y complementos multimedia"
    local pkgs=(
        gst-libav        # Soporte para códecs FFmpeg en GStreamer
        gst-plugins-bad  # Plugins GStreamer menos comunes, algunos experimentales
        gst-plugins-good # Plugins GStreamer recomendados
        gst-plugins-ugly # Plugins GStreamer con licencias restrictivas
        hunspell         # Corrector ortográfico
        hunspell-es_pa   # Diccionario español (Panamá) para Hunspell
        luakit           # Navegador web minimalista basado en WebKit
    )
    instalar "${pkgs[@]}"
}

install_app_docs() {
    echo ">> Instalando documentación y manuales"
    local pkgs=(
        man          # Comando man
        man-db       # Base de datos de man
        man-pages-es # Páginas de manual en español
    )
    instalar "${pkgs[@]}"
}

install_app_editor() {
    echo ">> Instalando editores de texto"
    local pkgs=(
        luarocks        # Gestor de paquetes para Lua (plugins de nvim)
        neovim          # Editor de texto/IDE ligero
        neovim-symlinks # vim y vi se redirigen a Neovim
        nodejs          # Requerido por VSCode y plugins de nvim
        npm             # Gestor de paquetes para Node.js
        tree-sitter-cli # Herramienta de línea de comandos para generar, probar y depurar parsers de Tree-sitter.

        # Editores adicionales
        obsidian               # Editor de notas en Markdown enfocado en conocimiento (AUR)
        visual-studio-code-bin # Editor/IDE completo y extensible (AUR)
        xed                    # Editor de texto simple y ligero (MATE)
    )
    instalar "${pkgs[@]}"
}

install_app_cli_fm() {
    echo ">> Instalando gestor de archivos CLI"
    local pkgs=(
        atool               # Manejo de archivos comprimidos desde CLI
        imagemagick         # Conversión y procesamiento de imágenes
        mediainfo           # Muestra metadatos de audio y video
        perl-image-exiftool # Lectura y extracción de metadatos (EXIF/IPTC/XMP)
        poppler             # Utilidades y herramientas para PDF
        python-chardet      # Detección de codificación de texto
        python-pillow       # Procesamiento de imágenes en Python (PIL)
        ranger              # Gestor de archivos en terminal (estilo VI)
        transmission-cli    # Cliente BitTorrent en línea de comandos
        trash-cli           # Envía archivos a la papelera desde CLI
    )
    instalar "${pkgs[@]}"
}

install_app_pdf() {
    echo ">> Instalando visor PDF y complementos OCR"
    local pkgs=(
        zathura            # Visor de documentos ligero
        zathura-pdf-mupdf  # Backend para abrir archivos PDF en Zathura
        tesseract-data-eng # Datos de reconocimiento OCR en inglés
        tesseract-data-spa # Datos de reconocimiento OCR en español
    )
    instalar "${pkgs[@]}"
}

install_app_general() {
    echo ">> Instalando aplicaciones generales"
    local pkgs=(
        keepassxc     # Gestor de contraseñas local con base de datos cifrada
        localsend-bin # Compartir archivos en red local sin configuración compleja
        spek-x-git    # Analizador visual de frecuencias en archivos de audio
        syncthing     # Sincronización privada y cifrada entre dispositivos
        upscayl-bin   # Mejora y reescalado de imágenes con IA
    )
    instalar "${pkgs[@]}"

    sudo -u "$REAL_USER" systemctl --user enable --now syncthing.service
}

install_sys_fonts() {
    echo ">> Instalando fuentes y tipografías"
    local pkgs=(
        noto-fonts              # Fuentes noto (sans, serif, mono)
        noto-fonts-cjk          # Fuentes noto para chino, japonés, coreano
        noto-fonts-emoji        # Fuentes noto con emojis
        ttf-iosevka-nerd        # Fuente monoespaciada con ligaduras (Iosevka)
        ttf-jetbrains-mono-nerd # Fuente JetBrains Mono
        ttf-recursive-nerd      # Fuente Recursive (variable)
        ttf-ubuntusans-nerd     # Fuente Ubuntu Sans
        ttf-ibm-plex            # Fuente IBM Plex (sans, mono, serif)

        # Fuentes de Windows
        # Este entra en conflicto con ttf-ms-fonts,
        # que a su vez es más básico (menos fuentes).
        ttf-ms-win10-auto # Fuentes de Windows 10

        # Fuentes opcionales
        fontforge                 # Editor de fuentes abierto
        ttf-alegreya-sans         # Fuente Alegreya Sans
        ttf-pragmasevka-nerd-font # Fuente Pragmasevka
        ttf-signika               # Fuente Signika
        ttf-sofia-sans            # Fuente Sofia Sans
    )
    instalar "${pkgs[@]}"
}

install_sys_network() {
    echo ">> Instalando NetworkManager y complementos"
    local pkgs=(
        networkmanager         # Servicio principal para gestionar redes
        networkmanager-openvpn # Soporte para conexiones VPN (OpenVPN)
        network-manager-applet # Indicador gráfico para entornos GTK
    )
    instalar "${pkgs[@]}"

    systemctl enable --now NetworkManager
}

install_sys_theme() {
    echo ">> Instalando temas y elementos de estética"
    local pkgs=(
        arc-gtk-theme             # Tema GTK Arc
        gsettings-desktop-schemas # Esquemas GSettings para escritorio
        gtk-engine-murrine        # Motor de temas GTK clásico
        gtk-engines               # Motores de temas GTK adicionales
        matcha-gtk-theme          # Tema GTK Matcha
        nwg-look                  # Gestor de temas e iconos NWG
        qt5-wayland               # Bibliotecas Qt5 para Wayland
        xdg-desktop-portal        # Portal de escritorio (interfaz de especificaciones)
        xdg-desktop-portal-gtk    # Portal GTK
        xdg-desktop-portal-wlr    # Portal parawlr (sway, river)
        zukitwo-themes-git        # Temas GTK Zukitwo (AUR)
    )
    instalar "${pkgs[@]}"
}

install_sys_wayland() {
    echo ">> Instalando herramientas del sistema"
    local pkgs=(

        # Monitoreo y sensores
        btop       # Monitor del sistema en tiempo real (TUI)
        fastfetch  # Info del sistema, rápido y ligero
        gotop      # Monitor del sistema en tiempo real (TUI)
        lm_sensors # Lectura de sensores de hardware
        nvtop      # Monitor de GPU en tiempo real (TUI)
        wluma      # Ajuste automático de brillo según luz ambiental

        # Audio y visualización
        cava # Visualizador de espectro de audio en terminal

        # Conectividad y Bluetooth
        # blueman # Gestor gráfico de Bluetooth
        blueberry # Gestor de Bluetooth para XFCE

        # Seguridad y permisos
        polkit-gnome # Interfaz para autenticación de privilegios (Polkit)

        # Entorno gráfico (Wayland)
        grim         # Captura de pantalla en Wayland
        hyprpicker   # Selector de color en Wayland
        mako         # Demonio de notificaciones para Wayland
        rofi         # Lanzador de aplicaciones y selector interactivo
        slurp        # Selección de región en Wayland
        wl-clipboard # Utilidades de portapapeles en Wayland
        wlogout      # Menú minimalista de cierre de sesión
    )
    instalar "${pkgs[@]}"
}

install_utils_compress() {
    echo ">> Instalando herramientas de compresión"
    local pkgs=(
        engrampa # GUI MATE para archivos comprimidos
        p7zip    # .7z
        unrar    # .rar
        unzip    # Descomprimir .zip
        zip      # Comprimir archivos .zip
        # Otros
        jpegoptim     # Optimiza imágenes JPEG reduciendo peso con mínima pérdida.
        libwebp-utils # Utilidades CLI de WebP (incluye dwebp, cwebp, gif2webp)
        oxipng        # Optimizador de imágenes PNG sin pérdida (recompresión eficiente)
    )
    instalar "${pkgs[@]}"
}

install_utils_files() {
    echo ">> Instalando herramientas de archivos y multimedia"
    local pkgs=(
        exfatprogs    # Herramientas para exFAT (moderno)
        f2fs-tools    # Herramientas para F2FS
        gvfs          # Sistema virtual de archivos (GVFS)
        gvfs-gphoto2  # Soporte cámaras PTP
        gvfs-mtp      # Soporte MTP (Android, etc.)
        imv           # Visor de imágenes ligero
        mpv           # Reproductor multimedia
        mtools        # Manipular discos MS-DOS/FAT
        mtpfs         # Montaje MTP vía FUSE
        nilfs-utils   # Herramientas para NILFS2
        ntfs-3g       # Soporte lectura/escritura NTFS
        thunar        # Explorador de archivos GTK
        thunar-volman # Gestión volúmenes en Thunar
        tumbler       # Generador de miniaturas
        udisks2       # Gestión discos y montaje automático
        xorg-xhost    # Control acceso servidor X (X11)
    )
    instalar "${pkgs[@]}"
}

install_utils_terminal() {
    echo ">> Instalando utilidades de terminal"
    local pkgs=(
        aria2              # Gestor de descargas multiprotocolo (HTTP, FTP, BitTorrent)
        bat                # Visor tipo cat con resaltado y soporte Git
        cdu                # Analizador interactivo de uso de disco (TUI)
        dotdrop            # Gestor de dotfiles con perfiles y plantillas
        eza                # ls moderno con colores e iconos (reemplazo de exa)
        figlet             # Generador de texto en ASCII art
        figlet-fonts-extra # Fuentes adicionales para figlet
        fzf                # Buscador fuzzy interactivo
        git-delta          # Mejorador de diffs para Git
        grc                # Colorea automáticamente la salida de comandos
        iputils            # Herramientas de red (ping, traceroute, etc.)
        iw                 # Configuración avanzada de Wi-Fi
        jq                 # Procesador de JSON en CLI
        kitty              # Emulador de terminal acelerado por GPU
        less               # Paginador de texto para terminal
        lnav               # Visor avanzado de logs (TUI)
        lsd                # ls con iconos y colores
        openssh            # Cliente y servidor SSH
        pacman-contrib     # Utilidades adicionales para pacman
        python-pip         # Gestor de paquetes Python
        ripgrep            # Búsqueda recursiva rápida (rg)
        source-highlight   # Resaltado de sintaxis para less y otros
        sshfs              # Montaje de sistemas remotos vía SSH
        toilet             # Generador de texto ASCII estilizado
        zoxide             # Navegación inteligente entre directorios
        zsh                # Shell interactivo avanzada
        zsh-completions    # Autocompletado adicional para zsh
    )
    instalar "${pkgs[@]}"

    sudo -u "$REAL_USER" systemctl --user enable --now ssh-agent.service

    echo "  Cambiando shell predeterminada a zsh..."
    chsh -s "$(which zsh)" "$REAL_USER"

    echo "  Usuario $REAL_USER agregado al grupo input" # requerido para módulos de waybar
    usermod -aG input "$REAL_USER"

    # Verificar que el grupo fuse exista
    if ! getent group fuse > /dev/null; then
        groupadd fuse
    fi

    echo "  Usuario $REAL_USER agregado al grupo fuse" # requerido para módulos de waybar
    usermod -aG fuse "$REAL_USER"

    echo "  Reinicia la sesión para aplicar el cambio de shell"
}

# ╒════════════════════════════════════════════════════════════╕
# │                       MENÚ PRINCIPAL                       │
# ╘════════════════════════════════════════════════════════════╛
mostrar_menu() {

    # Título en cian
    echo
    echo -e "\e[36m = = = Instalador de Paquetes (con paru) = = =\e[0m"
    # Opciones en amarillo + texto normal
    echo -e "\e[33m1)\e[0m Preparar sistema (\e[31mObligatorio\e[0m)"
    echo -e "\e[33m2)\e[0m Utilidades del sistema"
    echo -e "\e[33m3)\e[0m Editores de texto"
    echo -e "\e[33m4)\e[0m Navegador, archivos y multimedia"
    echo -e "\e[33m5)\e[0m Fuentes y temas"
    echo -e "\e[33m6)\e[0m Redes e Internet"
    echo -e "\e[33m7)\e[0m Terminal y documentación"
    echo -e "\e[33m8)\e[0m INSTALAR TODO"
    echo -e "\e[33m0)\e[0m Salir"
    echo
}

main() {
    mostrar_menu
    read -rp "Seleccione una opción: " opcion
    case "$opcion" in
        1)
            confirmar
            prepare_system
            update_mirror
            ;;
        2)
            confirmar
            install_app_general
            install_sys_wayland
            ;;
        3)
            confirmar
            install_app_editor
            ;;
        4)
            confirmar
            install_app_browser
            install_app_cli_fm
            install_app_pdf
            install_utils_files
            install_utils_compress
            ;;
        5)
            confirmar
            install_sys_fonts
            install_sys_theme
            ;;
        6)
            confirmar
            install_sys_network
            ;;
        7)
            confirmar
            install_app_docs
            install_utils_terminal
            ;;
        8)
            confirmar
            prepare_system
            update_mirror
            install_app_browser
            install_app_docs
            install_app_editor
            install_app_cli_fm
            install_app_pdf
            install_app_general
            install_sys_fonts
            install_sys_network
            install_sys_theme
            install_sys_wayland
            install_utils_compress
            install_utils_files
            install_utils_terminal
            ;;
        0)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida."
            exit 1
            ;;
    esac
}

main "$@"
