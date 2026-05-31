# ── SISTEMA ────────────────────────────────────────────────────
# Archivos, Red y Administración del sistema

# ── Archivos ──────────────────────────────────────────────────
alias bat="bat --color=always --italic-text=always --style=plain --paging=never"
alias cdu="cdu -rsi -dh"
alias dfc="dfc -T -dw -t -squashfs -q mount"
alias lsa="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
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
alias lsd="eza --group-directories-first --icons=auto"
alias lsD="eza -al --follow-symlinks --git --mounts --header --group-directories-first --sort=type --icons=auto"
alias lst="eza --tree -l --follow-symlinks --mounts --header --smart-group --group-directories-first --icons=never --no-user --no-permissions --no-time --no-filesize"
alias lsT="eza --tree -l --follow-symlinks --mounts --header --smart-group --group-directories-first --icons=auto --sort=name --sort=extension --no-permissions --no-time --git"

# ── Red ───────────────────────────────────────────────────────
alias ip="ip --color=auto"
alias ports="netstat -tunalp"
alias info-eth="mii-tool -v eno1"
alias ip-wan="dig @resolver1.opendns.com myip.opendns.com +short"
alias wifi="nmcli dev wifi list --rescan yes"

# ── Sistema ────────────────────────────────────────────────────
alias neofetch="neofetch --size 220px --kitty --source ~/Dropbox/profile_pics/"
alias ka-df="df -hT -x tmpfs -x devtmpfs -x efivarfs"
alias mem+="ps -eo pid,ppid,cmd,%mem --sort=-%mem | head"
alias cpu+="ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head"
alias dmesg="dmesg --ctime --follow"

# Journal
alias journalctl-fail="journalctl --no-pager --since "yesterday" --until "today" -p 3 -o json | jq '._EXE' | sort | uniq -c | sort -rn"
alias journalctl-kernel="journalctl -f -k -o cat"
alias journalctl-lastboot="journalctl -b -1 -p 0..3"
alias journalctl-ssh="journalctl -f _COMM=sshd"

# Admin
alias chao="reboot -h now"
alias F="faillock --reset"
alias mako-restore="for i in {1..20}; do makoctl restore; done"
alias neovim-update="pip install --upgrade neovim"
alias pac-autoremove="pacman -Q -dt -q | sudo pacman -Rn -"
alias pac-cleancache="cdu -B /var/cache/pacman/pkg && paccache -r -k 1 && cdu /var/cache/pacman/pkg"
alias paz="paru -Sua --noconfirm"
alias q="exit"
alias servicios="systemctl list-units --type=service --all"
alias zf='zoxide query -l | fzf \
    --header "Directorios frecuentes" \
    --header-first \
    --preview '\''lsd --color always --icon always --tree --depth 3 --group-dirs first {} 2>/dev/null'\'''

alias fr='rga --max-depth 1 --line-number --smart-case . 2>/dev/null | \
fzf --delimiter : \
    --nth 3.. \
    --preview '\''bat --style=numbers --color=always --highlight-line {2} {1}'\'' \
    --preview-window '\''~4,+{2}/2'\'''

# alias swtree='swaymsg -t get_tree | jq '\''.. | objects | select(.type=="con" and (.app_id? or .window?)) | {name, app_id, class:.window_properties.class, focused, urgent}'\'''

alias ppk='ps -eo pid,user,comm,cmd --sort=-%cpu | fzf --multi --header="Selecciona proceso(s) a matar" | awk "{print \$1}" | xargs -r kill'
