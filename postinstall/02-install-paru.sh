#!/usr/bin/env bash
set -euo pipefail

# Script para instalar Paru desde AUR con aislamiento y limpieza controlada.
# Ejecutar con privilegios de administrador.

# 1. Verificar dependencias base antes de clonar el repositorio
pacman -Qs base-devel > /dev/null 2>&1 || sudo pacman -S --needed base-devel
pacman -Qs git > /dev/null 2>&1 || sudo pacman -S --needed git

# 2. Preparar entorno temporal y aislado
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
cd "$tmp_dir"

# 3. Clonar el repositorio oficial de Paru
git clone https://aur.archlinux.org/paru.git
cd paru

# 4. Ejecutar makepkg sin privilegios elevados
makepkg -si --noconfirm

# 5. Limpiar el árbol de construcción
cd "$tmp_dir"
rm -rf paru

echo "  Instalación completada."
echo "Paru está disponible en el sistema."
