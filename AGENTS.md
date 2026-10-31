# KASUMI dotfiles — AGENTS

Contexto: Arch Linux (pacman/paru, Sway/Wayland, Kitty, rmpc, dotdrop).
Convenciones de este sistema y gestor de paquetes.

## Paths

- scripts bash: `dotfiles/scripts/`, `dotfiles/config/*/scripts/`
- helpers zsh: `dotfiles/config/zsh/funcs/`
- ejecutables: `dotfiles/scripts/helpers/` → `~/.local/bin/kasumi/helpers/` (en
  PATH)

## Dotdrop

- `config.yaml` es la fuente de verdad. `dotpath: dotfiles` — `src` relativo a
  `dotfiles/`, `dst` absoluto en `HOME`.
- keys: `d_*` dirs, `f_*` files. `link: absolute`.
- profiles: `kasumi`, `kasumi_extras`, `kasumi_wayland` (independientes; un
  `-p <profile>` por ejecución).
- leer `kas-guides/dotdrop.md` en full antes de operar.

## Environment

### Packages

- `paru` = standard AUR helper. `pacman` para repos oficiales, `paru` para
  AUR/mixed. Usar `--needed` en instalaciones.
- NVIDIA 580xx (`nvidia-580xx-utils`, `-dkms`, `-settings`,
  `opencl-nvidia-580xx`, `libxnvctrl-580xx`) en `IgnorePkg`; actualizar solo vía
  `dotfiles/scripts/helpers/nvidia-update` (atomic, fail-stop, transacción única
  de `pacman -U`).

### Graphics

- preferir herramientas nativas Wayland.
- `rofi` = standard launcher/selector.
- usar `systemctl --user` + env vars Wayland para servicios de sesión gráfica.

## Organization

### Files

- prefijo `NN-` para secuencias ordenadas (`postinstall/`, `config.d/`,
  `kasumi.d/`).
- sin prefijo para scripts/helpers sueltos.

### Legacy

- `.old` son referencia de migración; usar equivalentes activos cuando existan.
