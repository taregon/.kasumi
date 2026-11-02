# Configuración de lf

Fuente: `dotfiles/config/lf/`, enlazado en `~/.config/lf`.

## Estructura

- Alta: crear `cmds/<nombre>.lf` y agregar su `source` en `lfrc`; probar en un
  cliente nuevo, porque lf lee la configuración al arrancar

## Shell de los comandos

- `errexit`: un comando que puede fallar va en condición de `if` o con `||`; de
  lo contrario aborta el bloque
- Aritmética: usar `x=$((x + 1))`; `((x++))` devuelve estado 1 con resultado 0 y
  el bloque termina
- Contadores: leer el archivo con `exec 3< archivo` y `<&3`; con
  `comando | while` quedan en un subshell
- Selección: partir `$fx` con `${(f)fx}`, porque zsh no divide parámetros sin
  comillas

## Parser de configuración

- Bloques: `{{ … }}` cierran en el primer `}}` del texto, aunque esté dentro de
  una expansión o de un comentario, y no hay escape
- Consecuencia: evitar `${a:-${b}}` y `}}` en comentarios; encadenar
  asignaciones
- Salida: `%` escribe en la statline mientras dura el comando; `$` ejecuta sin
  interfaz

## Mensajes

- Persistencia: `lf -remote "send $id echo …"` deja el mensaje en la statline
- Recarga: `load` relee solo lo modificado; `reload` vacía la caché completa

## Portapapeles

- Ruta: `$LF_DATA_HOME/lf/files`, con precedencia `LF_DATA_HOME`,
  `XDG_DATA_HOME` y `~/.local/share`
- Formato: primera línea `copy` o `move`, luego una ruta absoluta por línea

## Verificación

- Terminal: lf exige tty; usar tmux con `send-keys` y `capture-pane`
- Aislamiento: `LF_DATA_HOME` temporal con `lf/files` preparado
- Diagnóstico: un `zsh` en `PATH` que registre `-c` revela el texto que lf
  entrega al intérprete
