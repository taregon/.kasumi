#!/usr/bin/env bash
# ┌──────────────────────────────────────────────────────────┐
#   Script: POST INSTALL ARCH
#   Descripción: Instala grupos de aplicaciones usando paru,
#   abarcando tanto repos oficiales como AUR.
#   Sistema: Arch Linux / Manjaro
#   Requiere: paru instalado y configurado previamente por el usuario
#   Nota: install_pkgs ejecuta paru como usuario real ($real_user) vía sudo -u
#   para permitir instalación de paquetes AUR (paru bloquea AUR como root).
# └──────────────────────────────────────────────────────────┘

# ╒════════════════════════════════════════════════════════════╕
# │                   CONFIGURACIÓN GENERAL                    │
# ╘════════════════════════════════════════════════════════════╛
set -euo pipefail

C_STEP="\033[0;34m"   # blue
C_OK="\033[0;32m"     # green
C_ACTION="\033[0;33m" # yellow
C_RST="\033[0m"       # reset

# Elevación automática de privilegios:
# relanza con sudo si no es root
if [[ $EUID -ne 0 ]]; then
    echo -e "${C_ACTION}  Elevando privilegios${C_RST}"
    exec sudo -- "$0" "$@"
fi

# Determina el usuario que inició la ejecución:
# - Usa SUDO_USER cuando el script fue invocado mediante sudo.
# - En caso contrario, utiliza el nombre del usuario efectivo actual.
real_user="${SUDO_USER:-$(id -un)}"

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
readonly SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

# ─[ UTILIDADES ]──────────────────────────────────────────────
# Confirmación interactiva antes de aplicar cambios en el sistema
confirm() {
    read -rp "¿Desea proceder con la instalación? [s/N]: " respuesta
    [[ "$respuesta" =~ ^[sS]$ ]] || {
        echo -e "${C_ACTION}  Cancelado${C_RST}"
        exit 0
    }
}

