# Convenciones para scripts shell, helpers zsh y configuracion

## Alcance

Estas reglas aplican a este repositorio de dotfiles Kasumi. El sistema objetivo
es Arch Linux con pacman/paru/AUR, Sway/Wayland, Kitty, rmpc y despliegue via
dotdrop. No asumir convenciones de Debian, Ubuntu, Fedora, GNOME, KDE, X11 u
otros gestores de paquetes.

- Scripts bash en `dotfiles/scripts/`, `dotfiles/config/*/scripts/` y helpers
  ejecutables similares.
- Helpers zsh en `dotfiles/config/zsh/funcs/`.
- Configuracion rmpc y temas RON.
- Configuracion de terminal y salida pensada para Kitty.

## Idioma

- Usar español neutro, con tono impersonal y tecnico.
- Mantener sin traducir terminos tecnicos, nombres de herramientas, flags,
  paquetes, APIs, URLs y sintaxis de codigo.
- Conservar tokens estandar del area: `TODO`, `FIXME`, `NOTE`, `PEND`, `WARN` y
  similares.

## Gestor de paquetes

- `paru` es el helper AUR estandar del repo; no reemplazarlo por `yay`.
- Usar `pacman` cuando el script ya opere solo con repos oficiales o tareas del
  sistema.
- Usar `paru` cuando el script ya maneje AUR o listas mixtas.
- No proponer `apt`, `dnf`, `brew`, `snap` ni `flatpak`.
- Usar `--needed` en instalaciones cuando aplique.

## Sway y Wayland

- El entorno grafico objetivo es Sway sobre Wayland.
- Tratar X11 como legado y XWayland como capa de compatibilidad para
  aplicaciones, no como base para scripts nuevos.
- Preferir herramientas nativas Wayland: `swaymsg`, `grim`, `slurp`, `wl-copy`,
  `wl-paste`, `wf-recorder`, `mako`, `cliphist` y `wlr-*` cuando aplique.
- No proponer herramientas X11 como `xrandr`, `xdotool`, `xclip`, `xsel` o
  `xprop`.
- Mantener `rofi` como launcher/selector estandar del repo porque se usa en modo
  Wayland; no reemplazarlo por `wofi`, `wmenu` u otro launcher sin peticion
  explicita.
- Usar `systemctl --user` y variables de entorno Wayland cuando el servicio
  pertenezca a la sesion grafica.

## Helpers zsh

Los helpers en `dotfiles/config/zsh/funcs/` son funciones ligeras autoload. No
siguen las reglas de scripts bash. Las reglas completas viven en
`dotfiles/config/zsh/funcs/AGENTS.md`.

## Scripts Bash

- Iniciar todo script bash con `set -euo pipefail`.
- Incluir tras el shebang un comentario de 1-3 lineas que describa proposito y
  alcance.
- Mantener tono descriptivo y tecnico, sin relleno.
- Separar `local var` y `var=...` cuando la asignacion depende de un comando y
  se debe preservar su exit code.

## Estructura

Organizar los scripts en capas verticales. Cada funcion debe referenciar solo
funciones ya definidas.

1. Setup: shebang, `set`, constantes.
2. Helpers de bajo nivel: wrappers a herramientas externas.
3. Logica intermedia: funciones que combinan helpers.
4. Orquestacion: funciones que deciden el flujo.
5. Punto de entrada: ejecucion principal del script.

Separar cada capa con un comentario visual para navegacion rapida:

```bash
# ── Setup ─────────────────────────────────────────────────────────────
```

Los separadores visibles y glifos Nerd Font estan permitidos. Los caracteres
Unicode invisibles no.

## Nombres y variables

- Usar `snake_case` para funciones y variables; no usar camelCase.
- Preferir funciones con patron `<prefix>_<verb>`.
- El prefijo agrupa por ambito; el verbo describe la accion.
- Usar nombres autodescriptivos que no requieran comentarios obvios.
- Usar prefijos agrupadores en variables cuando ayuden a identificar ambito.
- Usar `readonly` para constantes cuando aporte claridad.
- Definir rutas de directorio sin `/` final para evitar dobles separadores al
  concatenar.
- Agrupar constantes relacionadas bajo un comentario breve.

## Comentarios

### Bash

- Comentar solo lo no obvio: priorizar explicar el por que, contexto o
  restricciones del bloque, evitando repetir literalmente lo que el codigo ya
  expresa.
- Preferir comentarios inline breves sobre bloques largos.
- Evitar comentarios en codigo autoexplicativo.
- Usar tono impersonal y tecnico.
- Empezar comentarios con mayuscula.
- No repetir lineas visibles del codigo.
- Escribir contexto durable, util para mantenimiento futuro.
- Si un bloque requiere aunque sea un breve analisis para comprender su
  proposito, contexto o motivo de existencia, probablemente merece un
  comentario. Ser conservador al asumir que algo es "obvio"; una buena señal es
  si al reabrir el archivo meses despues tendrias que detenerte a pensar por que
  ese bloque existe o que problema evita.

### zsh

Los helpers zsh son interactivos y pueden usar comentarios mas directos,
incluyendo explicaciones de que hace una funcion.

## Formato

