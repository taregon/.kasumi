# KASUMI dotfiles

Dotdrop administra los archivos de configuración del usuario desde `dotfiles/` y
los despliega en `HOME`. Para operarlo, sigue `kas-guides/dotdrop.md`.

## Sistema

- Arch Linux; `pacman` gestiona paquetes oficiales y `paru` paquetes AUR o
  instalaciones mixtas. Las instalaciones usan `--needed`.
- NVIDIA 580xx está en `IgnorePkg`. Actualizar esos paquetes únicamente con
  `dotfiles/scripts/helpers/nvidia-update`, que compila el conjunto y lo instala
  en una sola transacción `pacman -U`.
- En Sway/Wayland, preferir herramientas nativas de Wayland. `rofi` es el
  selector estándar; los servicios gráficos de sesión se gestionan con
  `systemctl --user` y el entorno Wayland.

## Organización

- Usar prefijos `NN-` para secuencias ordenadas, como `postinstall/`,
  `config.d/` y `kasumi.d/`. Los scripts y helpers independientes no llevan
  prefijo.
- Los archivos `.old` sirven como referencia de migración; preferir el
  equivalente activo cuando exista.

## Rutas principales

| Tipo                    | Ruta                                                            |
| ----------------------- | --------------------------------------------------------------- |
| Scripts bash            | `dotfiles/scripts/`, `dotfiles/config/*/scripts/`               |
| Helpers zsh             | `dotfiles/config/zsh/funcs/` (reglas locales en su `AGENTS.md`) |
| Ejecutables compartidos | `dotfiles/scripts/helpers/`                                     |
