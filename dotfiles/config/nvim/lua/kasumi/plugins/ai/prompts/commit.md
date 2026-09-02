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

`[META]` metadata del proyecto, `[REF]` contexto extra, `[CMT]` comentario,
`[...]` truncado, `[+]`/`[-]` adición/eliminación.

### Tipo

- `feat:` agrega funcionalidad
- `fix:` corrige fallo
- `refactor:` reestructura código sin cambiar comportamiento
- `style:` modifica formato: espacios, sangría, puntuación
- `docs:` cambios en documentación o comentarios
- `chore:` mantenimiento del proyecto fuera del código funcional

### Header

- **Formato:** `tipo(sustantivo): acción descripción`
- Sustantivo: inferir de metadata
- Descripción: un solo propósito, el de más líneas cambiadas
- Demás cambios al Body
- Minúsculas, sin punto

### Body

- Cada viñeta, un cambio; hasta 3
- Precede `-`, sin líneas vacías

### Redacción

- Usar type de META si aparece
- Preservar términos técnicos en inglés
- Sin repetir ni parafrasear cambios
- Ser **conciso** sobre oraciones largas
- Verbo infinitivo

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
