# Configuración de lf

Fuente: `dotfiles/config/lf/`; despliegue con stow en `~/.config/lf`.
Hallazgos verificados sobre lf 42; el parser y los prefijos cambian entre
versiones, así que conviene revisarlos al actualizar el paquete.

## Estructura

- Entrada: `lfrc` agrupa opciones, atajos y el `source` de cada comando
- Comandos: `cmds/<nombre>.lf` con cabecera `# vim: filetype=config`, comentario
  de propósito y una definición por archivo; `lfrc` los carga al final
- Previsualización: `lfpreview` y `lfclean` en bash, invocados por `previewer` y
  `cleaner`; no siguen las reglas de los comandos en zsh
- Atajos: `shortcuts.txt` alimenta el menú de rofi de la tecla `?`
- Carga: lf lee la configuración al arrancar; para aplicarla en caliente usar
  `:source ~/.config/lf/lfrc` o abrir un cliente nuevo

## Shell de los comandos

- Intérprete: `set shell zsh`, `set shellopts '-eu'` y `set ifs "\n"`
- `errexit`: un comando simple que falla aborta el bloque; por eso `ln`, `mv` o
  similares van en condición de `if` o con `||`
- Aritmética: usar `x=$((x + 1))`; `((x++))` devuelve estado 1 cuando el
  resultado es 0 y aborta el script
- Variables de entorno: `set -u` obliga a `${VAR:-}` al consultar variables que
  pueden faltar
- Bucles con contadores: leer el archivo con `exec 3< archivo` y `<&3`; con
  `comando | while`, los contadores quedan en un subshell
- Selección: `$fx` llega separada por el `ifs` configurado, pero zsh no divide
  parámetros sin comillas; usar `${(f)fx}` para partirla por líneas
- Identificador: `$id` es el pid del cliente y permite enviarse comandos a sí
  mismo

## Parser de configuración

- Bloques: `{{ … }}` cierran en el primer `}}` del texto, aunque esté dentro de
  una expansión o de un comentario, y no hay escape
- Consecuencia: evitar `${a:-${b}}`, cierres de llaves agrupadas y `}}` en
  comentarios; encadenar asignaciones en su lugar
- Alcance: la limitación afecta a `cmd` y a `map` con bloque; en comandos de una
  línea el fin de línea cierra el comando
- Prefijos: `%` conecta la salida a la statline, `$` ejecuta sin interfaz, `!`
  espera una tecla y `&` ejecuta en segundo plano

## Mensajes e interfaz

- `printf` en un comando `%`: se ve mientras dura el comando y se borra al
  terminar
- Persistencia: `lf -remote "send $id echo …"` mantiene el mensaje en la
  statline
- Recarga de directorio: `lf -remote "send $id load"` relee solo lo modificado;
  `reload` vacía la caché completa

## Portapapeles

- Ruta: `$LF_DATA_HOME/lf/files`, con precedencia `LF_DATA_HOME`,
  `XDG_DATA_HOME` y `~/.local/share`
- Formato: primera línea `copy` o `move`, luego una ruta absoluta por línea; lf
  rechaza nombres con salto de línea al copiar
- Lectura: consumir la primera línea y procesar el resto por el mismo
  descriptor, sin depender de `head` ni `tail`
- `paste_link`: enlaza siempre y no aplica `move`; los originales permanecen

## Verificación

- Terminal: lf exige tty; probar con `tmux new-session -d`, `tmux send-keys` y
  `tmux capture-pane`
- Portapapeles aislado: exportar `LF_DATA_HOME` a un directorio temporal con
  `lf/files` preparado
- Texto entregado al shell: un `zsh` de prueba en `PATH` que registre `-c`
  revela el comando exacto que lf pasa al intérprete
