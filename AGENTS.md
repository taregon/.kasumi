# Convenciones para scripts shell, helpers zsh y configuracion

## Skills del repositorio

| Skill                   | Trigger                                                  |
| :---------------------- | :------------------------------------------------------- |
| `kasumi-rmpc`           | Al editar archivos `.ron` de rmpc                        |
| `kasumi-output-format`  | Al crear/modificar scripts con salida de terminal        |
| `kasumi-file-safety`    | Al manipular archivos o ejecutar scripts con rm          |
| `kasumi-ascii-diagrams` | Al documentar layouts o jerarquías visuales              |
| `box-comments`          | Al generar comentarios decorativos en cualquier lenguaje |

## Alcance

Dotfiles para Arch Linux (pacman/paru, Sway/Wayland, Kitty, rmpc, dotdrop). No
asumir convenciones de otros sistemas operativos o gestores de paquetes.

- Scripts bash en `dotfiles/scripts/`, `dotfiles/config/*/scripts/`.
- Helpers zsh en `dotfiles/config/zsh/funcs/` (reglas en su `AGENTS.md`).
- Configuracion rmpc, temas RON y terminal (Kitty).

## Escritura y caracteres

- Usar español neutro, sin regionalismos ni modismos, con tono impersonal y
  tecnico.
- Mantener sin traducir terminos tecnicos, nombres de herramientas, flags,
  paquetes, APIs, URLs y sintaxis de codigo.
- Conservar tokens estandar del area: `TODO`, `FIXME`, `NOTE`, `PEND`, `WARN` y
  similares.
- No usar caracteres Unicode invisibles en arte ASCII ni en strings de
  configuracion. Los glifos Nerd Font (U+E000-U+F8FF) estan permitidos.

## Zona horaria

- Usar UTC-5 como referencia para timestamps, notificaciones y cualquier
  funcionalidad dependiente de hora local.

## Gestor de paquetes

- `paru` es el helper AUR estandar del repo; no reemplazarlo por `yay`.
- Usar `pacman` para repos oficiales, `paru` para AUR o listas mixtas.
- Usar `--needed` en instalaciones cuando aplique.

## Entorno grafico

- Preferir herramientas nativas Wayland; no proponer equivalentes X11.
- Mantener `rofi` como launcher/selector estandar; no reemplazarlo sin peticion
  explicita.
- Usar `systemctl --user` y variables de entorno Wayland cuando el servicio
  pertenezca a la sesion grafica.

## Scripts Bash

- Iniciar todo script bash con `set -euo pipefail`.
- Incluir tras el shebang un comentario de 1-3 lineas que describa proposito y
  alcance.
- Mantener tono descriptivo y tecnico, sin relleno.
- Separar `local var` y `var=...` cuando la asignacion depende de un comando y
  se debe preservar su exit code.
- Preferir heredoc con `tee` sobre pipelines con `echo`.
- Preferir `echo -e "texto\n"` sobre echos vacios separados.

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

- Comentar el por qué, no el qué.
- Contexto o restricciones del bloque; nunca repetir el código.
- Inline sobre bloques; omitir código autoexplicativo.
- Tono impersonal y técnico; empezar con mayúscula.
- Contexto durable para mantenimiento futuro.
- Señal práctica: si al reabrir el archivo meses después tendrías que detenerte
  a pensar por qué existe o qué problema evita, merece comentario.

### zsh

Los helpers zsh son interactivos y pueden usar comentarios mas directos,
incluyendo explicaciones de que hace una funcion.

## Bloques técnicos

Cuando se documenten módulos o secciones de configuración:

- Usar encabezados decorativos ASCII (líneas `───`) para separar bloques.
- Preservar arte ASCII en headers de archivos cuando exista. No reemplazarlo por
  cajas decorativas estándar sin petición explícita.
- Formato compacto de 2 columnas: izquierda = acción/evento, derecha =
  comando/efecto. Ejemplo:

  ```
  # Acciones built-in:
  #   • click izq  -> play_pause        • botones 8/9 -> prev/next
  #   • scroll     -> position +/-5     • click der   -> deshabilitado
  ```

- Separar columnas con espacios alineados (~28 chars); no usar tablas formales.
- Usar `•` (U+2022) como viñeta por cada ítem en formato 2 columnas.
- Flecha ASCII `->` como operador estándar de mapeo.
- Una sola línea por acción; evitar descripciones largas o párrafos.
- Agrupar por categorías funcionales bajo subtítulos claros.
- Priorizar legibilidad escaneable en terminal sobre exhaustividad narrativa.

## Formato

- Preferir lineas cortas, alrededor de 100 caracteres.
- Partir lineas con `\` cuando sea natural.
- Escribir `case` expandido: cada branch en lineas separadas y `;;` en su propia
  linea.
- Mantener Markdown envuelto de forma consistente.

## Robustez y seguridad

- Verificar efectos secundarios: un comando puede aparentar éxito sin producir
  el estado esperado.
- `|| true` solo en fallos esperados, con comentario inline del motivo.
- No sobredimensionar validaciones si el comportamiento es predecible.

## Organizacion de archivos

- Usar prefijo `NN-` para scripts con orden de ejecucion.
- Omitir prefijo en scripts opcionales.

## Codigo legacy

- `scripts-legacy/`, `.bk` y `.old` existen como referencia para migracion y
  homologacion.
- No tomarlos como patron principal para codigo nuevo si existe una version
  activa equivalente.
- Al homologar, conservar el comportamiento util y adaptar herramientas
  obsoletas a equivalentes actuales del repo.
