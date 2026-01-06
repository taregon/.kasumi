# Ruta .config/zsh/zalias
# Para revertir los alias (o sea ver como estan compuestos)
# utilizar el comando type <alias>, ejemplo: type exa.
#        __         _
#  ___ _/ /____ _  (_)__  ___
# / _ `/ __/ _ `/ / / _ \(_-<
# \_,_/\__/\_,_/_/ /\___/___/
#             |___/
#
alias a_miniscula="tr '[:upper:]' '[:lower:]'"
alias chao="reboot -h now"
alias clima='curl wttr.in'
alias climat='curl "wttr.in?format=3"'
alias lugar='/usr/lib/geoclue-2.0/demos/where-am-i'
alias fecha="date +'%Y%m%d-%H%M'"
alias pantalla='grep -i "monitor name" /var/log/Xorg.0.log'
alias h="history"
alias info-eth="mii-tool -v eno1"
# alias ip-lan="ip add | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias ip-wan="dig @resolver1.opendns.com myip.opendns.com +short"
alias lorem_bacon="curl 'https://baconipsum.com/api/?start-with-lorem=1&type=meat-and-filler&format=text&paras=30'"
alias lorem_dinos="curl 'https://dinoipsum.com/api?format=text&paragraphs=30'"
alias neovim-update="pip install --upgrade neovim"
alias pac-autoremove="pacman -Q -dt -q | sudo pacman -Rn -"
alias pac-cleancache="cdu -B /var/cache/pacman/pkg && paccache -r -k 1 && cdu /var/cache/pacman/pkg"
alias q="exit"
alias qr-leer="zbarimg -q --raw -S disable -S qrcode.enable"
alias recien="find . -mindepth 1 -mtime 0 -printf '%Tc %p\n' | sort -n"
alias rld-t="tmux source ~/.tmux.conf"
alias rld-z="source ~/.zshrc"
alias servicios="systemctl list-units --type=service --all"
alias wifi="nmcli dev wifi list --rescan yes"
alias fuentes="kitty +list-fonts --psnames"
alias optimize_png="pngquant --quality=75-90 --verbose --floyd=0.7 --ext _optimized.png"
alias optimize_jpg="zfun_jpegoptim"
alias findnot="find -not -path '*/.*' -iname"
# De pruebas
alias yeyo="yay -Suy --noconfirm"
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias lsa="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cheat='curl cheat.sh/'
alias mem+="ps -eo pid,ppid,cmd,%mem --sort=-%mem | head"   # Processes consuming most mem
alias cpu+="ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head"   # Processes consuming most cpu
alias lm='lsa -tA -1r'                                      # List files sorted by last modified
alias ld="lsa -DT --show-symlinks --long --header"          # Lista solo carpetas
alias cuantos='find . -type f | wc -l'                      # Cantidad de archivos
alias test-cursor="kitten mouse-demo"
# alias lf="nvim $(fzf --preview='bat --color=always {}')"
#    ___                     ____         __
#   / _/_ ________ __ ______/ _(_)__  ___/ /__ ____
#  / _/ // /_ /_ // // /___/ _/ / _ \/ _  / -_) __/
# /_/ \_,_//__/__/\_, /   /_//_/_//_/\_,_/\__/_/
#                /___/
#
alias fh="history | fzf +s --tac"
#
#    ___  ___ _    _____ __________ _____ ___ ____
#   / _ \/ _ \ |/|/ / -_) __/___/ // (_-</ -_) __/
#  / .__/\___/__,__/\__/_/      \_,_/___/\__/_/
# /_/
#
alias dmesg="dmesg --ctime --follow"
alias exa="exa --icons --group-directories-first --sort=newest --git --links --header -aglmr"
alias figlet="figlet -f smshadow"
alias icat="kitty +kitten icat"
alias lt="lsd --tree --blocks=name,size --total-size -v"
alias lsd="lsd --group-directories-first"
alias history="history 0"
alias neofetch="neofetch --size 220px --kitty --source ~/Dropbox/profile_pics/"
alias rm='nocorrect rm -Iv'
alias ssh="TERM=xterm kitty +kitten ssh"
alias stat-date="stat --printf '%w\t%n\n'"
alias unimatrix="unimatrix -c yellow -l ns -af"

alias wg3t='wget \
    --user-agent="$IXOS_USER_AGENT" \
    -c \
    --tries=5 \
    --waitretry=5 \
    -w 8 \
    --random-wait \
    --retry-connrefused \
    --no-check-certificate \
    --content-disposition \
    --ignore-length \
    --progress=bar:force \
    --show-progress \
    --timeout=30 \
    --output-file=wget.log'

alias ar1a='aria2c \
    --user-agent="$IXOS_USER_AGENT" \
    --continue=true \
    --max-connection-per-server=4 \
    --split=4 \
    --min-split-size=5M \
    --retry-wait=5 \
    --max-tries=5 \
    --auto-file-renaming=false \
    --summary-interval=30 \
    --show-console-readout=true \
    --auto-save-interval=30 \
    --log-level=notice \
    --console-log-level=error \
    --dir=. \
    --log=aria2c.log'
