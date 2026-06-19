# Helpers zsh autoload

Estas reglas aplican a funciones ligeras en `dotfiles/config/zsh/funcs/`. No
siguen las reglas de scripts bash del `AGENTS.md` raiz.

- El archivo es el cuerpo de la funcion: sin `function foo { }` y sin shebang.
- Usar `return`, no `exit`; `exit` cerraria el shell interactivo.
- Declarar todas las variables con `local`.
- Declarar arrays con `local -a` para habilitar indices 1-based.
- Asumir arrays 1-indexed; usar `${(@f)...}` para split por newline.
- `local var="$1"` esta permitido.
- No usar `set -euo pipefail`.
- No usar `|| true` ni validaciones defensivas innecesarias.
- Los comentarios pueden explicar que hace la funcion.
- Usar `setopt localoptions [no_]ksharrays` cuando sea necesario aislar
  opciones.
