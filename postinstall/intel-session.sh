#!/usr/bin/env bash
# crear-sway-intel-session.sh
# Genera la sesión personalizada "Sway (Intel GPU)" para Ly
# Apunta explícitamente a /dev/dri/card1 (única tarjeta detectada)

set -euo pipefail

SESSION_FILE="/etc/ly/custom-sessions/sway-intel.desktop"
SESSION_DIR="$(dirname "$SESSION_FILE")"

echo "Creando directorio si no existe: $SESSION_DIR"
sudo mkdir -p "$SESSION_DIR"

echo "Generando archivo: $SESSION_FILE"

cat << 'EOF' | sudo tee "$SESSION_FILE" > /dev/null
[Desktop Entry]
Name=Sway (Intel GPU)
Comment=Sway Wayland compositor - Forzado a GPU Intel integrada
# Exec=/usr/bin/env DRI_PRIME=0 GBM_BACKEND=i915 __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json __GLX_VENDOR_LIBRARY_NAME=mesa WLR_DRM_DEVICES=/dev/dri/card0 sway
Exec=env WLR_DRM_DEVICES=/dev/dri/card1 sway
Type=Application
DesktopNames=sway-intel
Terminal=false
EOF

echo "Asignando permisos correctos (644, root:root)"
sudo chmod 644 "$SESSION_FILE"
sudo chown root:root "$SESSION_FILE"

echo ""
echo "Archivo creado correctamente:"
ls -l "$SESSION_FILE"
echo ""
echo "Reinicia Ly para que aparezca la nueva sesión:"
echo "  sudo systemctl restart ly"
echo ""
echo "O reinicia el equipo:"
echo "  sudo reboot"
echo ""
echo "Luego selecciona 'Sway (Intel GPU)' en Ly."
echo ""
echo "Verifica después de entrar:"
echo "  glxinfo | grep \"OpenGL renderer\""
