#!/usr/bin/env bash
# https://blog.programster.org/btrfs-cheatsheet
# Este script crea o reemplaza el archivo /etc/default/btrfsmaintenance con valores
# optimizados para un sistema con particiones Btrfs separadas
#
# - Realiza un respaldo automático del archivo existente (si lo hay) antes de sobrescribir.
# - Genera un archivo nuevo con configuración explícita y limpia (sin depender de parsing complejo).
# - Ajusta tareas de mantenimiento para ser conservadoras pero efectivas:
#   - Scrub mensual en root y /home (chequeo de integridad con reparación automática).
#   - Balance mensual suave (umbrales 65–85 para reclaim de chunks sin sobrecarga IO).
#   - TRIM semanal en root y /home (crucial para rendimiento y longevidad del NVMe).
#   - Defrag desactivado (no recomendado en SSD).
# - Los timers generados por btrfsmaintenance (btrfs-scrub.timer, btrfs-balance.timer, btrfs-trim.timer)
#   son no-templados (sin @) y aplican globalmente a los mountpoints listados en el archivo.
# - El alcance y comportamiento se definen 100% en /etc/default/btrfsmaintenance:
#   - No se necesita especificar mountpoints en el nombre del timer.
#   - La selección de volúmenes ocurre en tiempo de ejecución según las variables *_MOUNTPOINTS.
# - Después de crear/actualizar el archivo, refresca la configuración con:
#   sudo /usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh
#   ❯ btrfs device stats /
#   ❯ btrfs device stats /home
set -euo pipefail

# ── Colores ────────────────────────────────────────────────
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m"

CONFIG_FILE="/etc/default/btrfsmaintenance"
BACKUP_FILE="${CONFIG_FILE}-$(date +%Y%m%d-%H%M%S).bak"
THRESHOLD=80

TMP_DIR=$(mktemp -d) || {
    echo "  Error creando directorio temporal"
    exit 1
}
TMP_CONFIG="$TMP_DIR/btrfsmaintenance.tmp"

# ────────────────────────────────────────────────────────────
echo "${TMP_CONFIG}"
echo -e "${BLUE}OPTIMIZACIÓN Y MANTENIMIENTO PROACTIVO DE BTRFS${NC}"
echo -e "${BLUE}Evita bloqueos por falta de espacio${NC}"
echo -e "${BLUE}para nuevos chunks de metadata${NC}"

# ── Privilegios ────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    echo
    echo "  Este script debe ejecutarse como root."
    echo "Ejemplo: sudo $0"
    exit 1
fi

# ── Dependencia ────────────────────────────────────────────
if ! pacman -Q btrfsmaintenance &> /dev/null; then
    echo
    echo "  btrfsmaintenance no está instalado. Instalando…"
    pacman -S --needed --noconfirm btrfsmaintenance
else
    echo
    echo "  btrfsmaintenance ya está instalado."
fi

# ─[ AJUSTES BTRFSMAINTENANCE ]───────────────────────────────
cat << EOF > "$TMP_CONFIG"
# Configuración recomendada para root Btrfs en NVMe DRAM-less

BTRFS_LOG_OUTPUT="journal"

# ────────────────────────────────────────────────────────────
# Balance: mensual, umbrales conservadores
BTRFS_BALANCE_MOUNTPOINTS="/ /home"
BTRFS_BALANCE_PERIOD="monthly"
BTRFS_BALANCE_DUSAGE="65 85"
BTRFS_BALANCE_MUSAGE="65"

# ────────────────────────────────────────────────────────────
# Scrub: mensual, prioridad baja
BTRFS_SCRUB_MOUNTPOINTS="/ /home"
BTRFS_SCRUB_PERIOD="monthly"
BTRFS_SCRUB_PRIORITY="idle"
BTRFS_SCRUB_READ_ONLY="false"

# ────────────────────────────────────────────────────────────
# TRIM: semanal (clave en SSD/NVMe sin DRAM)
BTRFS_TRIM_MOUNTPOINTS="/ /home"
BTRFS_TRIM_PERIOD="weekly"
BTRFS_TRIM_ARGS="--verbose"

# ────────────────────────────────────────────────────────────
# Defrag: desactivado
BTRFS_DEFRAG_PERIOD="none"

# ────────────────────────────────────────────────────────────
# Evita concurrencia para no saturar I/O
BTRFS_ALLOW_CONCURRENCY="false"
EOF

# ── BACKUP PREVIO ───────────────────────────────────────────
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo
    echo "${YELLOW}  Creando archivo de configuración ${NC}"
    mv "$TMP_CONFIG" "$CONFIG_FILE" || {
        echo "Error moviendo temporal"
        exit 1
    }
elif cmp -s "$CONFIG_FILE" "$TMP_CONFIG"; then
    echo
    echo "  Sin ajustes nuevos"
    rm "$TMP_CONFIG"
