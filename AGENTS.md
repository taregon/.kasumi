# KASUMI dotfiles

Dotdrop administra los archivos de configuración del usuario desde `dotfiles/` y
los despliega en `HOME`. Antes de operarlo, leer `kas-guides/dotdrop.md`.
`dotdrop/` contiene el submódulo upstream; la configuración propia vive en
`config.yaml`, `actions.d/`, `dotfiles/` y `kas-guides/`.

## Sistema

- Arch Linux; `pacman` gestiona paquetes oficiales y `paru` paquetes AUR o
  instalaciones mixtas. Las instalaciones de paquetes usan `--needed`.
- NVIDIA 580xx está en `IgnorePkg`. Actualizar esos paquetes únicamente con
  `dotfiles/scripts/helpers/nvidia-update`, que compila el conjunto y lo instala
  en una sola transacción `pacman -U`.
- En Sway/Wayland, preferir herramientas nativas de Wayland.
- `rofi` es el selector estándar.
- `systemctl --user` gestiona los servicios gráficos de sesión;
  `dotfiles/config/sway/config.d/00-environment.conf` importa las variables
  Wayland al entorno de usuario.

## Organización

- Usar prefijos `NN-` para secuencias ordenadas, como `postinstall/`,
  `config.d/` y `kasumi.d/`. Los scripts y helpers independientes no llevan
  prefijo.
- Los archivos `.old` sirven como referencia de migración; preferir el
  equivalente activo cuando exista.

## Rutas principales

| Tipo                    | Ruta                                                                     |
| ----------------------- | ------------------------------------------------------------------------ |
| Scripts bash            | `dotfiles/scripts/`, `dotfiles/config/*/scripts/`                        |
| Helpers zsh             | `dotfiles/config/zsh/funcs/` (reglas locales en su `AGENTS.md`)          |
| Ejecutables compartidos | `dotfiles/scripts/helpers/` → `~/.local/bin/kasumi/helpers/` (en `PATH`) |