- Preferir lineas cortas, alrededor de 100 caracteres.
- Partir lineas con `\` cuando sea natural.
- Escribir `case` expandido: cada branch en lineas separadas y `;;` en su propia
  linea.
- Mantener Markdown envuelto de forma consistente.

## Diagramas ASCII

- Usar diagramas ASCII para ilustrar layouts, jerarquias y estructura de
  configuracion cuando la representacion visual sea mas clara que una
  descripcion textual.
- Mantener alineacion y jerarquia visual consistentes usando espacios y
  caracteres Unicode visibles: `─`, `│`, `┌`, `┐`, `└`, `┘`, `├`, `┤`, `┬`, `┴`,
  `┼`.
- Incluir nombres de widgets, bloques o archivos dentro del diagrama cuando
  aporte contexto.
- Los diagramas son opcionales; utilizarlos cuando mejoren claridad o
  mantenibilidad.

## Entrada, salida y archivos

- Preferir heredoc con `tee` sobre pipelines con `echo`.
- Preferir `echo -e "texto\n"` sobre echos vacios separados.
- Marcar escritura de archivos con el color de accion y el icono ``.
- Usar siempre 2 espacios despues de iconos Nerd Font. Es una regla normativa
  para evitar bugs de renderizado en Kitty, no una preferencia estetica.

```bash
echo -e "   ${C_ACTION}  /ruta${C_RST}"
```

## Robustez y seguridad

- Verificar efectos secundarios cuando el comando pueda aparentar exito sin
  producir el estado esperado.
- Usar `|| true` solo en fallos esperados, con comentario inline que explique el
  motivo.
- No sobredimensionar validaciones si el comportamiento es predecible.

## Operaciones destructivas y Git

- Usar Git para inspeccion es permitido: `git status`, `git diff`, `git show` y
  `git log`.
- No usar Git para modificar worktree, staging o historial sin peticion
  explicita: `git add`, `git commit`, `git reset`, `git restore`,
  `git checkout`, `git clean`, `git revert` o `git stash`.
- Antes de modificar archivos existentes, revisar `git status --short` y asumir
  que cambios no relacionados pertenecen al usuario.
- Para revertir cambios propios, preferir patch puntual que deshaga solo las
  lineas afectadas.
- Si la reversion requiere descartar archivos completos o cambios ajenos, pedir
  confirmacion antes.
- No ejecutar comandos destructivos sobre el repo o el sistema sin peticion
  explicita: `rm`, `mv`, `unlink`, `rmdir`, `chmod`, `chown` o equivalentes.
- En scripts, permitir `rm` solo para recursos temporales propios, locks o
  archivos creados por el mismo script.
- En scripts, preferir `mktemp`, `trap` y rutas acotadas antes de limpiar por
  patrones amplios.

## Salida, colores e iconos

### Colores

- `C_STEP`: azul, para encabezados y progreso.
- `C_OK`: verde, para estado completado / OK.
- `C_ACTION`: amarillo, para acciones, cambios y advertencias.
- `C_RST`: reset, cierra el color activo.

Acompanar cada asignacion de color con un comentario inline del color fisico:

```bash
C_STEP="\033[0;34m"   # blue
```

### Iconos

Preferir variantes outline y mantener consistencia segun el contexto:

- Octicons (`nf-oct-*`, rango ``-``) para scripts de instalacion.
- Material Design Outline (`nf-md-*_outline`) y Codicon (`nf-cod-*`) para
  terminal, `notify-send` y scripts interactivos o ligeros.

Usar 2 espacios entre icono y texto para evitar problemas de renderizado en
Kitty.

- ``: paso en progreso.
- ``: accion aplicada o escritura de archivo.
- ``: OK / completado.
- ``: error o warning.
- ``: habilitando / iniciando.

### Salida

- `` con azul para pasos principales.
- `` con amarillo para acciones y escritura de archivos.
- `` con amarillo para errores, con sugerencia indentada debajo.
- `` con verde para completado.
- Evitar hardcodear nombres de otros scripts.

## Organizacion de archivos

- Usar prefijo `NN-` para scripts con orden de ejecucion.
- Omitir prefijo en scripts opcionales.

## Codigo legacy

- `scripts-legacy/`, `.bk` y `.old` existen como referencia para migracion y
  homologacion.
- No tomarlos como patron principal para codigo nuevo si existe una version
  activa equivalente.
- Usarlos para entender intencion, opciones, textos, flujos o comportamiento que
  deba portarse.
- Al homologar, conservar el comportamiento util y adaptar herramientas
  obsoletas a equivalentes actuales del repo.

## rmpc y temas RON

- No usar caracteres Unicode invisibles en strings de `Text()`: zero-width
  spaces U+200B, joiners U+200C/U+200D, soft hyphens U+00AD, etc.
- Esta restriccion existe porque algunos modelos o herramientas pueden
  inyectarlos accidentalmente y romper renderizado, busquedas o diffs.
- Los glifos Nerd Font en el area privada U+E000-U+F8FF estan permitidos porque
  son visibles y se renderizan como iconos.
- Usar comentarios con `// ──` y padding a 70 caracteres totales.
- `lyrics_dir` usa `~/.config/rmpc/lyrics`; es un symlink al directorio real. Si
  no existe, recrearlo con:

```bash
ln -sf "$KASUMI_LYRICS_DIR" ~/.config/rmpc/lyrics
```