else
    echo
    echo "${YELLOW}  Cambios detectados.${NC} Creando respaldo..."
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    mv "$TMP_CONFIG" "$CONFIG_FILE"
fi

# ── REFRESH ────────────────────────────────────────────────
echo
echo -e "${YELLOW}  Refrescando configuración de btrfsmaintenance…${NC}"

if [ -x /usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh ]; then
    /usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh 2> /dev/null
else
    echo "Nota: esta versión no incluye refresh de cron."
fi

# ── TIMERS ─────────────────────────────────────────────────
echo
echo "  Verificando timers de mantenimiento:"

for timer in \
    btrfs-scrub.timer \
    btrfs-trim.timer \
    btrfs-balance.timer; do
    if systemctl list-unit-files --type=timer | awk '{print $1}' | grep -qx "$timer"; then
        if systemctl is-enabled --quiet "$timer"; then
            if systemctl is-active --quiet "$timer"; then
                echo -e "   ${GREEN} ${NC} $timer activo"
            else
                echo -e "   ${YELLOW} ${NC} $timer habilitado, iniciando…"
                systemctl start "$timer"
            fi
        else
            echo -e "   ${YELLOW} ${NC} $timer habilitando y arrancando…"
            systemctl enable --now "$timer"
        fi
    else
        echo -e "   ${YELLOW} ${NC} $timer no existe en este sistema"
    fi
done

echo
echo -e "${YELLOW}  Próxima ejecución de mantenimiento Btrfs:${NC}"
systemctl list-timers | grep btrfs || true

# ─[ PURGAR CACHE ]───────────────────────────────────────────
# Limpiar con paccache los paquetes que se almacena en /var/cache/pacman/pkg/
#  r: Borra versiones antiguas de paquetes instalados
#  u: Borra paquetes que ya no están instalados
#  k: Mantiene solo las últimas N versiones de cada paquete instalado
echo
echo "  Limpiando caché pacman (manteniendo 2 versiones)"
sudo paccache -ruk2

# ─[ LIMPIAR LOGS DEL SISTEMA ]───────────────────────────────
#  --vacuum-time=8weeks: Borra todos los logs más antiguos de 8 semanas (protege los recientes).
#  --vacuum-size=200M: Limita el tamaño total del journal a un máximo de ~200 MiB.
# Combinado: Si después de aplicar el tiempo aún excede 200 MiB,
# borra logs más antiguos dentro de las 8 semanas.
echo
echo "  Limpiando journal antiguo"
sudo journalctl --vacuum-time=8weeks --vacuum-size=200M

# ─[ ELIMINAR HUÉRFANOS ]─────────────────────────────────────
# Elimina paquetes huérfanos (instalados como dependencias y ya no requeridos).
echo
echo "  Eliminando paquetes huérfanos"

mapfile -t orphans < <(pacman -Qtdq)

if [ ${#orphans[@]} -gt 0 ]; then
    sudo pacman -Rns --quiet --noconfirm "${orphans[@]}"
else

    echo "No hay paquetes huérfanos..."
fi

# ── REDISTRIBUCIÓN DE BLOQUES DE DATOS Y METADATOS ──────────
declare -A BTRFS_SEEN

findmnt -rn -t btrfs -o TARGET,UUID | while read -r BTRFS_MP BTRFS_UUID; do
    [[ -z "$BTRFS_UUID" ]] && continue

    # Evitar procesar el mismo filesystem más de una vez
    [[ -n "${BTRFS_SEEN[$BTRFS_UUID]+x}" ]] && continue
    BTRFS_SEEN[$BTRFS_UUID]=1

    echo
    echo -e "${BLUE}=== BALANCE DE BTRFS ===${NC}"
    echo "      UUID : $BTRFS_UUID"
    echo -e "${YELLOW}Mountpoint : $BTRFS_MP${NC}"
    echo "    Estado :"

    printf '%b' "$BLUE"
    df -h "$BTRFS_MP"
    printf '%b' "$NC"

    btrfs filesystem usage "$BTRFS_MP" | grep -E \
        "Device allocated|Unallocated|Free \(statfs|Data.*Used|Metadata.*Used"

    BTRFS_USE=$(df "$BTRFS_MP" | awk 'NR==2 {print $5}' | tr -d '%')

    echo
    if ((BTRFS_USE > THRESHOLD)); then
        echo "${YELLOW}  Uso alto (${BTRFS_USE}%).${NC} Ejecutando balance suave…"
        sudo btrfs balance start -musage=65 -dusage=65 "$BTRFS_MP"
        echo "  Balance finalizado."
    else
        echo -e "${GREEN}  Uso bajo (${BTRFS_USE}%).${NC} No se ejecuta balance."
    fi
done

echo
echo "  Listo!"
