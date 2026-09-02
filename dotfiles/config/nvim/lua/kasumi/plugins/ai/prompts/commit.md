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

### Tipo funcional

- `feat:` funcionalidad nueva
- `fix:` fallo corregido
- `refactor:` código reestructurado

### Tipo auxiliary

- `style:` formato modificado
- `docs:` documentación
- `chore:` mantenimiento

### Header

- Formato: `tipo(alcance): verbo descripción`
- Sustantivo: inferir de metadata
- Usa el type de `[META]` si aparece
- Descripción: un solo propósito, el de mayor volumen de líneas `[+]`/`[-]`
- Si empatan, usa el que aparece primero
- Demás cambios al Body
- Minúsculas, sin punto

### Body

- Inicia cada línea con `-`, sin líneas vacías
- Máximo 3 viñetas
- No uses voz pasiva

### Redacción

- Infinitivo, sin punto, ≤12 palabras
- Sin repetir el tipo en la descripción
- Términos técnicos en inglés

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
