#!/bin/bash

CONF="/etc/pacman.conf"
BACK="/etc/pacman.conf.bak.$(date +%Y%m%d%H%M%S)"

# Crear copia de seguridad
sudo cp "$CONF" "$BACK"
echo "Copia de seguridad creada en $BACK"

# Función para insertar línea si no existe
add_opt() {
    local line="$1"
    local opt
    # Verificar si la opción ya existe (sin el valor)
    opt=$(echo "$line" | cut -d '=' -f1)

    if ! grep -q -E "^$opt=" "$CONF"; then
        # Inserta después de la línea [options]
        sudo sed -i "/^\[options\]/a $line" "$CONF"
        echo "  Opción agregada: $line"
    else
        echo "  Opción ya existe: $opt"
    fi
}

# Opciones a agregar
add_opt "Color"
add_opt "ILoveCandy"
add_opt "VerbosePkgLists"

echo
echo "  Configuración actualizada."
