# ──「 Zsh Shell 」───────────────────────────────────────────
# ███████╗███████╗██╗  ██╗███████╗██╗     ██╗
# ╚══███╔╝██╔════╝██║  ██║██╔════╝██║     ██║
#   ███╔╝ ███████╗███████║█████╗  ██║     ██║
#  ███╔╝  ╚════██║██╔══██║██╔══╝  ██║     ██║
# ███████╗███████║██║  ██║███████╗███████╗███████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

# Bootstrap Zinit: clona si falta y prepara carga de plugins.
ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ──「 Completion 」──────────────────────────────────────────
# ▄▀▀▀▀ ▄▀▀▀▄ █▀▄▀█ █▀▀▀▄ █     █▀▀▀▀ ▀▀█▀▀ ▀▀█▀▀ ▄▀▀▀▄ █▄  █
# █     █   █ █   █ █▀▀▀  █     █▀▀     █     █   █   █ █ ▀▄█
#  ▀▀▀▀  ▀▀▀  ▀   ▀ ▀     ▀▀▀▀▀ ▀▀▀▀▀   ▀   ▀▀▀▀▀  ▀▀▀  ▀   ▀

# NOTA: Para revisar las activas, ejecuta: zstyle -L ':completion:*'

# Ajustes de autocompletado nativo (sin fzf-tab)

# Incluye '.' y '..' en completado de rutas.
# zstyle ':completion:*' special-dirs true

# Agrupa coincidencias por categoría.
# zstyle ':completion:*:matches' group 'yes'

# Navegación por menú con flechas si hay múltiples resultados.
# zstyle ':completion:*' menu select

# Muestra descripciones en completado.
# zstyle ':completion:*' verbose yes

# Formato de descripciones: %d = grupo.
# zstyle ':completion:*:descriptions' format '-- %d --'

# Colorea menú de completado con LS_COLORS.
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Completado global
# Desactiva menú nativo para fzf-tab (intercepta prefijo unambiguous).
zstyle ':completion:*' menu no

# Rehash: expone binarios nuevos sin recargar.
zstyle ':completion:*' rehash true

# Matcher: 'm:{a-zA-Z}={A-Za-z}' case-insensitive, 'r:|=*' prefijo parcial.
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' 'r:|=*'

# Fuente de procesos para kill/killall/renice: PID, usuario, comando.
zstyle ':completion:*:*:*:*:processes' command \
    'ps -u $USER -o pid,user,comm,cmd -w -w'

# git checkout sin orden alfabético; conserva cronológico.
zstyle ':completion:*:git-checkout:*' sort false

# Encabezados: expone $group para preview fzf-tab.
zstyle ':completion:*:descriptions' format '󰩗  %d'

# Fzf-tab — comportamiento global
# Lee FZF_DEFAULT_OPTS; con --tmux falla (issue #455): usar 'no'.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Flags adicionales para fzf interno.
zstyle ':fzf-tab:*' fzf-flags \
    --height=40%

# Encabezados: full(visible)/brief(duplicados)/none(__hide__)/quiet(conserva).
zstyle ':fzf-tab:*' show-group full

# Colores ANSI 256 cíclicos (4) para encabezados.
zstyle ':fzf-tab:*' group-colors \
    $'\033[38;5;248m' $'\033[38;5;152m' $'\033[38;5;134m' $'\033[38;5;140m'

# Navegación entre grupos: '<' '>' (default F1/F2).
zstyle ':fzf-tab:*' switch-group '<' '>'

# Variables internas - referencia
# $word     Valor que se inserta en la línea de comandos
# $desc     Texto visible en fzf (incluye descripción)
# $group    Categoría del candidato (ej: "[option]", "[filename]")
# $realpath Ruta absoluta (solo en candidatos tipo archivo/directorio)
# $words    Estado actual de la línea de comandos

# Fzf-tab — previews
# cd: árbol eza --only-dirs --level=2 --color=never.
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level=2 --color=never --only-dirs $realpath'

