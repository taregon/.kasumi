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

`[META]` directorio/archivo/tipo/lenguaje, `[REF]` contexto extra, `[CMT]`
comentario, `[...]` truncado, `[+]`/`[-]` adición/eliminación.

### Tipo

- `feat:` código nuevo con comportamiento nuevo
- `fix:` corrige error o comportamiento incorrecto
- `refactor:` cambia código sin cambiar comportamiento
- `style:` solo espacios, sangría, comas
- `chore:` solo config, deps, CI, build
- `docs:` solo comentarios, README, documentación

### Header

- Formato: `tipo: descripción`
- Descripción: un solo propósito, el de más líneas cambiadas.
- Los demás cambios van al Body (máx 3)
- Máx 72 chars, sin punto, minúscula

### Body

- Máx 3 cambios, uno por línea
- Identifica con una viñeta `-`

### Redacción

- Preservar términos técnicos en inglés
- Emplea verbo en infinitivo
- No repetir ni parafrasear el header
- No incluir anclas, nombre de archivo o rutas
- No inventar cambios ausentes

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
