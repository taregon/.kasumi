# Configuración de lf

Fuente: `dotfiles/config/lf/`, enlazado en `~/.config/lf`.

## Estructura

- Alta: crear `cmds/<nombre>.lf` y agregar su `source` en `lfrc`; probar en un
  cliente nuevo, porque lf lee la configuración al arrancar

## Nombres

- Archivo: un comando por archivo, `cmds/<comando>.lf`, con el mismo nombre del
  comando que define (`pack_any.lf` → `pack_any`)
- Orden: verbo primero y objeto o método después; `pack_any`, `unpack_zstd`,
  `encrypt_age`, `find_files`, `purge_old_trash`
- Herramienta: no se nombra la herramienta, salvo que sea el método (`zstd`,
  `age`); preferir la acción que muestra `maps`, por eso `find_files` y no
  `fzf_find`
- Hook: el nombre coincide con el evento de lf (`on-select`)
- Teclas: no forman parte del nombre del comando

## Shell de los comandos

- `errexit`: un comando que puede fallar va en condición de `if` o con `||`; de
  lo contrario aborta el bloque
- `nounset`: `shellopts '-eu'` aborta el comando ante una variable sin definir
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
- Registro: todo atajo personalizado se anota en `shortcuts.txt` con su tecla y
  la columna alineada a las vecinas

## Mensajes

- Persistencia: `lf -remote "send $id echo …"` deja el mensaje en la statline;
  `echoerr` lo marca como error; una comilla doble o un `;` en el texto corta el
  comando
- Recarga: lf relee el directorio al terminar un comando de shell; `load` relee
  lo modificado y `reload` vacía la caché
- Salida: capturar el error y enviarlo a la statline antes que redirigirlo a
  `/dev/null`

## Portapapeles

- Ruta: `lf/files` bajo el directorio de datos, con precedencia `LF_DATA_HOME`,
  `XDG_DATA_HOME` y `~/.local/share`
- Formato: primera línea `copy` o `move`, luego una ruta absoluta por línea

## Vista previa

- Orden: `-profile` antes de `-strip` convierte con el perfil de origen; el
  `-profile` final solo etiqueta, porque `-strip` y `-thumbnail` ya quitaron el
  ICC. Invertirlo reinterpreta una imagen AdobeRGB/P3 como sRGB
- Settings: `-define jpeg:size` va antes de la entrada y `-filter` antes del
  resize; `-quality`, `-sampling-factor` y `-define jpeg:optimize-coding` solo
  preceden al archivo de salida
- Operadores: `-auto-orient`, `-strip`, `-colorspace`, `-thumbnail` y `-profile`
  se aplican donde aparecen
- `-intent`: no agregarlo; los perfiles de `icc/` son matriz + curva sin tablas
  A2B/B2A y el punto blanco coincide, así que los cuatro intent dan lo mismo
- Duplicación: el orden canónico vive en el `NOTE` de `lfpreview`;
  `icc/README.md` repite el pipeline con el porqué y las mediciones, así que
  cambiar uno obliga al otro

## Cifrado

- Privada: `/var/lib/sahaquiel/age/sahaquiel.key`, `600`, propiedad del custodio
  `sahaquiel`; no se copia a dotfiles y no la lee el proceso de lf
- Públicos de confianza: `/etc/age/sahaquiel.pub` y `recipients.txt`, `644`
  propiedad de root; las copias del directorio age del invocante no se usan
- Cifrar: `ge` exige que el recipiente propio figure en `recipients.txt`, cifra
  con `-R` y sin fallback que acepte un público modificable
- Descifrar: `gd` usa prefijo `$` e invoca `su -s /bin/sh sahaquiel`, porque `%`
  no da tty y `su` no cachea la contraseña
- Intérprete: el custodio necesita `/bin/sh` en `passwd`; con `nologin`, `su`
  ignora `-s` desde un usuario sin privilegios y rechaza el cambio
- Cruce de usuarios: el custodio no puede leer ni escribir en los directorios
  del usuario que invoca; `gd` entrega el archivo por el descriptor 3, deja
  stdin para la contraseña de `su` y crea el temporal con `mktemp`, que da
  nombre imprevisible, `600` y `mv` atómico
- Argumentos: `su -c` recibe el nombre ficticio `sahaquiel-age` como `$0`;
  ninguna ruta seleccionada se interpola en el comando
- Salida: `age` sobrescribe sin aviso; comprobar la existencia antes de
  invocarlo
- Contraseñas: no leerlas en la statline, porque lf muestra lo tecleado; el
  prompt queda en `su`

## Verificación

- Terminal: lf exige tty; usar tmux con `send-keys` y `capture-pane`
- Aislamiento: `LF_DATA_HOME` temporal con `lf/files` preparado
- Diagnóstico: un `zsh` en `PATH` que registre `-c` revela el texto que lf
  entrega al intérprete
- Color: con `a98.icc` de ghostscript, `magick compare -metric RMSE` entre el
  pipeline y la conversión con el orden invertido da ~0.05; el caso correcto
  mide 0.0034 en `icc/README.md`
- Cifrado: sin contraseña del custodio, `gd` se prueba con un shim de `su` en
  `PATH` que sustituya la ruta de la llave por una de prueba
