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
- Contadores: leer la lista con `exec 3< archivo` y `<&3`; en zsh el pipe no
  pierde los contadores, pero un `read` interno consumiría la lista
- Selección: partir `$fx` con `${(f)fx}`, porque zsh no divide parámetros sin
  comillas
- Rutas: `$f` y `$fx` son absolutas; `${f%/*}` da el directorio y `${fx##*/}` el
  nombre
- Fzf: `{1}` y `{q}` llegan escapados por fzf; no envolverlos en comillas dentro
  del comando remoto

## Parser de configuración

- Bloques: `{{ … }}` cierran en el primer `}}` del texto, aunque esté dentro de
  una expansión o de un comentario, y no hay escape
- Consecuencia: evitar `${a:-${b}}` y `}}` en comentarios; encadenar
  asignaciones
- Salida: `%` escribe en la statline mientras dura el comando; `$` pausa la
  interfaz y usa la terminal

## Atajos

- Prefijo: una tecla con comando propio no inicia una secuencia; `t` ejecuta
  `tag-toggle` y bloquea cualquier atajo que empiece por `t`
- Registro: todo comando aprobado se anota en `shortcuts.txt` con su tecla y la
  columna alineada a las vecinas

## Mensajes

- Persistencia: `lf -remote "send $id echo …"` deja el mensaje en la statline;
  `echoerr` lo marca como error; una comilla doble o un `;` en el texto corta el
  comando
- Recarga: lf relee el directorio al terminar un comando de shell; `load` relee
  lo modificado y `reload` vacía la caché
- Salida: capturar el error y enviarlo a la statline antes que redirigirlo a
  `/dev/null`

## Portapapeles

- Ruta: `$LF_DATA_HOME/lf/files`, con precedencia `LF_DATA_HOME`,
  `XDG_DATA_HOME` y `~/.local/share`
- Formato: primera línea `copy` o `move`, luego una ruta absoluta por línea

## Cifrado

- Llave: `$XDG_CONFIG_HOME/age/kasumi.key`, fuera del repositorio; sin ella no
  se descifra y no debe copiarse a dotfiles
- Salida: `age` sobrescribe sin aviso; comprobar la existencia antes de
  invocarlo
- Contraseñas: no leerlas en la statline, porque lf muestra lo tecleado; dejar
  el prompt a `pinentry` o a un programa con tty

## Verificación

- Terminal: lf exige tty; usar tmux con `send-keys` y `capture-pane`
- Aislamiento: `LF_DATA_HOME` temporal con `lf/files` preparado
- Diagnóstico: un `zsh` en `PATH` que registre `-c` revela el texto que lf
  entrega al intérprete
