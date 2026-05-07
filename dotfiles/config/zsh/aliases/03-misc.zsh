# ── Atajos ─────────────────────────────────────────────────────
alias sumishell-date="date +'%Y%m%d-%H%M%S'"
alias sumishell-geo='/usr/lib/geoclue-2.0/demos/where-am-i'
alias sumishell-hist="history"
alias tolower="tr '[:upper:]' '[:lower:]'"
alias sumishell-rldt="tmux source ~/.tmux.conf"
alias sumishell-rldz="source ~/.zshrc"

# ── Terminal ──────────────────────────────────────────────────
alias sumiterm-figlet="figlet -f smshadow"
alias sumiterm-fonts="kitty +list-fonts --psnames"
alias sumiterm-fzf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias sumiterm-icat="kitty +kitten icat"
alias sumiterm-less='TERM=xterm-256color less'
alias sumiterm-man='TERM=xterm-256color man'
alias sumiterm-matrix="unimatrix -c yellow -l ns -af"
alias sumiterm-mouse="kitten mouse-demo"
alias sumiterm-xinfo='grep -i "monitor name" /var/log/Xorg.0.log'

# ── Desarrollo ────────────────────────────────────────────────
alias sumidev-jpg="zfun_jpegoptim"
alias sumidev-nvim="nvim --startuptime /tmp/nvim.log +q && tail -n 20 /tmp/nvim.log | bat --paging=never -l log"
alias sumidev-png="pngquant --quality=75-90 --verbose --floyd=0.7 --ext _optimized.png"
alias sumidev-qr="zbarimg -q --raw -S disable -S qrcode.enable"

# ── Media ───────────────────────────────────────────────────────
alias sumimedia-cava="cava -p ~/.config/cava/kasumi-cava.conf"

# ── Internet ──────────────────────────────────────────────────
alias suminet-clima='curl wttr.in'
alias suminet-climat='curl "wttr.in?format=3"'
alias suminet-wget="wget \
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
alias suminet-cheat='curl cheat.sh/'
alias suminet-loremb="curl 'https://baconipsum.com/api/?start-with-lorem=1&type=meat-and-filler&format=text&paras=30'"
alias suminet-lorend="curl 'https://dinoipsum.com/api?format=text&paragraphs=30'"