# git show: diff via delta; fzf-tab inyecta --ansi.
zstyle ':fzf-tab:complete:git-show:*' \
    fzf-preview 'git show --color=always "$word" | delta'

# ──「 Appearance 」──────────────────────────────────────────
# ▄▀▀▀▄ █▀▀▀▄ █▀▀▀▄ █▀▀▀▀ ▄▀▀▀▄ █▀▀▀▄ ▄▀▀▀▄ █▄  █ ▄▀▀▀▀ █▀▀▀▀
# █▀▀▀█ █▀▀▀  █▀▀▀  █▀▀   █▀▀▀█ █▀▀▀▄ █▀▀▀█ █ ▀▄█ █     █▀▀
# ▀   ▀ ▀     ▀     ▀▀▀▀▀ ▀   ▀ ▀   ▀ ▀   ▀ ▀   ▀  ▀▀▀▀ ▀▀▀▀▀
# Kitty ya exporta xterm-kitty (kitty.conf term); no forzar TERM.
# Ranger preview kitty depende de TERM nativo; tmux gestiona el suyo.
# ArchWiki Kitty#Terminal_issues_with_SSH: kitten ssh copia terminfo al remoto.
[[ "$TERM" == "xterm-kitty" ]] && alias ssh='kitty +kitten ssh'

export EDITOR="nvim" # editor por defecto (terminal/GUI)
export VISUAL="nvim" # idem

export RANGER_LOAD_DEFAULT_RC=FALSE # desactiva rc.conf predeterminado de ranger

export STARSHIP_CONFIG=~/.config/starship/kasumi.toml # configuración starship
TRANSIENT_PROMPT_TRANSIENT_PROMPT=' '                 # prompt transitorio vacío

export BAT_STYLE="full"                     # bat: listado completo
export BAT_THEME="base16"                   # tema compatible con kitty
export LS_COLORS="$(vivid generate kasumi)" # requiere vivid

export LESSOPEN="| src-hilite-lesspipe.sh %s"                  # Requiere: source-highlight
export LESS='-MRFI --use-color'                                # -M prompt, -F quit-if-one-screen, -R ANSI, -I ignore-case, --use-color UI
export MANPAGER='less -M +Gg -R --use-color -Dd+c -Du+g -Ds+y' # less -D colorea bold/cyan (Dd), underline/green (Du), standout/yellow (Ds) vía overstrike; requiere MANROFFOPT -P -c, sin LESS_TERMCAP
export MANROFFOPT='-P -c'                                      # nroff/grotty: deshabilita SGR/OSC8 -> legacy overstrike para que less coloree via -D; sin esto grotty emite SGR que ignora -D

# ──「 Fzf 」─────────────────────────────────────────────────
# █▀▀▀▀ ▀▀▀▀█ █▀▀▀▀
# █▀▀   ▄▀▀▀  █▀▀
# ▀     ▀▀▀▀▀ ▀
# Fzf — opciones globales; temas: https://vitormv.github.io/fzf-themes/
# FZF_FD_BASE via fd (--type f, --hidden, --follow) por rendimiento.
typeset -a FZF_FD_OPTS=(
    --exclude .bun
    --exclude .cache
    --exclude .cargo
    --exclude .config
    --exclude .git
    --exclude .local
    --exclude .mozilla
    --exclude .obsidian
    --exclude .stfolder
    --exclude .stversions
    --exclude build
    --exclude dotdrop
    --exclude node_modules
    --exclude venv
    --follow
    --hidden
    --strip-cwd-prefix
)

# Fzf globales: colores/layout/comportamiento.
export FZF_DEFAULT_OPTS='
  --color=fg:#818F98,fg+:#C8D0D6,bg:-1,bg+:#333C42
  --color=hl:#A88E6B,hl+:#FBC06E,info:#94B8BC,marker:#FF62E0
  --color=prompt:#AFEEAE,spinner:#EA676D,pointer:#FBC06E,header:#87AFAF
  --color=border:#62727c,label:#62727c,query:#D8DEE2
  --border="sharp"
  --border-label="( 󱐋 )"
  --preview-window="sharp"
  --prompt="󰘧 "
  --info=right
  --marker="›"
  --pointer="▒"
  --separator="─"
  --scrollbar="▐"
  --layout=reverse
  --height=75%
