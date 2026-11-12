# Dotdrop

Guía para mantener y desplegar los archivos gestionados por Dotdrop en este
repositorio. Ejecuta todos los comandos desde la raíz del repositorio.

## Configuración

- `config.yaml` define las entradas y perfiles; `dotpath` es `dotfiles`, por lo
  que cada `src` se resuelve desde esa carpeta y cada `dst` desde `HOME`.
- El prefijo `d_` identifica directorios y `f_` archivos. El enlace
  predeterminado es absoluto.
- Perfiles independientes: `kasumi`, `kasumi_extras` y `kasumi_wayland`. Usa un
  perfil por ejecución.
- `impignore` y `upignore` excluyen patrones de las operaciones `import` y
  `update`; por ejemplo, sockets y archivos de bytecode de zsh.

## Ciclo de trabajo

### Inspeccionar

```bash
dotdrop profiles                            # listar perfiles
dotdrop files -p kasumi                     # listar entradas de un perfil
dotdrop detail -p kasumi <clave>            # ver src, dst y link
dotdrop install -p kasumi -t                # instalar en temporal para revisar
```

### Verificar

```bash
dotdrop compare -p kasumi -b          # -b omite el banner
diff -u dotfiles/config/zsh/.zshrc ~/.config/zsh/.zshrc   # entrada puntual
```

`compare` lista las entradas cuyo `src` difiere del `dst`. La salida
`N dotfile(s) compared.` indica que el perfil se resolvió; las entradas con
diferencias muestran `src` frente a `dst`.

`install -d` valida que el perfil y el `config.yaml` cargan. Informa
`0 dotfile(s) would be installed` con independencia del estado de los archivos.

### Desplegar

```bash
dotdrop install -p kasumi                   # desplegar en HOME
dotdrop install -p kasumi --showdiff        # mostrar el diff al instalar
dotdrop install -p kasumi d_zsh             # solo esa entrada
```

`0 dotfile(s) installed` indica que el `dst` coincide con el `src`: no hay nada
que copiar.

### Incorporar cambios

```bash
dotdrop import -p kasumi <ruta>             # archivo nuevo
dotdrop update <ruta-en-HOME>               # archivo ya gestionado
```

## Reglas

Canon de restricciones y convenciones:

- Las claves van como argumento posicional, sin flag.
- `-D` corresponde a `--showdiff`.
- `-C` filtra por ruta de archivo; con una ruta ajena a las entradas del perfil,
  `compare` responde `no dotfile matches`.
- Modifica `config.yaml` manualmente solo para ajustar `link` o `chmod`.
- Para zsh, `~/.zshenv` solo configura el bootstrap (`ZDOTDIR`); el resto vive
  en `~/.config/zsh`.
- No uses `remove`, `uninstall`, `--force`, `--remove-existing` ni
  `-W/--workdir-clear`.

## Comprobar que un cambio de zsh está activo

```bash
zsh -f -c 'source ~/.config/zsh/.zshrc >/dev/null 2>&1; [[ -o interactive_comments ]] && echo ON || echo OFF'
env -u PATH /usr/bin/zsh -l -c 'case ":$PATH:" in *<ruta>*) echo presente;; *) echo ausente;; esac'
```

`[[ -o <opcion> ]]` consulta condiciones booleanas; `setopt` sin argumentos
lista las opciones activas que no son booleanas.

`zsh -i -c` hereda `PATH` y `fpath` del shell que lo invoca. Usa `env -u <var>`
o `zsh -f` para leer los valores del `.zshrc`, y abre una terminal nueva para
probarlo en un prompt interactivo.
