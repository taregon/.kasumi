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
- Configuracion rmpc, temas RON y terminal (Kitty).

## Entorno

### Gestor de paquetes

- `paru` es el helper AUR estandar del repo; no reemplazarlo por `yay`.
- Usar `pacman` para repos oficiales, `paru` para AUR o listas mixtas.
- Usar `--needed` en instalaciones cuando aplique.

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