' # Fin de linea

# Ctrl+r: historial
export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS
--bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'"

# Ctrl+t: archivos (via fd)
export FZF_CTRL_T_COMMAND="fd --type f ${FZF_FD_OPTS[@]}"

# ──「 History 」─────────────────────────────────────────────
# █   █ ▀▀█▀▀ ▄▀▀▀▀ ▀▀█▀▀ ▄▀▀▀▄ █▀▀▀▄ █   █
# █▀▀▀█   █    ▀▀▀▄   █   █   █ █▀▀▀▄ ▀▀▀▀█
# ▀   ▀ ▀▀▀▀▀ ▀▀▀▀    ▀    ▀▀▀  ▀   ▀ ▀▀▀▀▀
# Opciones: `set -o` — https://zsh.sourceforge.io/Doc/Release/Options.html

PROMPT_EOL_MARK="🐙" # marca EOL del prompt

# Historial en XDG_STATE_HOME per spec 0.8 (state, persiste entre reinicios, no cache) — https://specifications.freedesktop.org/basedir/latest/
HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p -m 0700 "${HISTFILE:h}" # asegura directorio existe (0700 spec §4, idempotente)

# Migra historial de ~/.cache → state si state no existe y cache no vacío; limpia huérfano vacío.
if [[ -s "$HOME/.cache/zsh_history" && ! -s "$HISTFILE" ]]; then
    mv -- "$HOME/.cache/zsh_history" "$HISTFILE"
elif [[ -f "$HOME/.cache/zsh_history" && ! -s "$HOME/.cache/zsh_history" ]]; then
    rm -f -- "$HOME/.cache/zsh_history" # huérfano 0B tras migración
fi

HISTSIZE=30000                # en memoria
SAVEHIST=30000                # en disco
setopt BANG_HIST              # expansión de '!' en historial
setopt COMPLETE_ALIASES       # completa alias
setopt EXTENDED_HISTORY       # guarda timestamp ':inicio:duración;comando'
setopt HIST_ALLOW_CLOBBER     # historial puede sobrescribir con CLOBBER off
setopt HIST_BEEP              # beep si historial inexistente
setopt HIST_EXPIRE_DUPS_FIRST # purga duplicados al límite HISTSIZE
setopt HIST_FIND_NO_DUPS      # omite duplicados en búsqueda
setopt HIST_IGNORE_ALL_DUPS   # elimina previo si duplicado (implica HIST_IGNORE_DUPS)
setopt HIST_IGNORE_SPACE      # ignora comandos con espacio inicial
setopt HIST_NO_STORE          # no guarda 'fc -l'
setopt HIST_REDUCE_BLANKS     # colapsa blancos
setopt HIST_SAVE_NO_DUPS      # no guarda duplicados en disco
setopt HIST_VERIFY            # muestra comando antes de ejecutar desde historial
setopt NO_HIST_NO_FUNCTIONS   # conserva funciones
setopt RM_STAR_WAIT           # espera 10s en 'rm *'
setopt SHARE_HISTORY          # comparte entre sesiones (implica APPEND/INC_APPEND)

# Filtra historial: solo comandos existentes, excluye HISTORY_IGNORE
HISTORY_IGNORE="* --help|clear|exa|exit|ls|lsd|man *|pwd|q|ranger|yt-mp3"

# Hook historial: filtra qué guardar
zshaddhistory() {
    local line cmd
    line=${1%%$'\n'}
    cmd=${line%% *}
    whence "$cmd" >| /dev/null || return 1 # 1. ignora si comando no existe
    local -a ignore_patterns
    ignore_patterns=(${(s:|:)HISTORY_IGNORE}) # divide patrones por |
    for pattern in "${ignore_patterns[@]}"; do
        [[ $line == $~pattern ]] && return 1 # 2. ignora si coincide con HISTORY_IGNORE
    done
    return 0
}

