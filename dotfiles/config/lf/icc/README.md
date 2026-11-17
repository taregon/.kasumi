# Perfiles ICC para lfpreview

## Perfiles disponibles

| Perfil            | Tamaño    | Curva TRC  | Estado     |
| ----------------- | --------- | ---------- | ---------- |
| sRGB-v2-magic.icc | 736 bytes | 182 puntos | **Activo** |
| sRGB-v2-micro.icc | 456 bytes | 42 puntos  | Respaldo   |

Fuente: [Compact-ICC-Profiles][5]

## Problema

Sin perfil ICC embebido, algunos navegadores en pantallas wide-gamut tratan
imágenes como si fueran del espacio de color del display, causando colores
sobresaturados. Facebook embebe [TinyRGB][1] (524 bytes, descripción `c2`) en
las miniaturas y los JPEG redimensionados que sirve desde 2012.

## Solución

sRGB-v2-magic ofrece una precisión cercana a la curva de 1024 puntos del perfil
de referencia de [ArgyllCMS][2] con tamaño mínimo. Técnicas de optimización
aplicadas en [PhotoSauce][3]:

| Técnica                | Ahorro   | Detalle                                  |
| ---------------------- | -------- | ---------------------------------------- |
| Eliminar `bkpt` tag    | 32 bytes | Punto negro redundante (0,0,0 implícito) |
| Mover TRC a ScriptCode | 64 bytes | ScriptCode es obsoleto (Mac OS clásico)  |
| Corregir alineación    | 4 bytes  | Padding innecesario en TinyRGB           |

## Pipeline de procesamiento

Orden del pipeline ImageMagick (settings → archivo → operadores en secuencia),
según la [documentación oficial][6]:

```
magick \
    -define jpeg:size="800x800" \
    -define jpeg:optimize-coding=true \
    -quality 90 \
    "$FILE_PATH" \
    -auto-orient \
    -profile "$ICC_PROFILE" \
    -strip \
    -sampling-factor 4:2:0 \
    -colorspace RGB \
    -filter Triangle \
    -thumbnail "800x800>" \
    -colorspace sRGB \
    -profile "$ICC_PROFILE" \
    "${cache_path}.jpg"
```

- `-profile` antes de `-strip`: convierte con el perfil de origen, de modo que
  una imagen AdobeRGB o Display P3 llega a sRGB antes de perder el perfil. Si la
  imagen no trae perfil, solo asigna sRGB sin tocar los píxeles
- `-auto-orient` antes de `-strip`: la orientación EXIF desaparece al eliminar
  metadatos
- `-strip`: descarta EXIF y perfiles antes de escribir; `-thumbnail` ya elimina
  los perfiles, así que es explícito más que necesario
- `-sampling-factor 4:2:0`: submuestreo croma (medido: 32% menos tamaño). Es un
  _setting_ del codificador JPEG, su posición es indiferente mientras preceda al
  archivo de salida
- `-colorspace RGB` antes del resize: procesar en luz lineal
- `-colorspace sRGB` después del resize: volver al espacio de visualización
- `-profile` al final: incrusta el perfil [ICC][4] después de todas las
  transformaciones
- Sin `-intent`: solo afecta conversiones vía lcms y en esta secuencia no queda
  ninguna que lo consuma (medido: `Perceptual` y `Relative` dan RMSE 0). Si se
  agrega una conversión real, debe ir antes de ese `-profile`

## Resultados de verificación

Medido con `magick compare` (Q16: el valor normalizado divide por 65535, donde
un nivel de 8-bit equivale a 257):

| Prueba                                                           | Resultado                         |
| ---------------------------------------------------------------- | --------------------------------- |
| `-profile` sobre imagen sin perfil (magic, micro y sin perfil)   | RMSE 0                            |
| magic vs micro como perfil de **origen** (conversión a AdobeRGB) | PAE 25 ≈ 0.1 nivel                |
| Imagen AdobeRGB con `-strip` antes de `-profile`                 | RMSE 3216 (0.0491 ≈ 12.5 niveles) |
| Imagen AdobeRGB con `-profile` antes de `-strip`                 | RMSE 225 (0.0034 ≈ 0.9 niveles)   |

magic y micro son pixel-idénticos a 8-bit: la diferencia TRC (182 vs 42 puntos)
no impacta la salida. La primera fila muestra que `-profile` sobre una imagen ya
en sRGB solo asigna el perfil, por lo que una comparación entre ambos perfiles
dentro de este pipeline no prueba nada; hay que usarlos como perfil de origen.

El orden de `-profile` y `-strip` sí importa: descartar el perfil original antes
de convertir reinterpreta los píxeles de una imagen wide-gamut como si fueran
sRGB (fila 3 frente a la fila 4). Los valores de una tabla anterior (control vs
magic, RMSE 1274.51) no eran reproducibles porque ese pipeline de control no
está versionado.

## Referencias

[1]: https://skia.googlesource.com/skcms/+/refs/heads/main/profiles/sRGB_Facebook.icc
[2]: https://ninedegreesbelow.com/photography/srgb-profile-comparison.html
[3]: https://photosauce.net/blog/post/making-a-minimal-srgb-icc-profile-part-1-trim-the-fat-abuse-the-spec
[4]: https://www.color.org/specification/ICC.1-2001-04.pdf
[5]: https://github.com/saucecontrol/Compact-ICC-Profiles
[6]: https://imagemagick.org/command-line-processing/
