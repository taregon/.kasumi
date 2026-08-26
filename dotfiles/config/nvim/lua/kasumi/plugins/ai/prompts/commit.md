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

- `feat:` código nuevo con comportamiento nuevo
- `fix:` corrige error o comportamiento incorrecto
- `refactor:` cambia código sin cambiar comportamiento
- `style:` solo espacios, sangría, comas
- `chore:` solo config, deps, CI, build
- `docs:` solo comentarios, README, documentación

### Header

- Formato: `tipo: descripción`
- Descripción: un solo propósito, el de más líneas cambiadas.
- Los demás cambios moverlos al Body (máx 3)
- Máx 72 chars, sin punto, minúscula

### Body

- Máx 3 cambios, uno por línea
- Identifica con una viñeta `-`
- Sin lineas vacías entre ellas

### Redacción

- Preservar términos técnicos en inglés
- No repetir ni parafrasear el header
- No incluir anclas, archivos o rutas
- Sin pleonasmos ni verbatim
- Verbo en infinitivo

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
