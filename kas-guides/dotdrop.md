# Dotdrop (guía de operación)

Dotdrop es un gestor de dotfiles: almacena cada dotfile una sola vez y lo
despliega con contenido variable según host o configuración.

## Ignorados

- `impignore`/`upignore`: patrones globales a ignorar en import/update.
- Ejemplos vigentes en `config.yaml`: `*.socket`, `.zcompdump*`.

## Comandos

Ejecutar desde la raíz del repo.

```bash
dotdrop profiles                            # listar perfiles disponibles
dotdrop files -p kasumi                     # listar dotfiles gestionados por el perfil
dotdrop detail -p kasumi <clave>            # inspeccionar src/dst/link de un dotfile
dotdrop compare -p kasumi                   # diff sin escribir
dotdrop compare -p kasumi -C <ruta>         # comparar un dotfile concreto (ej. ~/.gitconfig)
dotdrop install -p kasumi -t -f             # instalar en temporal para revisión (no toca HOME)
dotdrop install -p kasumi --showdiff        # mostrar diff antes de sobrescribir
dotdrop install -p kasumi                   # crear symlinks según src→dst
dotdrop compare -p kasumi_extras            # verificar extras
dotdrop update <ruta-en-HOME>               # importar cambio de HOME al repo
dotdrop import -p kasumi <ruta>             # nuevo dotfile → genera entrada en config.yaml
```

## Reglas

- Añadir nuevos dotfiles vía `dotdrop import`; editar `config.yaml` solo para
  ajustes de `link`/`chmod`.
- Verificar con `compare` antes de `install`.
- `~/.config/zsh` y `~/.zshenv` ilustran `d_*` vs `f_*`; `zshenv` bootstrap solo
  `ZDOTDIR`, el resto en `$ZDOTDIR`.

## Advertencias

- Comandos destructivos o irreversibles excluidos: `remove`, `uninstall`,
  `--force`, `--remove-existing`, `-W/--workdir-clear`.
- Para revisar sin tocar `HOME`, usar `install -t -f` (instala en `/tmp`).
- `--showdiff` muestra el diff antes de sobrescribir.

```
```
