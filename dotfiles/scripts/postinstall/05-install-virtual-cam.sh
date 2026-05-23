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

echo -e "\n==> Instalando dependencias...\n"

paru -S --needed \
    wf-recorder \
    v4l2loopback-dkms \
    v4l2loopback-utils \
    v4l-utils \
    jq

# ────────────────────────────────────────────────────────────
# Carga automática del módulo al iniciar sistema.

echo "  [config]  /etc/modules-load.d/v4l2loopback.conf"

sudo tee /etc/modules-load.d/v4l2loopback.conf > /dev/null << EOF
v4l2loopback
EOF

# ────────────────────────────────────────────────────────────
# Parámetros persistentes del dispositivo virtual.

echo "  [config]  /etc/modprobe.d/v4l2loopback.conf"

sudo tee /etc/modprobe.d/v4l2loopback.conf > /dev/null << EOF
options v4l2loopback \
  devices=1 \
  video_nr=${virtual_camera_number} \
  card_label="${virtual_camera_name}" \
  exclusive_caps=1
EOF

echo -e "\n==> Reiniciando módulo v4l2loopback...\n"

sudo modprobe -r v4l2loopback 2> /dev/null || true
sudo modprobe v4l2loopback

sleep 1
if [[ ! -e /dev/video${virtual_camera_number} ]]; then
    echo "ERROR: No se detectó /dev/video${virtual_camera_number}"
    echo "Revisa dmesg para más detalles."
    exit 1
fi

v4l2-ctl --list-devices

echo -e "\n==> Configuración completada.\n"
echo "Dispositivo esperado:"
echo "  /dev/video${virtual_camera_number}"
echo
echo "Siguiente paso:"
echo "  ejecutar el script de captura de pantalla"
echo
echo "Ejemplo:"
echo "  sharescreen /dev/video${virtual_camera_number}"
echo
