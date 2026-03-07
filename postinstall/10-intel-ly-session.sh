#!/usr/bin/env bash
# Detecta GPU Intel, crea una sesión Sway para el display manager ly,
# configura las variables de entorno (GLX_VENDOR, WLR_DRM_DEVICES) para usar Intel como primaria.

set -euo pipefail

echo "=== Generando sesión Sway con video Intel ==="
echo
echo "=> Instalando drivers Vulkan y VA-API para Intel..."
sudo pacman -S --noconfirm mesa vulkan-intel libva-intel-driver libva-utils intel-media-driver

get_driver_card() {
    local vendor="$1"
    local pci card
    # Busca dispositivos PCI de clase video (03xx),
    # filtra por vendor, extrae el ID PCI (ej: 0000:00:02.0)
    pci=$(lspci -D -d ::03xx | grep -i "$vendor" | grep -oE '^[0-9a-f:]+:[0-9a-f:.]+' || true)

    if [[ -z "$pci" ]]; then
        return 1
    fi

    card=$(readlink "/dev/dri/by-path/pci-${pci}-card" 2> /dev/null | sed 's|../||')
    echo "/dev/dri/$card"
}

INTEL_CARD=$(get_driver_card "Intel") || {
    echo
    echo "  GPU Intel no encontrada"
    exit 1
}

SESSION_FILE="/etc/ly/custom-sessions/sway-intel.desktop"
sudo mkdir -p "$(dirname "$SESSION_FILE")"

# Para indicar varios GPU
# NVIDIA_CARD=$(get_driver_card "NVIDIA") || true
# WLR_DRM_DEVICES=$INTEL_CARD${NVIDIA_CARD:+:$NVIDIA_CARD}
#
sudo tee "$SESSION_FILE" > /dev/null << EOF
[Desktop Entry]
Name=Sway (Intel GPU)
Exec=/usr/bin/env \
__GLX_VENDOR_LIBRARY_NAME=mesa \
WLR_DRM_DEVICES=$INTEL_CARD \
sway
Type=Application
DesktopNames=sway-intel
Terminal=false
EOF

echo
echo "  Sesión creada en $SESSION_FILE"
echo "Verifica:"
echo "  glxinfo | grep 'OpenGL renderer'"
