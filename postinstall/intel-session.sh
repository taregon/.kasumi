#!/usr/bin/env bash

set -euo pipefail

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
    echo "ERROR: GPU Intel no encontrada"
    exit 1
}
NVIDIA_CARD=$(get_dri_card "NVIDIA") || true

for card in "$INTEL_CARD" ${NVIDIA_CARD:+"$NVIDIA_CARD"}; do
    [[ ! -e "$card" ]] && {
        echo "ERROR: Dispositivo no encontrado: $card"
        ls -l /dev/dri/
        exit 1
    }
done

SESSION_FILE="/etc/ly/custom-sessions/sway-prime.desktop"
sudo mkdir -p "$(dirname "$SESSION_FILE")"

sudo tee "$SESSION_FILE" > /dev/null << EOF
[Desktop Entry]
Name=Sway (Intel Fist)
#Exec=/usr/bin/env WLR_DRM_DEVICES=$INTEL_CARD${NVIDIA_CARD:+:$NVIDIA_CARD} sway
Exec=/usr/bin/env WLR_DRM_DEVICES=$INTEL_CARD sway
Type=Application
DesktopNames=sway-prime
EOF
