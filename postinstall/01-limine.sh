#!/bin/bash
# Agrega configuración de fondo a /boot/EFI/limine/limine.conf
# sin borrar el contenido existente y creando un respaldo previo.

set -e # Detenerse ante cualquier error

LIMINE_CONF="/boot/EFI/limine/limine.conf"
LIMINE_BACK="${LIMINE_CONF}.bak"
LIMINE_TEMP="${LIMINE_CONF}.tmp"
WALLPAPER_DST="/boot/EFI/limine/wallpaper.jpg"
WALLPAPER_SRC=~/.kasumi/wallpaper/wall_134239802.jpg

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
echo "  Creando respaldo en: $LIMINE_BACK"
sudo cp "$LIMINE_CONF" "$LIMINE_BACK"

echo "  Insertando ajustes en limine..."
printf '# Fondo\nwallpaper: boot():/EFI/limine/wallpaper.jpg\nwallpaper_style: centered\n\n' \
    | cat - "$LIMINE_CONF" | sudo tee "$LIMINE_TEMP" > /dev/null && sudo mv "$LIMINE_TEMP" "$LIMINE_CONF"

echo "  Copiando wallpaper a: $WALLPAPER_DST"
sudo cp "$WALLPAPER_SRC" "$WALLPAPER_DST"

echo
echo "  Actualización completada."
