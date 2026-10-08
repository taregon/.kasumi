# Convenciones para scripts shell, helpers zsh y configuracion

## Contexto

### Skills del repositorio

| Skill                   | Trigger                                                  |
| :---------------------- | :------------------------------------------------------- |
| `kasumi-rmpc`           | Al editar archivos `.ron` de rmpc                        |
| `kasumi-output-format`  | Al crear/modificar scripts con salida de terminal        |
| `kasumi-file-safety`    | Al manipular archivos o ejecutar scripts con rm          |
| `kasumi-ascii-diagrams` | Al documentar layouts o jerarquías visuales              |
| `box-comments`          | Al generar comentarios decorativos en cualquier lenguaje |

### Alcance

Dotfiles para Arch Linux (pacman/paru, Sway/Wayland, Kitty, rmpc, dotdrop). No
asumir convenciones de otros sistemas operativos o gestores de paquetes.

- Scripts bash en `dotfiles/scripts/`, `dotfiles/config/*/scripts/`.
- Helpers zsh en `dotfiles/config/zsh/funcs/` (reglas en su `AGENTS.md`).
- Helpers ejecutables en `dotfiles/scripts/helpers/` (symlink
  `~/.local/bin/kasumi/helpers/`, presente en PATH).
- Configuracion rmpc, temas RON y terminal (Kitty).

### Dotdrop

`config.yaml` es la fuente de verdad. `dotpath: dotfiles` — `src` relativo a
`dotfiles/`, `dst` absoluto en `HOME` (`~`).

- Claves: `d_*` para directorios, `f_*` para ficheros. `link: absolute`.
- `profiles`: `kasumi` (base), `kasumi_extras`, `kasumi_wayland`. Selección
  con `-p <perfil>`.
- `impignore`/`upignore`: patrones globales a ignorar en import/update
  (ej: `*.socket`, `.zcompdump*`).

Comandos mínimos (ejecutar desde raíz del repo):

```bash
dotdrop compare -p kasumi              # diff sin escribir
dotdrop install -p kasumi              # crear symlinks según src→dst
dotdrop compare -p kasumi_extras       # verificar extras
dotdrop update <ruta-en-HOME>          # importar cambio de HOME al repo
dotdrop import -p kasumi <ruta>        # nuevo dotfile → genera entrada en config.yaml
```

Ejemplo genérico mínimo (inferir por analogía):

```yaml
dotfiles:
  d_example:
    src: config/example
    dst: ~/.config/example
    link: absolute
  f_example:
    src: example.conf
    dst: ~/.example.conf
    link: absolute
profiles:
  kasumi:
    dotfiles: [d_example]
  kasumi_extras:
    dotfiles: [f_example]
```

Reglas:

- Añadir nuevos dotfiles vía `dotdrop import`, no editando `config.yaml` a mano
  salvo ajustes de `link`/`chmod`.
- Verificar con `compare` antes de `install`; `install` es idempotente.
- `~/.config/zsh` y `~/.zshenv` ilustran `d_*` vs `f_*`; `zshenv` bootstrap
  solo `ZDOTDIR`, el resto en `$ZDOTDIR`.

## Entorno

### Gestor de paquetes

- `paru` es el helper AUR estandar del repo; no reemplazarlo por `yay`.
- Usar `pacman` para repos oficiales, `paru` para AUR o listas mixtas.
- Usar `--needed` en instalaciones cuando aplique.
- Los paquetes NVIDIA 580xx (`nvidia-580xx-utils`, `nvidia-580xx-dkms`,
  `nvidia-580xx-settings`, `opencl-nvidia-580xx`, `libxnvctrl-580xx`) estan en
  `IgnorePkg` de pacman; `paru -Syu` no los actualiza. No intentar actualizarlos
  con paru. Usar `dotfiles/scripts/helpers/nvidia-update`, que los actualiza de
  forma atomica y fail-stop (transaccion unica de `pacman -U`).

### Herramientas graficas

- Preferir herramientas nativas Wayland; no proponer equivalentes X11.
- Mantener `rofi` como launcher/selector estandar; no reemplazarlo sin peticion
  explicita.
- Usar `systemctl --user` y variables de entorno Wayland cuando el servicio
  pertenezca a la sesion grafica.

## Organización

### Estructura de archivos

- Usar prefijo `NN-` para scripts con orden de ejecucion.
- Omitir prefijo en scripts opcionales.

### Codigo legacy

- `scripts-legacy/`, `.bk` y `.old` son referencia para migracion. No usar como
  patron si existe version activa equivalente.
