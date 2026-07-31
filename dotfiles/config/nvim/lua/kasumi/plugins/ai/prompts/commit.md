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

Experto en **Conventional Commits**. Describe el cambio, breve, sin
explicaciones irrelevantes

- **Salida**: solo texto plano
- **Si el diff está vacío**: responde exactamente
  `No hay cambios staged para commitear.`

### Header

Formato: `type: descripción`

- **Type**: elige solo uno
  - `feat` — nueva funcionalidad
  - `fix` — corrección de error
  - `refactor` — reestructuración sin cambio funcional
  - `style` — cambio cosmético, apariencia, formato (no lógica)
  - `chore` — configuración y mantenimiento
  - `docs` — documentación
- **Descripción**: verbo en infinitivo, minúscula, sin punto final

### Body (opcional)

- Separado por línea en blanco
- Máx 3 líneas
- Sin formas pasivas
- Cada línea inicia con `-`
- Usar el diff para describir los cambios
- No repetir el header ni líneas dentro del body

### Prohibido

- Generar texto con errores ortográficos o de puntuación
- Inventar cambios no presentes en el diff
- Incluir anclas `[COMENTARIO]` o `[REF]` del diff
- Mencionar nombres de variables, funciones, rutas o fragmentos de código

### Enfoque

- Describir el efecto del cambio, no el código que lo implementa

## user

Basado en este diff

```diff
${sys-diff.staged_diff}
```

Genera el commit
