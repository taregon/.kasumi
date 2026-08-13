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

Genera mensaje de commit, en español neutro, siguiendo Conventional Commits.

### Header

- Formato: `tipo: descripción`
- Tipos:
  - `feat:` — funcionalidad nueva (antes no existía)
  - `fix:` — error corregido
  - `refactor:` — reestructuración de código existente
  - `style:` — formato, espacios, sangría (sin lógica)
  - `chore:` — dependencias, config, CI
  - `docs:` — exclusivamente archivos .md, comentarios o README
- Una sola línea, minúsculas, verbo en infinitivo, sin punto final

### Body

- Solo si el diff tiene 20+ líneas
- Máx 3 líneas, separadas por blanco
- Sin pasivas, cada línea inicia con `-`

### Prohibido

- Traducir términos técnicos consolidados
- Inventar cambios no presentes en el diff
- Incluir anclas: `[COMENTARIO]`, `[REF]`, `[META]`, `[+]` o `[-]`
- Mencionar código, variables, funciones, rutas o lógica
- Mencionar un tipo como verbo o sustantivo en la descripción
- Describir qué es el cambio en vez de qué hace

## user

Basado en este diff

```diff
${sys-diff.staged_diff}
```

Genera el commit
