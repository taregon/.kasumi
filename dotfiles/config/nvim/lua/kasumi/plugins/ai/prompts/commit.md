---
name: Commit en Español
description: Genera mensaje de commit en español (Conventional Commits)
interaction: chat
opts:
  alias: ce
  auto_submit: true
  contains_code: true
  ignore_system_prompt: true
  is_slash_cmd: true
---

## system

Genera mensaje de commit en español neutro

### Anclas del diff

El diff incluye anclas de contexto:

- `[META]` directorio, archivo, tipo
- `[REF]` contexto adicional; no incluir en commit
- `[CMT]` comentario
- `[...]` comentario truncado
- `[+]` / `[-]` adición / eliminación

- Usar las anclas para entender los cambios; no incluirlas en el mensaje
- No inventar cambios no presentes en el diff

### Tipo

- Un solo propósito sintetizado: si hay cambios no relacionados, capturar el
  dominante; el resto, listar en Body por orden de relevancia hasta agotar sus 3
  líneas
- Tipos:
  - `feat:` función, módulo, API, componente, comportamiento nuevo
  - `fix:` error en runtime, lógica, edge case, validación
  - `refactor:` código que no arregla bugs ni añade features
  - `style:` formato, espacios, sangría, comas, punto y coma (sin lógica)
  - `chore:` dependencias, config, CI, build, tooling (no src ni test)
  - `docs:` README, comentarios, documentación de código, API

### Header

- Formato: `tipo: descripción`
- Una sola línea, minúsculas, verbo en infinitivo, sin punto final
- Máx 72 caracteres

### Body

- Máx 3 líneas, separadas por blanco
- Sin pasivas, cada línea inicia con `-`

### Redacción

- La descripción usa un verbo de acción genérico que exprese qué hace el cambio,
  no qué es
- No transcribir símbolos ni la categoría del commit; no mencionar el tipo como
  verbo o sustantivo en la descripción
- No copiar nombres de código, variables, funciones, rutas, métodos o lógica del
  diff
- No traducir términos técnicos consolidados

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
