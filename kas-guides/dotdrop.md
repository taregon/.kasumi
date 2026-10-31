# Dotdrop

Guía para mantener y desplegar los archivos gestionados por Dotdrop en este
repositorio.

## Configuración

- `config.yaml` define las entradas y perfiles; `dotpath` es `dotfiles`, por lo
  que cada `src` se resuelve desde esa carpeta y cada `dst` desde `HOME`.
- El prefijo `d_` identifica directorios y `f_` archivos. El enlace
  predeterminado es absoluto.
- Perfiles independientes: `kasumi`, `kasumi_extras` y `kasumi_wayland`. Usa un
  perfil por ejecución.
- `impignore` y `upignore` excluyen patrones de las operaciones `import` y
  `update`; por ejemplo, sockets y archivos de bytecode de zsh.

## Operaciones

Ejecuta los comandos desde la raíz del repositorio.

```bash
dotdrop profiles                            # listar perfiles
dotdrop files -p kasumi                     # listar entradas de un perfil
dotdrop detail -p kasumi <clave>            # ver src, dst y link
dotdrop compare -p kasumi                   # revisar diferencias
dotdrop compare -p kasumi -C <ruta>         # revisar una ruta
dotdrop install -p kasumi -t                # instalar en temporal para revisar
dotdrop install -p kasumi --showdiff        # mostrar cambios antes de instalar
dotdrop install -p kasumi                   # desplegar en HOME
dotdrop import -p kasumi <ruta>             # incorporar un archivo nuevo
dotdrop update <ruta-en-HOME>               # importar cambios desde HOME
```

## Reglas

- Incorpora archivos nuevos con `dotdrop import`; usa `dotdrop update` para
  importar cambios de archivos ya gestionados.
- Modifica `config.yaml` manualmente solo para ajustar `link` o `chmod`.
- Ejecuta `compare` antes de desplegar. Usa `--showdiff` cuando quieras revisar
  el diff durante la instalación.
- Para zsh, `~/.zshenv` solo configura el bootstrap (`ZDOTDIR`); el resto de la
  configuración vive en `~/.config/zsh`.
- No uses `remove`, `uninstall`, `--force`, `--remove-existing` ni
  `-W/--workdir-clear`.
