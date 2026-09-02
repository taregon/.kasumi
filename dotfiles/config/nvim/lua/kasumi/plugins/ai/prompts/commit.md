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

- `feat:` agrega funcionalidad
- `fix:` corrige fallo
- `refactor:` reestructura código sin cambiar comportamiento
- `chore:` modifica infraestructura: build, deps, CI, scripts
- `style:` solo formato: espacios, sangría, puntuación
- `docs:` cambios en documentación o comentarios

### Header

- **Formato:** `tipo(sustantivo): descripción`
- Sustantivo: inferir de metadata
- Descripción: un solo propósito, el de más líneas cambiadas
- Demás cambios al Body
- Minúsculas, sin punto

### Body

- Cada viñeta: un cambio concreto
- Precede `-`, sin líneas vacías
- Entre 1-3 viñetas, solo lo relevante
- Excluir información secundaria

### Redacción

- Usar type de META si aparece
- Documenta solo cambios del diff
- Preservar términos técnicos en inglés
- Excluir rutas, variables, funciones, métodos, librerías o lógica
- Sin repetir ni parafrasear viñetas o tipos
- Ser conciso sobre oraciones largas
- Verbo infinitivo

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
