# Dotdrop (guía de operación)

Gestor de dotfiles: almacena cada dotfile una sola vez y lo despliega con
contenido variable según host o configuración.

## Configuración

- `config.yaml` es la fuente de verdad. `dotpath: dotfiles` — `src` relativo a
  `dotfiles/`, `dst` absoluto en `HOME`.
- Claves: `d_*` directorios, `f_*` ficheros. `link: absolute`.
- Perfiles independientes, sin `include`: `kasumi`, `kasumi_extras`,
  `kasumi_wayland`. Una invocación = un `-p <perfil>`.
- `impignore`/`upignore`: patrones globales ignorados en import/update (ej.
  `*.socket`, `.zcompdump*`).

## Comandos (desde la raíz del repo)

```bash
dotdrop profiles                            # listar perfiles
dotdrop files -p kasumi                     # listar dotfiles del perfil
dotdrop detail -p kasumi <clave>            # inspeccionar src/dst/link
dotdrop compare -p kasumi                   # diff sin escribir
dotdrop compare -p kasumi -C <ruta>         # comparar un dotfile (ej. ~/.gitconfig)
dotdrop install -p kasumi -t -f             # instalar en /tmp para revisión
dotdrop install -p kasumi --showdiff        # diff antes de sobrescribir
dotdrop install -p kasumi                   # crear symlinks src→dst
dotdrop compare -p kasumi_extras            # verificar extras
dotdrop update <ruta-en-HOME>               # importar cambio de HOME al repo
dotdrop import -p kasumi <ruta>             # nuevo dotfile → entrada en config.yaml
```

## Reglas

- Añadir dotfiles vía `dotdrop import`; editar `config.yaml` solo para
  `link`/`chmod`.
- Verificar con `compare` antes de `install`.
- `~/.config/zsh` y `~/.zshenv` ilustran `d_*` vs `f_*`: `zshenv` solo bootstrap
  (`ZDOTDIR`); el resto en `$ZDOTDIR`.

## Advertencias

- Destructivos excluidos: `remove`, `uninstall`, `--force`, `--remove-existing`,
  `-W/--workdir-clear`.
- Revisar sin tocar `HOME`: `install -t -f` (instala en `/tmp`).
- `--showdiff` muestra el diff antes de sobrescribir.
