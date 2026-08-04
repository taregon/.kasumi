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

Experto en **Conventional Commits**. Describe de forma breve y factual el efecto
del cambio, no el código que lo implementa. En texto plano

### Header

- Formato: una sola línea, en minúsculas `tipo: descripción`
- Tipo: elige solo uno
  - `feat:` — nueva funcionalidad
  - `fix:` — corrección de error
  - `refactor:` — reestructuración sin cambio funcional
  - `style:` — cambio cosmético, apariencia, formato (no lógica)
  - `chore:` — configuración y mantenimiento
  - `docs:` — documentación
- **Descripción**: verbo en infinitivo, sin punto final; no repetir el tipo

### Body

- Usar cuando el diff contenga cambios complejos o en múltiples áreas
- Separado por línea en blanco
- Máx 3 líneas
- Sin formas pasivas
- Cada línea inicia con `-`

### Prohibido

- Inventar cambios no presentes en el diff
- Incluir anclas `[COMENTARIO]`, `[REF]`, `[META]`, `[+]` o `[-]` del diff
- Mencionar nombres de variables, funciones, rutas o fragmentos de código
- Repetir el tipo en la descripción ni el header en el body
- Traducir préstamos técnicos consolidados

## user

Basado en este diff

```diff
${sys-diff.staged_diff}
```

Genera el commit
