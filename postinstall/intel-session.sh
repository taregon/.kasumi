#!/usr/bin/env bash

set -euo pipefail

echo "=== Generando sesión Sway con video Intel ==="

get_dri_card() {
    local vendor="$1"
    local pci card
    pci=$(lspci -D -d ::03xx | grep -i "$vendor" | grep -oE '^[0-9a-f:]+:[0-9a-f:.]+' | head -1 || true)

    if [[ -z "$pci" ]]; then
        return 1
    fi

    card=$(readlink "/dev/dri/by-path/pci-${pci}-card" 2> /dev/null | sed 's|../||')
    echo "/dev/dri/$card"
}

INTEL_CARD=$(get_dri_card "Intel") || {
    echo
    echo "  GPU Intel no encontrada"
    exit 1
}
NVIDIA_CARD=$(get_dri_card "NVIDIA") || true

SESSION_FILE="/etc/ly/custom-sessions/sway-intel.desktop"
sudo mkdir -p "$(dirname "$SESSION_FILE")"

sudo tee "$SESSION_FILE" > /dev/null << EOF
[Desktop Entry]
Name=Sway (Intel Fist)
Exec=/usr/bin/env WLR_DRM_DEVICES=$INTEL_CARD${NVIDIA_CARD:+:$NVIDIA_CARD} sway
Type=Application
DesktopNames=sway-intel
EOF

echo
echo "  Sesión creada en $SESSION_FILE"
