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
fg_blue="\033[0;34m"
fg_green="\033[0;32m"
fg_yellow="\033[0;33m"
fg_reset="\033[0m"

echo -e "\n${fg_blue}  Instalando dependencias...${fg_reset}\n"

paru -S --needed --noconfirm \
    wf-recorder \
    v4l2loopback-dkms \
    v4l2loopback-utils \
    v4l-utils \
    jq > /dev/null

# ── Carga automática del módulo ─────────────────────────────

echo -e "\n${fg_blue}  Configurando persistencia del módulo...${fg_reset}\n"

echo -e "   ${fg_yellow}  /etc/modules-load.d/v4l2loopback.conf${fg_reset}"

sudo tee /etc/modules-load.d/v4l2loopback.conf > /dev/null << EOF
v4l2loopback
EOF

echo -e "   ${fg_yellow}  /etc/modprobe.d/v4l2loopback.conf${fg_reset}"

sudo tee /etc/modprobe.d/v4l2loopback.conf > /dev/null << EOF
options v4l2loopback \
  devices=1 \
  video_nr=${virtual_camera_number} \
  card_label="${virtual_camera_name}" \
  exclusive_caps=1
EOF

# ────────────────────────────────────────────────────────────
echo -e "\n${fg_blue}  Reiniciando módulo v4l2loopback...${fg_reset}\n"

sudo modprobe -r v4l2loopback 2> /dev/null || true # módulo podría no estar cargado aún
sudo modprobe v4l2loopback

sleep 1
if [[ ! -e /dev/video${virtual_camera_number} ]]; then
    echo -e "   ${fg_yellow}  No se detectó /dev/video${virtual_camera_number}${fg_reset}"
    echo "     Revisa dmesg para más detalles."
    exit 1
fi

v4l2-ctl --list-devices

echo -e "\n${fg_green}  Configuración completada.${fg_reset}\n"
echo -e "Dispositivo esperado:\n  /dev/video${virtual_camera_number}\n"
echo -e "Siguiente paso:\n  ejecutar el script de captura de pantalla\n"
echo -e "Ejemplo:\n  sharescreen /dev/video${virtual_camera_number}\n"
