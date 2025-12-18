
histerilize ()
{ LC_ALL=C sed --debug -i '/$1/d' $HISTFILE }
# https://9to5answer.com/how-to-remove-an-entry-from-the-history-in-zsh
# Elimina del hgistorial aquello que s le indique, Hace falta salir y entrar
# nuevamente a la terminal para ver los cambios
# the prefix LC_ALL=C prevents 'illegal anycodings_zsh byte sequence' failure.

qrgen()
{ qrencode --verbose --background=faedeb --foreground=9b044c -s 8 -m 2 -l M -o "$(date +"qrcode_%F_%H%M%S").png" $1 }
# Genera qr a partir de texto. Colocarlos entre 'comillas'
# Tambien puedes redirigir un archivo, por ejemplo:
# qrgen < texto.txt
# Mas ejemplos en https://www.howtogeek.com/devops/how-to-create-qr-codes-from-the-linux-command-line/
#
#

zfun_wepb_convert()
{ dwebp "$1" -o "${1%.*}.jpg" }

function tinyurl() {
    local url="$1"
    local shortened_url=$(curl -s "http://tinyurl.com/api-create.php?url=${url}")
    echo "${shortened_url}"
}