#               __                    _      __
#    ___  __ __/ /_____ ___________ _(_)__  / /  ___ _    _____
#   / _ \/ // /  '_/ -_)___/ __/ _ `/ / _ \/ _ \/ _ \ |/|/ / _ \
    #  / .__/\_,_/_/\_\\__/   /_/  \_,_/_/_//_/_.__/\___/__,__/_//_/
# /_/
#
#alias df="grc df -H --total --exclude-type=tmpfs --exclude-type=devtmpfs --exclude-type=squashfs"
alias bat="bat --color=always --italic-text=always --style=plain --paging=never"
alias cdu="cdu -rsi -dh"
alias df="grc df -H --total --exclude-type=devtmpfs --exclude-type=squashfs"
alias dfc="dfc -T -dw -t -squashfs -q mount"
alias dig="grc dig"
alias du="grc du -h"
alias free="grc free -m"
alias ifconfig="grc ifconfig"
alias ip="ip --color=auto"
alias last="grc last -12axw"
alias lsblk="grc lsblk -o NAME,TYPE,MODEL,SIZE,FSTYPE,PARTTYPENAME,MOUNTPOINTS,LABEL -e 7"
alias netstat="grc netstat"
alias ping="grc ping"
alias ps="grc ps"
alias sensors="grc sensors"
alias stat="grc stat"
alias tail="grc tail"
alias w="grc w --ip-addr"
alias whois="grc whois"
alias ports="netstat -tunalp"
#            __             __          __
#  _______  / /__  ________/ /____ ___ / /_
# / __/ _ \/ / _ \/ __/___/ __/ -_|_-</ __/
# \__/\___/_/\___/_/      \__/\__/___/\__/
#
alias colortest-0="curl -sL https://tinyurl.com/3dhra5dr -o - | sh"
alias colortest-1="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/colortest -o - | sh"
alias colortest-2="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/colorview -o - | sh"
alias colortest-3="curl -s https://raw.githubusercontent.com/SystematicError/palette/master/palette-slim -o - | sh"
alias colortest-blocks="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/blocks1 -o - | sh"
alias colortest-crunch="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/crunch -o - | sh"
alias colortest-fade="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/fade -o - | sh"
alias colortest-pacman="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/pacman -o - | sh"
alias colortest-panes="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/panes -o - | sh"
alias colortest-skull="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/pukeskull -o - | sh"
alias colortest-space="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/space-invaders -o - | sh"
alias colortest-unowns="curl -s https://raw.githubusercontent.com/stark/Color-Scripts/master/color-scripts/unowns.py -o - | python"
#       _                         __    __  __
#      (_)__  __ _________  ___ _/ /___/ /_/ /
#     / / _ \/ // / __/ _ \/ _ `/ / __/ __/ /
#  __/ /\___/\_,_/_/ /_//_/\_,_/_/\__/\__/_/
# |___/
#
alias journalctl-fail="journalctl --no-pager --since "yesterday" --until "today" -p 3 -o json | jq '._EXE' | sort | uniq -c | sort -rn"
alias journalctl-kernel="journalctl -f -k -o cat"
alias journalctl-lastboot="journalctl -b -1 -p 0..3"
alias journalctl-ssh="journalctl -f _COMM=sshd"
alias journalctl="grc journalctl -f"
#             __                          __
#  _  _____  / /______ ___  __ _____  ___/ /
# | |/ / _ \/ /___(_-</ _ \/ // / _ \/ _  /
# |___/\___/_/   /___/\___/\_,_/_//_/\_,_/
#
alias v-='amixer -q set Master 1%-'
alias v+='amixer -q set Master 1%+'
alias v--='amixer -q set Master 15%-'
alias v++='amixer -q set Master 15%+'
alias vmin='amixer -q set Master 0%'
alias v0='amixer -q set Master toggle'
alias v1='amixer -q set Master 10%'
alias v2='amixer -q set Master 20%'
alias v3='amixer -q set Master 30%'
alias v4='amixer -q set Master 40%'
alias v5='amixer -q set Master 50%'
alias v6='amixer -q set Master 60%'
alias v7='amixer -q set Master 70%'
alias v8='amixer -q set Master 80%'
alias v9='amixer -q set Master 90%'
alias vmax='amixer -q set master 100%'
#         __         ____
#   __ __/ /________/ / /__
#  / // / __/___/ _  / / _ \
    #  \_, /\__/    \_,_/_/ .__/
# /___/              /_/
#
alias yt-720='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s" -f "bv[height=720][ext=mp4]+ba[ext=m4a]" --merge-output-format mp4'
alias yt-1080='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s" -f "bv[height=1080][ext=mp4]+ba[ext=m4a]" --merge-output-format mp4'
alias yt-dlp='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s"'
alias yt-mp3='yt-dlp -f ba -x --audio-format mp3'
alias yt-update="python3 -m pip install -U yt-dlp"
