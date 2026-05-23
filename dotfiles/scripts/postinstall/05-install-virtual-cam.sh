#!/usr/bin/env bash

# Cámara virtual V4L2 para compartir pantalla en Wayland (Sway/Hyprland).
#
# Instala dependencias, configura persistencia en modules-load.d y
# modprobe.d (device=/dev/video8, label="Wayland Screen Share"), y
# recarga el módulo v4l2loopback.
#

set -euo pipefail

virtual_camera_number=8
virtual_camera_name="Wayland Screen Share"

# ── Colores ────────────────────────────────────────────────
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m"

echo -e "\n${BLUE}  Instalando dependencias...${NC}\n"

paru -S --needed --noconfirm \
    wf-recorder \
    v4l2loopback-dkms \
    v4l2loopback-utils \
    v4l-utils \
    jq > /dev/null

# ── Carga automática del módulo ─────────────────────────────

echo -e "\n${BLUE}  Configurando persistencia del módulo...${NC}\n"

echo -e "   ${YELLOW}  /etc/modules-load.d/v4l2loopback.conf${NC}"

sudo tee /etc/modules-load.d/v4l2loopback.conf > /dev/null << EOF
v4l2loopback
EOF

echo -e "   ${YELLOW}  /etc/modprobe.d/v4l2loopback.conf${NC}"

sudo tee /etc/modprobe.d/v4l2loopback.conf > /dev/null << EOF
options v4l2loopback \
  devices=1 \
  video_nr=${virtual_camera_number} \
  card_label="${virtual_camera_name}" \
  exclusive_caps=1
EOF

# ────────────────────────────────────────────────────────────
echo -e "\n${BLUE}  Reiniciando módulo v4l2loopback...${NC}\n"

sudo modprobe -r v4l2loopback 2> /dev/null || true
sudo modprobe v4l2loopback

sleep 1
if [[ ! -e /dev/video${virtual_camera_number} ]]; then
    echo -e "   ${YELLOW}  No se detectó /dev/video${virtual_camera_number}${NC}"
    echo "     Revisa dmesg para más detalles."
    exit 1
fi

v4l2-ctl --list-devices

echo -e "\n${GREEN}  Configuración completada.${NC}\n"
echo "Dispositivo esperado:"
echo "  /dev/video${virtual_camera_number}"
echo
echo "Siguiente paso:"
echo "  ejecutar el script de captura de pantalla"
echo
echo "Ejemplo:"
echo "  sharescreen /dev/video${virtual_camera_number}"
echo
