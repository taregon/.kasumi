#!/usr/bin/env bash
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
#
set -euo pipefail

CONFIG_FILE="/etc/default/btrfsmaintenance"
BACKUP_FILE="${CONFIG_FILE}-$(date +%Y%m%d-%H%M%S).bak"

# ── Colores ────────────────────────────────────────────────
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m"

echo -e "${BLUE}OPTIMIZACIÓN Y MANTENIMIENTO PROACTIVO DE BTRFS EN PARTICIÓN RAÍZ${NC}"
echo -e "${BLUE}Evita bloqueos por falta de espacio para nuevos chunks de metadata${NC}"

# ── Privilegios ────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
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

# ── Respaldo (si existe) ───────────────────────────────────
if [[ -f "$CONFIG_FILE" ]]; then
    echo
    echo "  Creando copia de respaldo:"
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo -e "   ${GREEN}$BACKUP_FILE${NC}"
fi

# ── Escritura de configuración ─────────────────────────────
echo
echo "  Aplicando configuración en:"
echo -e "   ${GREEN}$CONFIG_FILE${NC}"

cat << EOF > "$CONFIG_FILE"
# Configuración recomendada para root Btrfs en NVMe DRAM-less
# Generado por script el $(date '+%Y-%m-%d %H:%M:%S')

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

# ── REFRESH ────────────────────────────────────────────────
echo
echo -e "${YELLOW}  Refrescando configuración de btrfsmaintenance…${NC}"
/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh 2> /dev/null || {
    echo "Nota: el refresh no fue necesario en esta versión."
}

# ── TIMERS ─────────────────────────────────────────────────
echo
echo "  Verificando timers de mantenimiento:"

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
echo "  Resumen de estado:"
systemctl list-timers | grep btrfs || true
echo
echo "  Listo!"
