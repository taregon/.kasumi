#!/usr/bin/env bash
# ============================================================
# Script: install-packages.sh
# Descripción: Instala grupos de aplicaciones usando paru,
#              abarcando tanto repos oficiales como AUR.
# Sistema: Arch Linux / Manjaro
# Requiere: paru instalado previamente
# ============================================================

# ─[ CONFIGURACIÓN GENERAL ]──────────────────────────────────
set -e          # Detiene el script si ocurre un error
set -u          # Error si se usa una variable no declarada
set -o pipefail # Propaga errores en tuberías

# Confirma la acción antes de proceder
confirmar() {
    read -rp "¿Desea continuar con la instalación? [s/N]: " respuesta
    [[ "$respuesta" =~ ^[sS]$ ]] || {
        echo "Cancelado."
        exit 0
    }
}

# Ejecuta paru de forma segura
instalar() {
    local paquetes=("$@")
    if [[ ${#paquetes[@]} -gt 0 ]]; then
        paru -S --needed --noconfirm "${paquetes[@]}"
    fi
}

# ─[ FASTEST MIRRORS ]────────────────────────────────────────
update_mirror() {
    echo ">> Estableciendo los 20 mirrors más rápidos"
    sudo pacman -S --needed reflector
    sudo reflector --verbose --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}

# ─[ COMPROBACIONES INICIALES ]────────────────────────────────
# Verificación del entorno y condiciones previas de instalación
prepare_system() {
    echo ">> Comprobando conexión a Internet"
    if ping -c 1 archlinux.org &> /dev/null; then
        echo "✅ Conexión activa"
    else
        echo "⚠️ No hay conexión a Internet. Revisa tu red antes de continuar."
        return 1
    fi

    echo ">> Actualizando el sistema"
    sudo pacman -Syu

    echo ">> Verificando configuración de idioma y teclado"
    localectl status

    echo ">> Verificando disponibilidad de paru"
    if ! command -v paru &> /dev/null; then
        echo "⚠️ Paru no está instalado. Se recomienda instalarlo antes de continuar."
        return 1
    fi

    echo ">> Comprobando sincronización de reloj"
    timedatectl show | grep "NTPSynchronized=yes" &> /dev/null || {
        echo "⚠️ NTP no sincronizado. Ejecuta: sudo timedatectl set-ntp true"
    }

    echo ">> VERIFICACIÓN DEL SISTEMA COMPLETADA"
}

# ╒════════════════════════════════════════════════════════════╕
# │                    FUNCIONES POR ÁREAS                     │
# ╘════════════════════════════════════════════════════════════╛

install_fonts() {
    echo ">> Instalando fuentes y tipografías"
    local pkgs=(
        noto-fonts-cjk
        noto-fonts-emoji
        ttf-iosevka-nerd
        ttf-jetbrains-mono-nerd
        ttf-recursive-nerd

        # Fuentes de Windows
        # Este entra en conflicto con ttf-ms-fonts,
        # que a su vez es más básico (menos fuentes).
        ttf-ms-win10-auto

        # Fuentes opcionales
        fontforge
        ttf-alegreya-sans
        ttf-pragmasevka-nerd-font
        ttf-signika
        ttf-sofia-sans
    )
    instalar "${pkgs[@]}"
}

install_ranger() {
    echo ">> Instalando ranger y complementos"
    local pkgs=(
        atool          # Soporte para archivos comprimidos
        imagemagick    # Conversión y vista previa de imágenes
        mediainfo      # Muestra metadatos de audio y video
        poppler        # Vista previa y utilidades para PDF
        python-chardet # Detección de codificación de texto
        python-pillow  # Librería para procesar imágenes (PIL)
        ranger         # Gestor de archivos en terminal tipo VI
        trash-cli      # Envío de archivos a la papelera desde CLI
    )
    instalar "${pkgs[@]}"
}

install_zathura() {
    echo ">> Instalando visor PDF y complementos OCR"
    local pkgs=(
        zathura            # Visor de documentos ligero
        zathura-pdf-mupdf  # Backend para abrir archivos PDF en Zathura
        tesseract-data-eng # Datos de reconocimiento OCR en inglés
        tesseract-data-spa # Datos de reconocimiento OCR en español
    )
    instalar "${pkgs[@]}"
}

install_network_manager() {
    echo ">> Instalando NetworkManager y complementos"
    local pkgs=(
        networkmanager         # Servicio principal para gestionar redes
        networkmanager-openvpn # Soporte para conexiones VPN (OpenVPN)
        network-manager-applet # Indicador gráfico para entornos GTK
    )
    instalar "${pkgs[@]}"

    sudo systemctl enable --now NetworkManager
}

install_system_tools() {
    echo ">> Instalando herramientas del sistema y utilidades Wayland"
    local pkgs=(
        # Monitoreo y sensores
        btop       # Monitor de sistema
        cava       # Visualización de audio en terminal
        gotop      # Monitor moderno de sistema
        lm_sensors # Sensores de hardware

        # Bluetooth y permisos
        blueman      # Gestor de Bluetooth
        polkit-gnome # Polkit GUI

        # Wayland / entorno gráfico
        grim         # Captura de pantalla para Wayland
        hyprpicker   # Selector de color Wayland
        mako         # Demonio de notificaciones para Wayland
        wl-clipboard # Portapapeles Wayland
        wlogout      # Pantalla de logout minimalista
    )
    instalar "${pkgs[@]}"
}

install_misc_tools() {
    echo ">> Instalando herramientas varias"
    local pkgs=(
        localsend-bin # Compartir archivos en red local
        spek-x-git    # Analizador de espectro de audio
    )
    instalar "${pkgs[@]}"
}

install_compression_tools() {
    echo ">> Instalando herramientas de compresión más comunes"
    local pkgs=(
        engrampa # GUI MATE para archivos comprimidos
        p7zip    # .7z
        unrar    # .rar
        unzip    # Descomprimir .zip
        zip      # Comprimir archivos .zip
    )
    instalar "${pkgs[@]}"
}

install_editors() {
    echo ">> Instalando editores y herramientas de desarrollo"
    local pkgs=(
        # Editores
        obsidian               # Editor de notas (AUR)
        visual-studio-code-bin # IDE completo (AUR)
        xed                    # Editor de texto simple (MATE)

        # NEOVIM y dependencias
        luarocks # Gestor de paquetes para Lua (plugins de nvim)
        neovim   # Editor de texto/IDE ligero
        nodejs   # Requerido por VSCode y plugins de nvim
        npm      # Gestor de paquetes para Node.js
    )
    instalar "${pkgs[@]}"
}

install_man() {
    echo ">> Instalando documentación y manuales"
    local pkgs=(
        man          # Comando man
        man-db       # Base de datos de man
        man-pages-es # Páginas de manual en español
    )
    instalar "${pkgs[@]}"
}

install_terminal_utils() {
    echo ">> Instalando utilidades de terminal"
    local pkgs=(
        bat                # Mejor cat con resaltado de sintaxis
        exa                # Reemplazo moderno de ls
        figlet             # Texto ASCII art
        figlet-fonts-extra # Fuentes adicionales para Figlet
        fzf                # Buscador interactivo
        git-delta          # Diferencias de Git con color
        grc                # Colores para comandos
        iputils            # ping, traceroute, etc.
        iw                 # Configuración Wi-Fi
        jq                 # Procesamiento JSON
        kitty              # Terminal moderna
        less               # Paginador de texto
        lsd                # ls con iconos
        pacman-contrib     # Herramientas adicionales pacman
        toilet             # Texto con estilos ASCII
        zoxide             # Navegación rápida de directorios
        zsh                # Shell moderno
        zsh-completions    # Autocompletado para zsh
    )
    instalar "${pkgs[@]}"

    echo "Cambiando shell predeterminada a zsh..."
    chsh -s "$(which zsh)"
    echo "[!] Reinicia la sesión para aplicar el cambio de shell"
}

install_file_management() {
    echo ">> Instalando herramientas de archivos y multimedia"
    local pkgs=(
        exfat-utils   # Sistemas de archivos exFAT
        gvfs          # Sistema virtual de archivos
        gvfs-gphoto2  # Acceso cámaras PTP
        gvfs-mtp      # Acceso MTP
        imv           # Visor de imágenes ligero
        mpv           # Reproductor multimedia
        mtpfs         # Montaje de MTP
        ntfs-3g       # Soporte NTFS
        thunar        # Explorador de archivos GTK
        thunar-volman # Gestión de volúmenes para Thunar
        tumbler       # Generador de miniaturas
        udisks2       # Gestión de discos y volúmenes
    )
    instalar "${pkgs[@]}"
}

install_luakit() {
    echo ">> Instalando Luakit y complementos multimedia"
    local pkgs=(
        luakit           # Navegador web minimalista basado en WebKit
        gst-plugins-good # Plugins GStreamer recomendados
        gst-plugins-bad  # Plugins GStreamer menos comunes, algunos experimentales
        gst-plugins-ugly # Plugins GStreamer con licencias restrictivas
        gst-libav        # Soporte para códecs FFmpeg en GStreamer
        hunspell         # Corrector ortográfico
        hunspell-es_pa   # Diccionario español (Panamá) para Hunspell
    )
    instalar "${pkgs[@]}"
}

install_theme() {
    echo ">> Instalando temas y elementos de estética"
    local pkgs=(
        gtk-engine-murrine # Motor de temas GTK clásico
        gtk-engines        # Motores de temas GTK adicionales
        nwg-look           # Gestor de temas e iconos NWG
        matcha-gtk-theme   # Tema GTK Matcha
        arc-gtk-theme      # Tema GTK Arc
        zukitwo-themes-git # Temas GTK Zukitwo (AUR)
    )
    instalar "${pkgs[@]}"
}

# ╒════════════════════════════════════════════════════════════╕
# │                       MENÚ PRINCIPAL                       │
# ╘════════════════════════════════════════════════════════════╛
mostrar_menu() {

    # Título en cian
    echo
    echo -e "\e[36m = = = Instalador de Paquetes (con paru) = = =\e[0m"
    # Opciones en amarillo + texto normal
    echo -e "\e[33m1)\e[0m Preparar sistema (OBLIGATORIO)"
    echo -e "\e[33m2)\e[0m Utilidades del sistema y entorno gráfico"
    echo -e "\e[33m3)\e[0m Editores y herramientas de desarrollo"
    echo -e "\e[33m4)\e[0m Administración de archivos y multimedia"
    echo -e "\e[33m5)\e[0m Fuentes y temas"
    echo -e "\e[33m6)\e[0m Herramientas de red e Internet"
    echo -e "\e[33m7)\e[0m Terminal y documentación"
    echo -e "\e[33m8)\e[0m Instalar todo"
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
            install_system_tools
            install_misc_tools
            ;;
        3)
            confirmar
            install_editors
            ;;
        4)
            confirmar
            install_file_management
            install_ranger
            install_zathura
            install_luakit
            ;;
        5)
            confirmar
            install_fonts
            install_theme
            ;;
        6)
            confirmar
            install_network_manager
            ;;
        7)
            confirmar
            install_terminal_utils
            install_man
            ;;
        8)
            confirmar
            prepare_system
            update_mirror
            install_system_tools
            install_misc_tools
            install_editors
            install_file_management
            install_ranger
            install_zathura
            install_luakit
            install_fonts
            install_theme
            install_network_manager
            install_terminal_utils
            install_man
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
