# Ruta .config/zsh/zalias
# Para revertir los alias (o sea ver como estan compuestos)
# utilizar el comando type <alias>, ejemplo: type exa.

# ── FZF ─────────────────────────────────────────────────────
alias fh="history | fzf +s --tac"

# ── PUKE RAINBOW ────────────────────────────────────────────
alias df="grc df -hT --total -x tmpfs -x devtmpfs -x efivarfs -x squashfs"
alias dig="grc dig"
alias du="grc du -h"
alias free="grc free -m"
alias ifconfig="grc ifconfig"
alias ip="ip --color=auto"
alias last="grc last -12axw"
alias lsblk="grc lsblk -o NAME,TYPE,MODEL,SIZE,FSTYPE,PARTTYPENAME,MOUNTPOINTS,LABEL -e 7"
alias netstat="grc netstat"
alias ping="grc ping"
alias ports="netstat -tunalp"
alias ps="grc ps"
alias sensors="grc sensors"
alias stat="grc stat"
alias tail="grc tail"
alias w="grc w --ip-addr"
alias whois="grc whois"

# ── COLOR TEST ──────────────────────────────────────────────
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

# ── JOURNAL ─────────────────────────────────────────────────
alias journalctl-fail="journalctl --no-pager --since "yesterday" --until "today" -p 3 -o json | jq '._EXE' | sort | uniq -c | sort -rn"
alias journalctl-kernel="journalctl -f -k -o cat"
alias journalctl-lastboot="journalctl -b -1 -p 0..3"
alias journalctl-ssh="journalctl -f _COMM=sshd"
alias journalctl="grc journalctl -f"

# ── VOLUMEN ─────────────────────────────────────────────────
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

# ── YT-DLP ──────────────────────────────────────────────────
alias yt-720='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s" -f "bv[height=720][ext=mp4]+ba[ext=m4a]" --merge-output-format mp4'
alias yt-1080='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s" -f "bv[height=1080][ext=mp4]+ba[ext=m4a]" --merge-output-format mp4'
alias yt-dlp='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s"'
alias yt-mp3='yt-dlp -f ba -x --audio-format mp3'
alias yt-update="python3 -m pip install -U yt-dlp"

# ╒════════════════════════════════════════════════════════════╕
# │                         POWER USER                         │
# ╘════════════════════════════════════════════════════════════╛

# ── TRIVIAL ─────────────────────────────────────────────────
alias cavak="cava -p ~/.config/cava/kasumi-cava.conf"
alias a_miniscula="tr '[:upper:]' '[:lower:]'"
alias chao="reboot -h now"
alias clima='curl wttr.in'
alias climat='curl "wttr.in?format=3"'
alias lugar='/usr/lib/geoclue-2.0/demos/where-am-i'
alias fecha="date +'%Y%m%d-%H%M'"
alias pantalla='grep -i "monitor name" /var/log/Xorg.0.log'
alias h="history"
alias q="exit"
alias qr-leer="zbarimg -q --raw -S disable -S qrcode.enable"
alias rld-t="tmux source ~/.tmux.conf"
alias rld-z="source ~/.zshrc"
alias fuentes="kitty +list-fonts --psnames"
alias optimize_png="pngquant --quality=75-90 --verbose --floyd=0.7 --ext _optimized.png"
alias optimize_jpg="zfun_jpegoptim"
alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias cheat='curl cheat.sh/'
alias test-cursor="kitten mouse-demo"
alias less='TERM=xterm-256color less'
alias man='TERM=xterm-256color man'
alias figlet="figlet -f smshadow"
alias icat="kitty +kitten icat"
alias unimatrix="unimatrix -c yellow -l ns -af"
alias ka-bench-nvim="nvim --startuptime /tmp/nvim.log +q && tail -n 20 /tmp/nvim.log | bat --paging=never -l log"
alias wg3t="wget \
    --progress=bar:force \
    --rejected-log=wget.log \
    --random-wait \
    --retry-connrefused \
    --timeout=30 \
    --tries=5 \
    --user-agent="$IXOS_USER_AGENT" \
    --waitretry=5 \
    -c \
"
alias wget-beta="wget \
    --content-disposition \
    --ignore-length \
    --no-check-certificate \
    --no-verbose \
    --output-file=wget.log \
    --progress=bar:force \
    --random-wait \
    --retry-connrefused \
    --show-progress \
    --timeout=30 \
    --tries=5 \
    --trust-server-names \
    --user-agent="$IXOS_USER_AGENT" \
    --waitretry=5 \
    -c \
    -w 8 \
"
alias lorem_bacon="curl 'https://baconipsum.com/api/?start-with-lorem=1&type=meat-and-filler&format=text&paras=30'"
alias lorem_dinos="curl 'https://dinoipsum.com/api?format=text&paragraphs=30'"

# ── SYSADMIN ─────────────────────────────────────────────────
alias info-eth="mii-tool -v eno1"
alias ip-wan="dig @resolver1.opendns.com myip.opendns.com +short"
alias neovim-update="pip install --upgrade neovim"
alias pac-autoremove="pacman -Q -dt -q | sudo pacman -Rn -"
alias pac-cleancache="cdu -B /var/cache/pacman/pkg && paccache -r -k 1 && cdu /var/cache/pacman/pkg"
alias servicios="systemctl list-units --type=service --all"
alias wifi="nmcli dev wifi list --rescan yes"
alias yeyo="yay -Suy --noconfirm"
alias F="faillock --reset"
alias mako-restore="for i in {1..20}; do makoctl restore; done"

# ── ARCHIVOS ─────────────────────────────────────────────────
alias bat="bat --color=always --italic-text=always --style=plain --paging=never"
alias cdu="cdu -rsi -dh"
alias dfc="dfc -T -dw -t -squashfs -q mount"
alias lsa="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
# alias lt="lsd --tree --blocks=name,size --total-size -v"
alias cuantoscount='find . -type f | wc -l'
alias recien="find . -mindepth 1 -mtime 0 -printf '%Tc %p\n' | sort -n"
alias findnot="find -not -path '*/.*' -iname"
alias statf='stat --printf "  Fichero: %n
E/S: %o\t%F
Links: %h ModoHEX: %f  SELinux: %C
Acceso: (%a/%t)  Uid: (%u/%U)\tGid: (%g/%G)
Acceso: %x
Modificación: %y
Cambio: %z
Creación: %w"'
alias stat-date="stat --printf '%w\t%n\n'"
alias rm='nocorrect rm -Iv'
alias history="history 0"
# ────────────────────────────────────────────────────────────
alias lsd="eza --group-directories-first --icons=auto"
alias lsD="eza -al --follow-symlinks --git --mounts --header --group-directories-first --sort=type --icons=auto"
alias lst="eza --tree -l --follow-symlinks --mounts --header --smart-group --group-directories-first --icons=never --no-user --no-permissions --no-time --no-filesize"
alias lsT="eza --tree -l --follow-symlinks --mounts --header --smart-group --group-directories-first --icons=auto --sort=name --sort=extension --no-permissions --no-time --git"

# ── MONITOREO ─────────────────────────────────────────────────
alias neofetch="neofetch --size 220px --kitty --source ~/Dropbox/profile_pics/"
alias ka-df="df -hT -x tmpfs -x devtmpfs -x efivarfs"
alias mem+="ps -eo pid,ppid,cmd,%mem --sort=-%mem | head"
alias cpu+="ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head"
alias dmesg="dmesg --ctime --follow"
