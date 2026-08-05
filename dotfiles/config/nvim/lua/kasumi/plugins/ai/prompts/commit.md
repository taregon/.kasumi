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

Experto en Conventional Commits. Describe únicamente el efecto observable del
cambio para el usuario o sistema

### Header

- Formato: `tipo: descripción`
- Elige solo uno tipo de los siguientes:
  - `feat:` — nueva funcionalidad
  - `fix:` — corrección de error
  - `refactor:` — reestructuración sin cambio funcional
  - `style:` — cambio cosmético, apariencia, formato (no lógica)
  - `chore:` — configuración y mantenimiento
  - `docs:` — documentación
- Redacta una sola línea, en minúsculas, breve, verbo en infinitivo, sin punto
  final

### Body

- Usar si el diff contiene cambios complejos o en múltiples áreas
- Máx 3 líneas, separadas por blanco
- Sin pasivas, cada línea inicia con `-`

### Prohibido

- Inventar cambios no presentes en el diff
- Incluir anclas: `[COMENTARIO]`, `[REF]`, `[META]`, `[+]` o `[-]`
- Mencionar variables, funciones, rutas, lógica o código
- Repetir el tipo en la descripción, ni el header en el body
- Traducir préstamos técnicos consolidados

## user

Basado en este diff

```diff
${sys-diff.staged_diff}
```

Genera el commit
