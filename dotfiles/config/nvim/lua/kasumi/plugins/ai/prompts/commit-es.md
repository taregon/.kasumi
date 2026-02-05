---
name: Commit en Español
description: Genera un mensaje de commit en español (Conventional Commits)
interaction: chat
opts:
  alias: ce
  auto_submit: true
  contains_code: true
  ignore_system_prompt: true
  is_slash_cmd: true
---

## system

Instrucción: Genera un mensaje de commit siguiendo estrictamente la
especificación Conventional Commits v1.0.0.

1. Formato de Salida:

   - Solo texto plano.
   - PROHIBIDO el uso de Markdown, bloques de código (```) o negritas.
   - Idioma: Español (excepto tipos técnicos).

2. Especificación del Título (Header):

   - Formato: <tipo>(<ámbito>): <verbo-imperativo-minúscula> <descripción>
   - Longitud: No exceder los 50 caracteres.
   - Tipo: Elige exclusivamente uno: [feat, fix, refactor, chore, docs, style,
     perf, test, build, ci].
   - Ámbito (scope): Palabra clave única que identifique el módulo afectado (ej.
     ai, sys, ui).
   - Prohibido incluir nombres de archivos en el título.
   - Elimina palabras vacías y adverbios innecesarios como "adecuadamente",
     "incorrectamente" o "para asegurar".
   - Usa lenguaje telegráfico.

3. Cuerpo del Mensaje:

   - Obligatorio una línea en blanco después del título.
   - Inicia con un verbo imperativo (agregar, corregir, actualizar, eliminar,
     refactorizar, configurar). Sin punto final y en minúsculas.
   - Contenido: Describe el impacto técnico y el propósito del cambio basado en
     el diff.
   - Restricción: PROHIBIDO repetir o parafrasear el título. Aporta detalles que
     no están en la cabecera (ej. nombres de funciones, lógica modificada).

4. Cambios de Ruptura (Breaking Changes):

   Si el diff elimina funciones o cambia interfaces existentes:
   - Añade ! después del ámbito. Ejemplo: feat(api)!: ...
   - Añade una línea en blanco al final y el footer: BREAKING CHANGE:
     <explicación de la incompatibilidad>.

## user

Genera un commit, basado en este diff:

```diff
${commit-es.staged_diff}
```
