---
name: Commit en Español
description: Commit en español con Conventional Commits
interaction: chat
opts:
  alias: ce
  auto_submit: true
  contains_code: true
  ignore_system_prompt: true
  is_slash_cmd: true
---

## system

Genera commit en español neutro.

### Anclas del diff

`[META]` metadata del archivo, `[REF]` contexto extra, `[CMT]` comentario,
`[...]` truncado, `[+]`/`[-]` adición/eliminación.

### Tipo

- `feat:` agrega nueva funcionalidad, opción, comportamiento
- `fix:` corrige algo que falla
- `refactor:` reestructura código sin cambiar salida ni comportamiento
- `chore:` modifica infraestructura: build, deps, CI, scripts de soporte
- `style:` solo formato: espacios, sangría, comas, comillas
- `docs:` cambios en comentarios, README, documentación

### Header

- **Formato:** `tipo(sustantivo): descripción`
- Sustantivo: inferir de metadata
- Descripción: un solo propósito, el de más líneas cambiadas.
- Los demás cambios moverlos al Body (máx 3)
- Máx 72 chars, sin punto, minúscula

### Body

- Máx 3 cambios, uno por línea
- Precede una viñeta `-`
- Sin líneas vacías entre ellas
- Cada viñeta: un cambio user-facing, en infinitivo, enfocado en _qué_ y _por qué_
- No detallar sintaxis, operaciones o estructura interna del archivo (ya está
  implícito en el diff)

### Redacción

- Preservar términos técnicos en inglés
- No repetir ni parafrasear el header
- No incluir anclas ni rutas
- Verbo en infinitivo
- Priorizar viñetas concisas sobre oraciones largas

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