# Comprueba que las listas que entren en paru no estén vacías
# Ejecuta paru como usuario real para permitir paquetes AUR
install_pkgs() {
    local paquetes=("$@")
    if [[ ${#paquetes[@]} -gt 0 ]]; then
        sudo -u "$real_user" paru -S --needed --noconfirm "${paquetes[@]}"
    fi
}

# Inyecta XDG_RUNTIME_DIR para systemctl --user desde sudo
run_as_user() {
    local uid
    uid=$(id -u "$real_user")
    sudo -u "$real_user" \
        XDG_RUNTIME_DIR="/run/user/$uid" \
        systemctl --user "$@" 2> /dev/null
}

# Habilita e inicia servicio de usuario (systemctl --user no soporta --now)
enable_now_user() {
    run_as_user enable "$@"
    run_as_user start "$@"
}

# ─[ PREPARACIÓN ]─────────────────────────────────────────────
# Verificación del entorno y condiciones previas de instalación
prepare_system() {
    echo -e "${C_STEP}  Sincronizando bases de datos${C_RST}"
    pacman -Sy || {
        echo -e "${C_ACTION}  Error al sincronizar. Verifica conexión a Internet y DNS.${C_RST}"
        return 1
    }

    echo -e "${C_STEP}  Verificando configuración de idioma y teclado${C_RST}"
    localectl status

    echo -e "${C_STEP}  Verificando disponibilidad de paru${C_RST}"
    if ! command -v paru > /dev/null 2>&1; then
        echo -e "${C_ACTION}  Paru no instalado. Instálalo antes de continuar.${C_RST}"
        return 1
    fi

    echo -e "${C_OK}  Comprobando sincronización de reloj${C_RST}"
    timedatectl show | grep "NTPSynchronized=yes" &> /dev/null || { # esperado: NTP puede no estar sincronizado aún
        echo -e "${C_ACTION}  NTP no sincronizado. Ejecuta: sudo timedatectl set-ntp true${C_RST}"
    }

    echo -e "${C_OK}  Verificación del sistema completada${C_RST}"
}

update_mirror() {
    echo -e "${C_STEP}  Estableciendo los 20 mirrors más rápidos${C_RST}"
    install_pkgs reflector
    reflector --verbose --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    pacman -Syy
    echo -e "${C_OK}  Actualización de mirrors completada${C_RST}"
}

# ╒════════════════════════════════════════════════════════════╕
# │                          SISTEMA                           │
# ╘════════════════════════════════════════════════════════════╛
install_sys_network() {
    echo -e "${C_STEP}  Instalando herramientas de red${C_RST}"
    local pkgs
    pkgs=(
        # Herramientas de red
        iputils # Herramientas de red (ping, traceroute, etc.)
        iw      # Configuración avanzada de Wi-Fi
        iwd     # Demonio de Wi-Fi para Linux
        openssh # Cliente y servidor SSH
        sshfs   # Montaje de sistemas remotos vía SSH
    )
    install_pkgs "${pkgs[@]}"
}

install_sys_wayland() {
    echo -e "${C_STEP}  Instalando entorno Wayland${C_RST}"
    local pkgs
    pkgs=(

        # Bibliotecas gráficas base
        mesa # Implementación de OpenGL/Vulkan para renderizado

        # Compositor Wayland
        swayfx        # Gestor de ventanas Wayland con efectos y animaciones
        swayidle      # Demonio de gestión de inactividad para Wayland
        xdg-utils     # Utilidades CLI de integración con el escritorio (xdg-open, xdg-mime, etc.)
        xorg-xwayland # Servidor X para Wayland (XWayland)
        qt5-wayland   # Bibliotecas Qt5 para integración con Wayland

        # Monitoreo y sensores
        btop       # Monitor del sistema en tiempo real (TUI)
        fastfetch  # Info del sistema, rápido y ligero
        lm_sensors # Lectura de sensores de hardware
        nvtop      # Monitor de GPU en tiempo real (TUI)
        wluma      # Ajuste automático de brillo según luz ambiental

        # Audio y visualización
        cava           # Visualizador de espectro de audio en terminal
        pipewire       # Servicio de audio/video de baja latencia (reemplaza PulseAudio/JACK)
        pipewire-pulse # Capa de compatibilidad con PulseAudio sobre PipeWire
        wiremix        # Mezclador de audio TUI nativo PipeWire
        wev            # Visor de eventos de entrada en Wayland
        wireplumber    # Session manager moderno para PipeWire (reemplaza pipewire-media-session)

        # Conectividad y Bluetooth
        # blueman # Gestor gráfico de Bluetooth
        blueberry # Gestor de Bluetooth para XFCE

        # Seguridad y permisos
        polkit-gnome # Interfaz para autenticación de privilegios (Polkit)
        xorg-xhost   # Control acceso servidor X (X11)

        # Portales de escritorio
        xdg-desktop-portal     # API unificada para portals de escritorio
        xdg-desktop-portal-gtk # Implementación GTK de xdg-desktop-portal
        xdg-desktop-portal-wlr # Implementación wlroots de xdg-desktop-portal

        # Entorno gráfico (Wayland)
        awww         # Gestor de fondos animados para Wayland
        cliphist     # Gestor de historial del portapapeles para Wayland
        grim         # Captura de pantalla en Wayland
        hyprpicker   # Selector de color en Wayland
        mako         # Demonio de notificaciones para Wayland
        rofi         # Lanzador de aplicaciones y selector interactivo
        rofi-calc    # Plugin de calculadora para rofi con lenguaje natural
        slurp        # Selección de región en Wayland
        swappy       # Editor interactivo para capturas de pantalla en Wayland
        swaylock     # Pantalla de bloqueo para Sway/Wayland
        waybar       # Barra de estado altamente personalizable para Wayland
        wl-clipboard # Utilidades de portapapeles en Wayland
        wlogout      # Menú minimalista de cierre de sesión
    )
    install_pkgs "${pkgs[@]}"
}

install_sys_fonts() {
    echo -e "${C_STEP}  Instalando fuentes y tipografías${C_RST}"
    local pkgs
    pkgs=(
        noto-fonts                  # Fuentes noto (sans, serif, mono)
        noto-fonts-cjk              # Fuentes noto para chino, japonés, coreano
        noto-fonts-emoji            # Fuentes noto con emojis
        ttf-ibm-plex                # Fuente IBM Plex (sans, mono, serif)
        ttf-iosevka-nerd            # Fuente monoespaciada con ligaduras (Iosevka)
        ttf-jetbrains-mono-nerd     # Fuente JetBrains Mono
        ttf-juliamono               # Fuente JuliaMono
        ttf-nerd-fonts-symbols-mono # Símbolos Nerd Fonts monoespaciados
        ttf-recursive-nerd          # Fuente Recursive (variable)
        ttf-ubuntusans-nerd         # Fuente Ubuntu Sans

        # Fuentes de Windows
        # Este entra en conflicto con ttf-ms-fonts,
        # que a su vez es más básico (menos fuentes).
        ttf-ms-win10-auto # Fuentes de Windows 10

        # Fuentes opcionales
        fontforge                 # Editor de fuentes abierto
        fontpreview               # Previsualizador de fuentes desde terminal
        ttf-alegreya-sans         # Fuente Alegreya Sans
        ttf-pragmasevka-nerd-font # Fuente Pragmasevka
        ttf-signika               # Fuente Signika
        ttf-sofia-sans            # Fuente Sofia Sans
    )
    install_pkgs "${pkgs[@]}"
}

install_sys_theme() {
    echo -e "${C_STEP}  Instalando temas y elementos de estética${C_RST}"
    local pkgs
    pkgs=(
        # Temas y motores GTK
        arc-gtk-theme             # Tema GTK plano con transparencias (Arc)
        gnome-themes-extra        # Temas adicionales de GNOME (Adwaita, etc.)
        gsettings-desktop-schemas # Esquemas GSettings para configuración de escritorio
        gtk-engine-murrine        # Motor de temas GTK2 clásico (Murrine)
        gtk-engines               # Colección de motores de temas GTK
        nwg-look                  # Gestor gráfico de temas GTK/Qt desde CLI
        sassc                     # Compilador de Sass a CSS (CLI)
        zukitwo-themes-git        # Temas GTK Zukitwo (AUR)
    )
    install_pkgs "${pkgs[@]}"
}

# ─[ APLICACIONES ]────────────────────────────────────────────
install_app_browser() {
    echo -e "${C_STEP}  Instalando navegador luakit y complementos${C_RST}"
    local pkgs
    pkgs=(
        gst-libav        # Soporte para códecs FFmpeg en GStreamer
        gst-plugins-bad  # Plugins GStreamer menos comunes, algunos experimentales
        gst-plugins-good # Plugins GStreamer recomendados
        gst-plugins-ugly # Plugins GStreamer con licencias restrictivas
        hunspell         # Corrector ortográfico
        hunspell-es      # Diccionario español general para Hunspell
        hunspell-es_pa   # Diccionario español (Panamá) para Hunspell
        luakit           # Navegador web minimalista basado en WebKit
    )
    install_pkgs "${pkgs[@]}"
}

install_app_editor() {
    echo -e "${C_STEP}  Instalando editores de texto${C_RST}"
    local pkgs
    pkgs=(
        luarocks        # Gestor de paquetes para Lua (plugins de nvim)
        neovim          # Editor de texto/IDE ligero
        neovim-symlinks # vim y vi se redirigen a Neovim
        nodejs          # Requerido por VSCode y plugins de nvim
        npm             # Gestor de paquetes para Node.js
        tree-sitter     # Biblioteca para parsing incremental y reutilizable
        tree-sitter-cli # Desarrollo, prueba y uso de parsers Tree-sitter

        # Editores adicionales
        obsidian               # Editor de notas en Markdown enfocado en conocimiento (AUR)
        visual-studio-code-bin # Editor/IDE completo y extensible (AUR)
        xed                    # Editor de texto simple y ligero (MATE)
    )
    install_pkgs "${pkgs[@]}"
}

install_app_pdf() {
    echo -e "${C_STEP}  Instalando visor PDF y complementos OCR${C_RST}"
    local pkgs
    pkgs=(
        tesseract          # Motor OCR base
        tesseract-data-eng # Datos de reconocimiento OCR en inglés
        tesseract-data-spa # Datos de reconocimiento OCR en español
        zathura            # Visor de documentos ligero
        zathura-pdf-mupdf  # Backend para abrir archivos PDF en Zathura
    )
    install_pkgs "${pkgs[@]}"
}

install_app_cli_fm() {
    echo -e "${C_STEP}  Instalando gestor de archivos CLI${C_RST}"
    local pkgs
    pkgs=(
        atool               # Manejo de archivos comprimidos desde CLI
        imagemagick         # Conversión y procesamiento de imágenes
        mediainfo           # Muestra metadatos de audio y video
        perl-image-exiftool # Lectura y extracción de metadatos (EXIF/IPTC/XMP)
        poppler             # Utilidades y herramientas para PDF
        python-chardet      # Detección de codificación de texto
        python-pillow       # Procesamiento de imágenes en Python (PIL)
        ranger              # Gestor de archivos en terminal (estilo VI)
        trash-cli           # Envía archivos a la papelera desde CLI
    )
    install_pkgs "${pkgs[@]}"
}

install_app_docs() {
    echo -e "${C_STEP}  Instalando documentación y manuales${C_RST}"
    local pkgs
    pkgs=(
        man-db       # Comando man y base de datos
        man-pages-es # Páginas de manual en español
    )
    install_pkgs "${pkgs[@]}"
}

install_app_general() {
    echo -e "${C_STEP}  Instalando aplicaciones generales${C_RST}"
    local pkgs
    pkgs=(
        keepassxc        # Gestor de contraseñas local con base de datos cifrada
        localsend-bin    # Compartir archivos en red local sin configuración compleja
        transmission-cli # Cliente BitTorrent en línea de comandos
        spek-x-git       # Analizador visual de frecuencias en archivos de audio
        syncthing        # Sincronización privada y cifrada entre dispositivos
        upscayl-bin      # Mejora y reescalado de imágenes con IA
        # Libre Office
        hyphen-es            # Reglas de separación silábica en español
        libreoffice-fresh    # Suite ofimática con nuevas funciones
        libreoffice-fresh-es # Paquete de idioma español para LibreOffice
    )
    install_pkgs "${pkgs[@]}"
}

# ─[ UTILIDADES DE INSTALACIÓN ]───────────────────────────────
install_utils_compress() {
    echo -e "${C_STEP}  Instalando herramientas de compresión${C_RST}"
    local pkgs
    pkgs=(
        engrampa # GUI MATE para archivos comprimidos
        p7zip    # .7z
        unrar    # .rar
        unzip    # Descomprimir .zip
        zip      # Comprimir archivos .zip
    )
    install_pkgs "${pkgs[@]}"
}

install_utils_files() {
    echo -e "${C_STEP}  Instalando herramientas de archivos y multimedia${C_RST}"
    local pkgs
    # mtpfs omitido: innecesario con Thunar + gvfs-mtp (gvfs provee MTP)
    pkgs=(
        exfatprogs        # Herramientas para exFAT (moderno)
        f2fs-tools        # Herramientas para F2FS
        ffmpegthumbnailer # Generador de miniaturas de video con FFmpeg
        gvfs              # Sistema virtual de archivos (GVFS)
        gvfs-gphoto2      # Soporte cámaras PTP
        gvfs-mtp          # Soporte MTP (Android, etc.)
        imv               # Visor de imágenes ligero
        mpv               # Reproductor multimedia
        nilfs-utils       # Herramientas para NILFS2
        ntfs-3g           # Soporte lectura/escritura NTFS
        playerctl         # Control de reproductores multimedia desde CLI

        # Optimización de imágenes
        jpegoptim     # Optimiza imágenes JPEG reduciendo peso con mínima pérdida.
        libwebp-utils # Utilidades CLI de WebP (incluye dwebp, cwebp, gif2webp)
        oxipng        # Optimizador de imágenes PNG sin pérdida (recompresión eficiente)

        thunar        # Explorador de archivos GTK
        thunar-volman # Gestión volúmenes en Thunar
        tumbler       # Generador de miniaturas
        udisks2       # Gestión discos y montaje automático
    )
    install_pkgs "${pkgs[@]}"
}

install_utils_terminal() {
    echo -e "${C_STEP}  Instalando utilidades de terminal${C_RST}"
    local pkgs
    pkgs=(
        aria2              # Gestor de descargas multiprotocolo (HTTP, FTP, BitTorrent)
        ast-grep-bin       # Herramienta de búsqueda y lint de código
        opencode-bin       # Asistente interactivo de IA para desarrollo de software
        bat                # Visor tipo cat con resaltado y soporte Git
        bc                 # Calculadora CLI con soporte para decimales de alta precisión
        brightnessctl      # Control de brillo de pantalla desde terminal
        cdu                # Analizador interactivo de uso de disco (TUI)
        cronie             # daemon cron oficial Arch Linux para tareas programadas
        dotdrop            # Gestor de dotfiles con perfiles y plantillas
        eza                # ls moderno con colores e iconos (reemplazo de exa)
        figlet             # Generador de texto en ASCII art
        figlet-fonts-extra # Fuentes adicionales para figlet
        fzf                # Buscador fuzzy interactivo
        git-delta          # Mejorador de diffs para Git
        grc                # Colorea automáticamente la salida de comandos
        jq                 # Procesador de JSON en CLI
        kitty              # Emulador de terminal acelerado por GPU
        less               # Paginador de texto para terminal
        lnav               # Visor avanzado de logs (TUI)
        mlr                # Procesador de datos estilo awk (Miller)
        pacman-contrib     # Utilidades adicionales para pacman
        pandoc             # Conversor de documentos markup entre formatos
        pastel             # Generación, análisis, conversión y manipulación de colores
        python-pip         # Gestor de paquetes Python
        ripdrag            # drag & drop desde terminal
        ripgrep            # Búsqueda recursiva rápida (rg)
        source-highlight   # Resaltado de sintaxis para less y otros
        toilet             # Generador de texto ASCII estilizado
        vivid              # Generador moderno de LS_COLORS con temas
        xan                # Utilidad para procesamiento de tablas CSV
        zoxide             # Navegación inteligente entre directorios
        zsh                # Shell interactivo avanzada
        zsh-completions    # Autocompletado adicional para zsh
    )
    install_pkgs "${pkgs[@]}"

    echo -e "${C_STEP}  Cambiando shell predeterminada a zsh${C_RST}"
    sudo -u "$real_user" chsh -s "$(command -v zsh)"

    # Añadir usuario a grupo input (requerido por módulos waybar)
    echo -e "${C_STEP}  Grupo input: $real_user agregado${C_RST}"
    usermod -aG input "$real_user"

    # Verificar que el grupo fuse exista (crear si no, -f ignora si ya existe)
    groupadd -f fuse

    # Añadir usuario a grupo fuse (requerido por módulos waybar)
    echo -e "${C_STEP}  Grupo fuse: $real_user agregado${C_RST}"
    usermod -aG fuse "$real_user"

    echo -e "${C_ACTION}  Reinicia la sesión para aplicar el cambio de shell${C_RST}"
}

# ─[ SERVICIOS ]──────────────────────────────────────────────
enable_services() {
    # System services — infrastructure
    systemctl enable --now iwd
    systemctl enable --now systemd-networkd
    systemctl enable --now systemd-resolved
    systemctl enable --now cronie

    # User services — session
    enable_now_user ssh-agent.service
    enable_now_user syncthing.service
}

# ╒════════════════════════════════════════════════════════════╕
# │                            MENÚ                            │
# ╘════════════════════════════════════════════════════════════╛
show_menu() {

    echo
    echo -e "${C_STEP} = = = Instalador de Paquetes (con paru) = = =${C_RST}"
    echo -e "${C_ACTION}1)${C_RST} Preparar sistema ${C_STEP}(Obligatorio)${C_RST}"
    echo -e "${C_ACTION}2)${C_RST} Redes e Internet"
    echo -e "${C_ACTION}3)${C_RST} Entorno gráfico"
    echo -e "${C_ACTION}4)${C_RST} Aplicaciones generales"
    echo -e "${C_ACTION}5)${C_RST} Editores de texto"
    echo -e "${C_ACTION}6)${C_RST} Navegador y multimedia"
    echo -e "${C_ACTION}7)${C_RST} Fuentes y temas"
    echo -e "${C_ACTION}8)${C_RST} Terminal y utilidades"
    echo -e "${C_ACTION}9)${C_RST} INSTALAR TODO"
    echo -e "${C_ACTION}0)${C_RST} Salir ${C_ACTION} ${C_RST}"
    echo
}

main() {
    while true; do
        show_menu
        read -rp "Seleccione una opción: " opcion
        case "$opcion" in
            1)
                confirm
                prepare_system || return 1
                update_mirror
                ;;
            2)
                confirm
                install_sys_network
                ;;
            3)
                confirm
                install_sys_wayland
                ;;
            4)
                confirm
                install_app_general
                ;;
            5)
                confirm
                install_app_editor
                ;;
            6)
                confirm
                install_app_browser
                install_app_cli_fm
                install_app_pdf
                ;;
            7)
                confirm
                install_sys_fonts
                install_sys_theme
                ;;
            8)
                confirm
                install_utils_compress
                install_utils_files
                install_utils_terminal
                install_app_docs
                ;;
            9)
                confirm
                prepare_system || return 1
                update_mirror
                install_sys_wayland
                install_app_general
                install_app_editor
                install_app_browser
                install_app_cli_fm
                install_app_pdf
                install_sys_fonts
                install_sys_theme
                install_sys_network
                install_utils_compress
                install_utils_files
                install_utils_terminal
                install_app_docs
                enable_services
                ;;
            0)
                echo "Saliendo..."
                break
                ;;
            *)
                echo "Opción inválida."
                sleep 1
                ;;
        esac
        echo
        read -rp "Presione Enter para volver al menú principal..."
    done
}

main "$@"
