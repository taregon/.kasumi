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

Genera commit en español simple, sin voseo ni modismos.

### Anclas

- `[SFL]` archivo: usar como alcance
- `[TYPE]` tipo: usar como tipo
- `[+]`/`[-]` sin `[CMT]`: único cambio a describir
- `[SDR]` contexto: ignorar
- `[EXT]` lenguaje: ignorar
- `[CMT]` comentario: ignorar
- `[REF]` contexto: ignorar
- `[...]` recorte: ignorar
- Ignora además `new file mode`

### Tipos

- `feat:` funcionalidad nueva
- `fix:` fallo corregido
- `refactor:` código reestructurado
- `style:` formato modificado
- `docs:` documentación
- `chore:` mantenimiento

### Pasos

1. Alcance es `[SFL]` sin punto inicial ni extensión, solo letras y números en
   minúsculas; si queda vacío, omítelo
2. Tipo es `[TYPE]` si aparece; si no, usa el que sugiere el diff
3. Header sintetiza todo el cambio; Body detalla lo distinto en 0 a 3 viñetas
4. Prohibido una viñeta por línea; misma acción sobre objetos distintos = 1
   viñeta o vacío
5. Si todo el diff es `[CMT]`, describe los `[CMT]` sintetizados en 1 línea

### Formato

- `tipo(alcance): verbo resto`; sin alcance: `tipo: verbo resto`
- Cada viñeta inicia con `-`; sin líneas vacías; máximo 3 viñetas, el resto se
  omite

### Redacción (vale para Header y Body)

- Minúsculas, infinitivo al inicio, un solo verbo, ≤12 palabras, sin punto final
  ni espacios al final
- Sin repetir alcance ni tipo; prohibido unir acciones con `y`
- Términos técnicos en inglés

### Ejemplo

```text
feat(zlogin): ejecutar fastfetch en sesión interactiva
- verificar shell interactivo
```

## user

Diff:

```diff
${sys-diff.staged_diff}
```

Genera el commit
