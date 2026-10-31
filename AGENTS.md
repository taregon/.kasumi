# Configuración de los dotfiles KASUMI

Dotfiles para Arch Linux (pacman/paru, Sway/Wayland, Kitty, rmpc, dotdrop). No
asumir convenciones de otros sistemas operativos ni gestores de paquetes.

- Scripts bash en `dotfiles/scripts/`
- Helpers zsh en `dotfiles/config/zsh/funcs/`
- Helpers ejecutables en `dotfiles/scripts/helpers/`, enlazados en
  `~/.local/bin/kasumi/helpers/` y presentes en `PATH`

## Dotdrop

Dotdrop es un gestor de dotfiles: almacena cada dotfile una sola vez y lo
despliega con contenido variable según host o configuración.

`config.yaml` es la fuente de verdad. `dotpath: dotfiles` — `src` relativo a
`dotfiles/`, `dst` absoluto en `HOME` (`~`).

- Claves: `d_*` para directorios, `f_*` para ficheros. `link: absolute`.
- Perfiles: `kasumi`, `kasumi_extras` y `kasumi_wayland` independientes, sin
  `include`; cada invocación usa un solo `-p <perfil>`.

Antes de operar con dotdrop, leer `kas-guides/dotdrop.md` en full.

## Entorno

### Gestor de paquetes

- `paru` es el helper AUR estándar del repo.
- Usar `pacman` para repos oficiales, `paru` para AUR o listas mixtas, con
  `--needed` en instalaciones.
- Los paquetes NVIDIA 580xx (`nvidia-580xx-utils`, `nvidia-580xx-dkms`,
  `nvidia-580xx-settings`, `opencl-nvidia-580xx`, `libxnvctrl-580xx`) están en
  `IgnorePkg` de pacman; `paru -Syu` no los actualiza. Actualizarlos solo con
  `dotfiles/scripts/helpers/nvidia-update`, que los actualiza de forma atómica y
  fail-stop (transacción única de `pacman -U`).

### Herramientas gráficas

- Preferir herramientas nativas Wayland.
- Mantener `rofi` como launcher/selector estándar.

## Organización

### Estructura de archivos

- Usar prefijo `NN-` en secuencias ordenadas: `dotfiles/scripts/postinstall/` y
  fragmentos de configuración (`config.d/`, `kasumi.d/`).
- Omitir prefijo en scripts sueltos y helpers.

### Código legacy

- Los archivos `.old` son referencia de migración; no usarlos como patrón si
  existe versión activa equivalente.
