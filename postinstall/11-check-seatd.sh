#!/usr/bin/env bash

# check-seatd.sh
# Valida si seatd está correctamente activado y usable en Arch Linux (para Wayland/Sway/Hyprland/etc.)
# Autor: inspirado en problemas comunes de Arch + seatd

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Validación de seatd ===${NC}\n"

# 1. Paquete instalado?
if pacman -Qs seatd &> /dev/null; then
    echo -e "${GREEN}✓${NC} seatd está instalado ($(pacman -Q seatd | awk '{print $2}'))"
else
    echo -e "${RED}✗${NC} seatd NO está instalado. Instálalo con: sudo pacman -S seatd"
    exit 1
fi

# 2. Servicio activo y habilitado?
if systemctl is-active --quiet seatd.service; then
    echo -e "${GREEN}✓${NC} seatd.service está activo (running)"
else
    echo -e "${RED}✗${NC} seatd.service NO está activo"
    echo "   → Intenta: sudo systemctl start seatd"
fi

if systemctl is-enabled --quiet seatd.service; then
    echo -e "${GREEN}✓${NC} seatd.service está habilitado (se inicia al boot)"
else
    echo -e "${YELLOW}!${NC} seatd.service NO está habilitado"
    echo "   → Recomendado: sudo systemctl enable seatd"
fi

# 3. Socket existe y permisos correctos?
SOCKET="/run/seatd.sock"

if [[ -S "$SOCKET" ]]; then
    SOCK_PERMS=$(stat -c "%a" "$SOCKET")
    SOCK_OWNER=$(stat -c "%U:%G" "$SOCKET")
    echo -e "${GREEN}✓${NC} Socket existe: $SOCKET"

    echo "   Permisos: $SOCK_PERMS, Propietario: $SOCK_OWNER"

    if [[ "$SOCK_PERMS" == "660" || "$SOCK_PERMS" == "664" ]]; then
        echo -e "   ${GREEN}✓${NC} Permisos correctos (rw para propietario y grupo)"
    else
        echo -e "   ${YELLOW}!${NC} Permisos distintos a 660/664 — ideal es srw-rw---- root:seat"
    fi

    if [[ "$SOCK_OWNER" == "root:seat" ]]; then
        echo -e "   ${GREEN}✓${NC} Propietario correcto (root:seat)"
    else
        echo -e "   ${YELLOW}!${NC} Propietario distinto a root:seat"
    fi
else
    echo -e "${RED}✗${NC} Socket NO existe: $SOCKET"
    echo "   → seatd no está corriendo correctamente o falló al crearlo"
    exit 1
fi

# 4. Usuario en grupo seat?
CURRENT_USER=$(whoami)
if groups | grep -qw seat; then
    echo -e "${GREEN}✓${NC} Usuario '$CURRENT_USER' pertenece al grupo 'seat'"
else
    echo -e "${RED}✗${NC} Usuario '$CURRENT_USER' NO está en el grupo 'seat'"
    echo "   → Arreglo: sudo usermod -aG seat $CURRENT_USER   (luego logout/reboot)"
fi

# 5. ¿Podemos "acceder" al socket? (chequeo básico de permisos)
if [[ "$(id -u)" -eq 0 ]]; then
    echo -e "${GREEN}✓${NC} Socket accesible (ejecutando como root)"
elif [[ -r "$SOCKET" && -w "$SOCKET" ]]; then
    echo -e "${GREEN}✓${NC} Socket es accesible (lectura/escritura) para este usuario"
else
    echo -e "${RED}✗${NC} Socket NO es accesible (permission denied probable)"
    echo "   → Asegúrate de estar en grupo seat y haber relogueado/reiniciado"
fi

# 6. Logs recientes (últimas 10 líneas relevantes)
echo -e "\n${YELLOW}Últimos logs de seatd (journalctl -u seatd -n 10):${NC}"
journalctl -u seatd -n 10 --no-pager || echo "No hay logs disponibles"

echo -e "\n${YELLOW}Resumen rápido:${NC}"
IS_ACTIVE=$(systemctl is-active --quiet seatd && echo "yes" || echo "no")
HAS_SOCKET=$([[ -S "$SOCKET" ]] && echo "yes" || echo "no")
IN_SEAT_GROUP=$(groups | grep -qw seat && echo "yes" || echo "no")

if [[ "$IS_ACTIVE" == "yes" && "$HAS_SOCKET" == "yes" && "$IN_SEAT_GROUP" == "yes" ]]; then
    echo -e "${GREEN}✓ Todo parece correcto → seatd debería funcionar bien con Sway/Hyprland/etc.${NC}"
else
    echo -e "${YELLOW}! Hay cosas por arreglar (ver arriba). Prueba relogear o reiniciar.${NC}"
    [[ "$IS_ACTIVE" != "yes" ]] && echo "   - seatd.service no está activo"
    [[ "$HAS_SOCKET" != "yes" ]] && echo "   - Socket no existe"
    [[ "$IN_SEAT_GROUP" != "yes" ]] && echo "   - Usuario no está en grupo seat"
fi

echo -e "\nPara más depuración: journalctl -b | grep -i seat"