# ──「 Zinit 」───────────────────────────────────────────────
# ▀▀▀▀█ ▀▀█▀▀ █▄  █ ▀▀█▀▀ ▀▀█▀▀
# ▄▀▀▀    █   █ ▀▄█   █     █
# ▀▀▀▀▀ ▀▀▀▀▀ ▀   ▀ ▀▀▀▀▀   ▀

# NOTA: Runbook on-demand (sin envoltorio): zinit times -s -m, status --all,
# changes <plugin>, report, bindkeys, completions/csearch/cdlist, recall/glance.
# Flujos multi-paso: kzsys-zinit-update, kzsys-zinit-repair.

# Autocompletado extra para cientos de comandos; usa zicompinit+zicdreplay (Turbo).
zinit ice wait'0' lucid blockf atload'zicompinit; zicdreplay'
zinit light zsh-users/zsh-completions

zinit ice wait'0' lucid blockf # interfaz avanzada para autocompletado con fzf
zinit light Aloxaf/fzf-tab

# Sugerencias del historial al escribir; completa con →, inicia automático.
zinit ice wait'0' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Colorea sintaxis al escribir; carga al final para no interferir con completado/autosuggest.
zinit ice wait'0' lucid
zinit light zsh-users/zsh-syntax-highlighting

# Forgit via fzf (glo=log, gd=diff) — https://github.com/wfxr/forgit
zinit ice wait'1' lucid
zinit light wfxr/forgit

zinit ice wait'0' lucid # transient prompt: limpia líneas previas
zinit light olets/zsh-transient-prompt

# ──「 Personal 」────────────────────────────────────────────
# █▀▀▀▄ █▀▀▀▀ █▀▀▀▄ ▄▀▀▀▀ ▄▀▀▀▄ █▄  █ ▄▀▀▀▄ █
# █▀▀▀  █▀▀   █▀▀▀▄  ▀▀▀▄ █   █ █ ▀▄█ █▀▀▀█ █
# ▀     ▀▀▀▀▀ ▀   ▀ ▀▀▀▀   ▀▀▀  ▀   ▀ ▀   ▀ ▀▀▀▀▀

local ZSH_CONF=${ZDOTDIR:-$HOME/.config/zsh} # ruta base para configuración adicional

# Aliases
for file in $ZSH_CONF/aliases/*.zsh(N); do
    source "$file"
done

# Directorios de funciones (autoload)
fpath=(
    $ZSH_CONF/funcs
    ${fpath[@]}
)

if [[ -d "$ZSH_CONF/funcs" ]]; then
    autoload -Uz $ZSH_CONF/funcs/*(.N:t) # verifica directorio con archivos antes de autoload
fi

eval "$(starship init zsh)" # starship: prompt moderno (config en ~/.config/starship/kasumi.toml)
eval "$(zoxide init zsh)"   # zoxide: navegación 'z' (aprende directorios, requiere pacman -S zoxide)
source <(fzf --zsh)         # fzf: buscador interactivo (Ctrl+R historial, Ctrl+T archivos, Alt+C directorios, requiere pacman -S fzf)

# ──「 Inactivos 」───────────────────────────────────────────
# ▀▀█▀▀ █▄  █ ▄▀▀▀▄ ▄▀▀▀▀ ▀▀█▀▀ ▀▀█▀▀ █   █ ▄▀▀▀▄ ▄▀▀▀▀
#   █   █ ▀▄█ █▀▀▀█ █       █     █    █ █  █   █  ▀▀▀▄
# ▀▀▀▀▀ ▀   ▀ ▀   ▀  ▀▀▀▀   ▀   ▀▀▀▀▀   ▀    ▀▀▀  ▀▀▀▀
# Ajustes inactivos — excluye zstyle (permanecen en su sección)

# Habilitar profiling
# zmodload zsh/zprof

# PEND: resalta en negrita y amarillo las búsquedas con grep
# export GREP_COLORS="mt=1;33"

# export FZF_DEFAULT_OPTS="--layout=reverse" # El prompt se abre desde arriba

# Alt+c: directorio
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
