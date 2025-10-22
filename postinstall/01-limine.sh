#!/bin/bash
# Agrega configuración de fondo a /boot/EFI/limine/limine.conf
# sin borrar el contenido existente y creando un respaldo previo.

set -euo pipefail # Detenerse ante cualquier error y definir variables antes de usarlas

LIMINE_CONF="/boot/EFI/limine/limine.conf"
LIMINE_BACK="${LIMINE_CONF}.bak"
WALLPAPER_DST="/boot/EFI/limine/wallpaper.jpg"
WALLPAPER_SRC=~/.kasumi/wallpaper/wall_134239802.jpg

# ─[ Ajustes para el wallpaper ]──────────────────────────────
WALL_CONF=$(
    cat << 'EOF'
# LIMINE WALLPAPER
wallpaper: boot():/EFI/limine/wallpaper.jpg
wallpaper_style: centered
# ────────────────────────────────────────────────────────────
EOF
)

# ─[ Verificación ]───────────────────────────────────────────
if [ ! -f "$LIMINE_CONF" ]; then
    echo "  No se encontró $LIMINE_CONF"
    exit 1
fi

if [ ! -f "$WALLPAPER_SRC" ]; then
    echo "  No se encontró el wallpaper en: $WALLPAPER_SRC"
    exit 1
fi

# ─[ Mensajes ]───────────────────────────────────────────────
echo "Agregando configuración del fondo de pantalla en Limine,"
echo "  Creando respaldo en: $LIMINE_BACK"
sudo cp "$LIMINE_CONF" "$LIMINE_BACK"

echo "  Insertando ajustes..."

# Comprueba si el bloque ya existe
if ! grep -Fq "$WALL_CONF" "$LIMINE_CONF"; then
    # Insertar al inicio
    if {
        printf "%s\n" "$WALL_CONF"
        cat "$LIMINE_CONF"
    } | sudo tee "${LIMINE_CONF}.tmp" > /dev/null \
        && sudo mv "${LIMINE_CONF}.tmp" "$LIMINE_CONF"; then
        echo "  Archivo modificado correctamente"
    else
        echo "  Error al modificar el archivo"
        exit 1
    fi
else
    echo "  Bloque ya insertado, no se hace nada"
fi

echo "  Copiando wallpaper a: $WALLPAPER_DST"
sudo cp "$WALLPAPER_SRC" "$WALLPAPER_DST"

echo
echo "  Actualización completada."
