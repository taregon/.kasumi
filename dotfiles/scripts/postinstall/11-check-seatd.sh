#!/usr/bin/env bash

# check-seatd.sh
# Valida si seatd está correctamente activado y usable en Arch Linux (para Wayland/Sway/Hyprland/etc.)
# Autor: inspirado en problemas comunes de Arch + seatd

set -euo pipefail

RED='\033[0;31m'      # red
C_OK='\033[0;32m'     # green
C_ACTION='\033[1;33m' # yellow (bold)
C_RST='\033[0m'       # reset

echo -e "${C_ACTION}=== Validación de seatd ===${C_RST}\n"

# 1. Paquete instalado?
if pacman -Qs seatd &> /dev/null; then
    echo -e "${C_OK}✓${C_RST} seatd está instalado ($(pacman -Q seatd | awk '{print $2}'))"
else
    echo -e "${RED}✗${C_RST} seatd NO está instalado. Instálalo con: sudo pacman -S seatd"
    exit 1
fi

# 2. Servicio activo y habilitado?
if systemctl is-active --quiet seatd.service; then
    echo -e "${C_OK}✓${C_RST} seatd.service está activo (running)"
else
    echo -e "${RED}✗${C_RST} seatd.service NO está activo"
    echo "   → Intenta: sudo systemctl start seatd"
fi

if systemctl is-enabled --quiet seatd.service; then
    echo -e "${C_OK}✓${C_RST} seatd.service está habilitado (se inicia al boot)"
else
    echo -e "${C_ACTION}!${C_RST} seatd.service NO está habilitado"
    echo "   → Recomendado: sudo systemctl enable seatd"
fi

# 3. Socket existe y permisos correctos?
SOCKET="/run/seatd.sock"

if [[ -S "$SOCKET" ]]; then
    SOCK_PERMS=$(stat -c "%a" "$SOCKET")
    SOCK_OWNER=$(stat -c "%U:%G" "$SOCKET")
    echo -e "${C_OK}✓${C_RST} Socket existe: $SOCKET"

    echo "   Permisos: $SOCK_PERMS, Propietario: $SOCK_OWNER"

    if [[ "$SOCK_PERMS" == "660" || "$SOCK_PERMS" == "664" ]]; then
        echo -e "   ${C_OK}✓${C_RST} Permisos correctos (rw para propietario y grupo)"
    else
        echo -e "   ${C_ACTION}!${C_RST} Permisos distintos a 660/664 — ideal es srw-rw---- root:seat"
    fi

    if [[ "$SOCK_OWNER" == "root:seat" ]]; then
        echo -e "   ${C_OK}✓${C_RST} Propietario correcto (root:seat)"
    else
        echo -e "   ${C_ACTION}!${C_RST} Propietario distinto a root:seat"
    fi
else
    echo -e "${RED}✗${C_RST} Socket NO existe: $SOCKET"
    echo "   → seatd no está corriendo correctamente o falló al crearlo"
    exit 1
fi

# 4. Usuario en grupo seat?
CURRENT_USER=$(whoami)
if groups | grep -qw seat; then
    echo -e "${C_OK}✓${C_RST} Usuario '$CURRENT_USER' pertenece al grupo 'seat'"
else
    echo -e "${RED}✗${C_RST} Usuario '$CURRENT_USER' NO está en el grupo 'seat'"
    echo "   → Arreglo: sudo usermod -aG seat $CURRENT_USER   (luego logout/reboot)"
fi

# 5. ¿Podemos "acceder" al socket? (chequeo básico de permisos)
if [[ "$(id -u)" -eq 0 ]]; then
    echo -e "${C_OK}✓${C_RST} Socket accesible (ejecutando como root)"
elif [[ -r "$SOCKET" && -w "$SOCKET" ]]; then
    echo -e "${C_OK}✓${C_RST} Socket es accesible (lectura/escritura) para este usuario"
else
    echo -e "${RED}✗${C_RST} Socket NO es accesible (permission denied probable)"
    echo "   → Asegúrate de estar en grupo seat y haber relogueado/reiniciado"
fi

# 6. Logs recientes (últimas 10 líneas relevantes)
echo -e "\n${C_ACTION}Últimos logs de seatd (journalctl -u seatd -n 10):${C_RST}"
journalctl -u seatd -n 10 --no-pager || echo "No hay logs disponibles"

echo -e "\n${C_ACTION}Resumen rápido:${C_RST}"
IS_ACTIVE=$(systemctl is-active --quiet seatd && echo "yes" || echo "no")
HAS_SOCKET=$([[ -S "$SOCKET" ]] && echo "yes" || echo "no")
IN_SEAT_GROUP=$(groups | grep -qw seat && echo "yes" || echo "no")

if [[ "$IS_ACTIVE" == "yes" && "$HAS_SOCKET" == "yes" && "$IN_SEAT_GROUP" == "yes" ]]; then
    echo -e "${C_OK}✓ Todo parece correcto → seatd debería funcionar bien con Sway/Hyprland/etc.${C_RST}"
else
    echo -e "${C_ACTION}! Hay cosas por arreglar (ver arriba). Prueba relogear o reiniciar.${C_RST}"
    [[ "$IS_ACTIVE" != "yes" ]] && echo "   - seatd.service no está activo"
    [[ "$HAS_SOCKET" != "yes" ]] && echo "   - Socket no existe"
    [[ "$IN_SEAT_GROUP" != "yes" ]] && echo "   - Usuario no está en grupo seat"
fi

echo -e "\nPara más depuración: journalctl -b | grep -i seat"
