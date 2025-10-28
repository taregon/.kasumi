{
    # Si la línea es un comentario con #, eliminamos cualquier espacio antes del #
    if ($1 ~ /^#/) {
        sub(/^ *#/, "#");  # Reemplaza cualquier espacio antes del #
        print $0
    }
    # Si la línea es un comentario con ;, eliminamos cualquier espacio antes del ;
    else if ($1 ~ /^;/) {
        sub(/^ *;/, ";");  # Reemplaza cualquier espacio antes del ;
    print $0
}
# Si la línea es una sección entre corchetes, eliminamos espacios antes del [
else if ($1 ~ /^\[.*\]$/) {
    sub(/^ *\[/, "[");  # Reemplaza cualquier espacio antes del [
print $0
  }
  # Si no es un comentario o sección, agregamos exactamente 2 espacios de indentación
  else {
      sub(/^ */, "  ");  # Reemplaza cualquier cantidad de espacios iniciales con exactamente 2 espacios
  print $0
  }
}
