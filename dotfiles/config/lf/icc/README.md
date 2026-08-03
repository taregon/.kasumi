# Perfiles ICC para lfpreview

## Perfiles disponibles

| Perfil            | Tamaño    | Curva TRC  | Estado   |
| ----------------- | --------- | ---------- | -------- |
| sRGB-v2-magic.icc | 736 bytes | 182 puntos | `Activo` |
| sRGB-v2-micro.icc | 456 bytes | 42 puntos  | Respaldo |

Fuente: [Compact-ICC-Profiles][6]

## Problema

Sin perfil ICC embebido, algunos navegadores en pantallas wide-gamut tratan
imágenes como si fueran del espacio de color del display, causando colores
sobresaturados. Facebook embebe [TinyRGB][1] (524 bytes) en todas sus imágenes
desde 2012.

## Solución

sRGB-v2-magic ofrece precisión cercana al perfil [ArgyllCMS][2] (1024 puntos
TRC) con tamaño mínimo. Técnicas de optimización aplicadas en [PhotoSauce][3]:

| Técnica                | Ahorro   | Detalle                                  |
| ---------------------- | -------- | ---------------------------------------- |
| Eliminar `bkpt` tag    | 32 bytes | Punto negro redundante (0,0,0 implícito) |
| Mover TRC a ScriptCode | 64 bytes | ScriptCode es obsoleto (Mac OS clásico)  |
| Corregir alineación    | 4 bytes  | Padding innecesario en TinyRGB           |

## Pipeline de procesamiento

Orden del pipeline ImageMagick (settings → imagen → pre-procesamiento → resize →
perfil):

```
magick \
    -define jpeg:size="800x800" \
    -define jpeg:optimize-coding=true \
    -quality 90 \
    "$FILE_PATH" \
    -auto-orient \
    -strip \
    -sampling-factor 4:2:0 \
    -colorspace RGB \
    -intent Relative \
    -filter Triangle \
    -thumbnail "800x800>" \
    -colorspace sRGB \
    -profile "$ICC_PROFILE" \
    "${cache_path}.jpg"
```

- `-sampling-factor 4:2:0` después de `-strip`: submuestreo croma (ahorra ~30%
  tamaño)
- `-intent Relative` antes de `-thumbnail`: afecta conversión durante resize
- `-colorspace RGB` antes del resize: procesar en luz lineal
- `-colorspace sRGB` después del resize: volver al espacio de visualización
- `-profile` al final: incrusta perfil [ICC][5] después de todas las
  transformaciones

Ref: https://imagemagick.org/command-line-processing/

## Resultados de comparación

Orden de comando nuevo (settings → imagen → pre-procesamiento → resize →
perfil):

| Comparación      | RMSE    | Normalizado |
| ---------------- | ------- | ----------- |
| Control vs magic | 1274.51 | 0.0194478   |
| Control vs micro | 1274.51 | 0.0194478   |
| magic vs micro   | **0**   | **0**       |

magic y micro son pixel-identicos a 8-bit. La diferencia TRC (182 vs 42 puntos)
no impacta la salida. La diferencia vs control se debe a `-strip` del perfil ICC
original y reconversión a sRGB estándar.

## Referencias

[1]: https://github.com/nicedoc/iccs/blob/master/sRGB.icc
[2]: https://ninedegreesbelow.com/photography/srgb-profile-comparison.html
[3]: https://photosauce.net/blog/post/making-a-minimal-srgb-icc-profile-part-1-trim-the-fat-abuse-the-spec
[5]: https://www.color.org/specification/ICC1v43_2010-12.pdf
[6]: https://github.com/saucecontrol/Compact-ICC-Profiles
