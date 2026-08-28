# ███████╗███████╗██╗  ██╗███████╗██╗     ██╗
# ╚══███╔╝██╔════╝██║  ██║██╔════╝██║     ██║
#   ███╔╝ ███████╗███████║█████╗  ██║     ██║
#  ███╔╝  ╚════██║██╔══██║██╔══╝  ██║     ██║
# ███████╗███████║██║  ██║███████╗███████╗███████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
# ──「 Zsh Shell 」───────────────────────────────────────────
# Habilitar profiling
# zmodload zsh/zprof

# Configuración inicial de Zinit: instala el gestor si no existe
# y lo deja listo para cargar plugins.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ▄▀▀▀▀ ▄▀▀▀▄ █▀▄▀█ █▀▀▀▄ █     █▀▀▀▀ ▀▀█▀▀ ▀▀█▀▀ ▄▀▀▀▄ █▄  █
# █     █   █ █   █ █▀▀▀  █     █▀▀     █     █   █   █ █ ▀▄█
#  ▀▀▀▀  ▀▀▀  ▀   ▀ ▀     ▀▀▀▀▀ ▀▀▀▀▀   ▀   ▀▀▀▀▀  ▀▀▀  ▀   ▀
# ──「 Completion 」──────────────────────────────────────────

# NOTA: Para revisar las activas, ejecuta: zstyle -L ':completion:*'

# Ajustes de autocompletado nativo (sin fzf-tab)

# Muestra los directorios especiales '.' y '..' en la
# autocompletación de rutas.
# zstyle ':completion:*' special-dirs true

# Agrupa resultados de coincidencias por categoría (comandos,
# archivos, procesos, etc.) para una visualización ordenada.
# zstyle ':completion:*:matches' group 'yes'

# Activa navegación por menú cuando hay múltiples resultados,
# permitiendo desplazarse con las flechas.
# zstyle ':completion:*' menu select

# Muestra descripciones detalladas de cada ítem del completion
# (por ejemplo: "(archivo)", "(directorio)", etc.).
# zstyle ':completion:*' verbose yes

# Define el formato para las descripciones mostradas por Zsh.
# %d se reemplaza por la descripción del grupo.
# zstyle ':completion:*:descriptions' format '-- %d --'

# Usa los colores definidos en LS_COLORS para colorear los
# elementos listados en el menú de completado.
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Completado global
# Desactiva el menú interactivo nativo de zsh.
# Requerido para que fzf-tab intercepte el prefijo unambiguous
# y gestione su propio selector visual.
zstyle ':completion:*' menu no

# Reconstruye el caché de comandos automáticamente.
# Garantiza que comandos recién instalados (apt, pip, npm, etc.)
# estén disponibles sin recargar el shell.
zstyle ':completion:*' rehash true

# Define reglas de coincidencia para el completado:
#   'm:{a-zA-Z}={A-Za-z}'  — comparación case-insensitive
#   'r:|=*'                — completado por prefijo parcial
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' 'r:|=*'

# Proveedor de lista de procesos para kill, killall, renice, etc.
# Incluye PID, usuario, comando y argumentos completos.
zstyle ':completion:*:*:*:*:processes' command \
    'ps -u $USER -o pid,user,comm,cmd -w -w'

# Desactiva el orden alfabético en git checkout.
# Las ramas respetan el orden cronológico devuelto por git
# (más recientes primero).
zstyle ':completion:*:git-checkout:*' sort false

# Formato de los encabezados de grupo en el menú de completado.
# Requerido para que fzf-tab exponga la variable $group
# en las expresiones de vista previa.
zstyle ':completion:*:descriptions' format '󰩗  %d'

# Fzf-tab — comportamiento global
# Habilita la lectura de FZF_DEFAULT_OPTS del entorno.
# Nota: si FZF_DEFAULT_OPTS contiene --tmux, fzf-tab falla
# (issue #455). En ese caso debe establecerse a no.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Banderas adicionales para la invocación interna de fzf.
zstyle ':fzf-tab:*' fzf-flags \
    --height=40%

# Controla la visualización de encabezados de grupo:
#   full  — siempre visibles (default)
#   brief — solo si hay miembros duplicados entre grupos
#   none  — ocultos, $group se establece a __hide__
#   quiet — ocultos, $group conserva su valor original
zstyle ':fzf-tab:*' show-group full

# Colores ANSI 256 asignados cíclicamente a los encabezados
# de grupo. Cuatro valores definidos; al agotarse se reinician.
zstyle ':fzf-tab:*' group-colors \
    $'\033[38;5;248m' $'\033[38;5;152m' $'\033[38;5;134m' $'\033[38;5;140m'

# Teclas de navegación entre grupos activos.
# Valores por defecto: F1 y F2. Se redefine a '<' y '>'.
zstyle ':fzf-tab:*' switch-group '<' '>'

# Variables internas - referencia
# $word     Valor que se inserta en la línea de comandos
# $desc     Texto visible en fzf (incluye descripción)
# $group    Categoría del candidato (ej: "[option]", "[filename]")
# $realpath Ruta absoluta (solo en candidatos tipo archivo/directorio)
# $words    Estado actual de la línea de comandos

# Fzf-tab — vistas previas personalizadas
# Vista previa para cd: árbol de directorios con eza.
# Opciones: solo directorios, profundidad 2, sin colores.
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level=2 --color=never --only-dirs $realpath'

# Vista previa para git show: diff completo procesado por delta.
# fzf-tab pasa automáticamente --ansi a fzf para preservar colores.
zstyle ':fzf-tab:complete:git-show:*' \
    fzf-preview 'git show --color=always "$word" | delta'

# TERM: habilita previsualización de imágenes en Ranger según terminal
if [[ -n "$KITTY_WINDOW_ID" ]] && [[ -z "$TMUX" ]]; then
    export TERM="xterm-kitty"
    alias ssh='kitty +kitten ssh'
else
    export TERM="xterm-256color"
fi

# ▄▀▀▀▀ █▀▀▀▀ ▀▀█▀▀ ▀▀█▀▀ ▀▀█▀▀ █▄  █ ▄▀▀▀▀ ▄▀▀▀▀
#  ▀▀▀▄ █▀▀     █     █     █   █ ▀▄█ █ ▀▀█  ▀▀▀▄
# ▀▀▀▀  ▀▀▀▀▀   ▀     ▀   ▀▀▀▀▀ ▀   ▀  ▀▀▀  ▀▀▀▀
# ──「 Settings 」────────────────────────────────────────────
# VARIABLES DE ENTORNO

export RANGER_LOAD_DEFAULT_RC=FALSE # desactiva rc.conf predeterminado de ranger

export EDITOR="nvim" # editor por defecto (terminal/GUI)
export VISUAL="nvim" # idem

export STARSHIP_CONFIG=~/.config/starship/kasumi.toml # configuración starship
TRANSIENT_PROMPT_TRANSIENT_PROMPT=' '                 # prompt transitorio vacío

# ──「 Colors 」──────────────────────────────────────────────
# ▄▀▀▀▀ ▄▀▀▀▄ █     ▄▀▀▀▄ █▀▀▀▄ ▄▀▀▀▀
# █     █   █ █     █   █ █▀▀▀▄  ▀▀▀▄
#  ▀▀▀▀  ▀▀▀  ▀▀▀▀▀  ▀▀▀  ▀   ▀ ▀▀▀▀

export BAT_STYLE="full"   # bat: listado completo
export BAT_THEME="base16" # tema compatible con kitty

export LS_COLORS="$(vivid generate kasumi)" # requiere vivid

# PEND: resalta en negrita y amarillo las búsquedas con grep
# export GREP_COLORS="mt=1;33"

# Requiere: source-highlight
export LESSOPEN="| src-hilite-lesspipe.sh %s"

export LESS='-MRFI' # -M prompt, -F quit-if-one-screen, -R ANSI, -I ignore-case

# Colores para man
# Define el paginador para man (MANPAGER) usando less con:
# - Soporte completo para colores/ANSI (-R + --use-color)
# - Prompt más legible y con info (-M)
# - Compresión de líneas en blanco (-s)
# - Carga total del documento al abrir (+Gg) → scroll suave y porcentaje exacto desde el inicio
export MANPAGER='less -M +Gg -R --use-color'

# Asegura que groff use SGR (necesario para -R)
export MANROFFOPT='-c'

# Personalización de atributos visuales para man pages (LESS_TERMCAP_*)
# Se usan capacidades terminfo vía tput para máxima portabilidad (evita secuencias ANSI hardcoded)
# Cada variable define qué secuencia aplicar cuando less encuentra ese atributo en la página
#   mb (begin blink) -> raramente usado en man; se reutiliza como énfasis visual (amarillo + bold)
#   md (begin bold) -> títulos/encabezados y elementos destacados (cyan + bold)
#   me (end mode) -> reset completo de atributos (estado base)
#   se (end standout) -> fin de modo standout (reset)
#   so (standout) -> coincidencias de búsqueda y resaltado (amarillo + bold para contraste)
#   ue (end underline) -> desactiva subrayado; se refuerza con reset para evitar artefactos
#   us (begin underline) -> subrayado (común en flags/opciones; verde como convención visual)

export LESS_TERMCAP_mb=$(
    tput bold
    tput setaf 3
)
export LESS_TERMCAP_md=$(
    tput bold
    tput setaf 6
)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS_TERMCAP_so=$(
    tput bold
    tput setaf 3
)
export LESS_TERMCAP_ue=$(
    tput rmul
    tput sgr0
)
export LESS_TERMCAP_us=$(
    tput smul
    tput setaf 2
)

# ──「 Fzf 」─────────────────────────────────────────────────
# █▀▀▀▀ ▀▀▀▀█ █▀▀▀▀
# █▀▀   ▄▀▀▀  █▀▀
# ▀     ▀▀▀▀▀ ▀
# Opciones generales de fzf — generador de temas: https://vitormv.github.io/fzf-themes/
# FZF_FD_BASE usa fd por rendimiento frente a find
# (--type f archivos, --hidden incluye ocultos, --follow sigue enlaces)
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

# Parámetros globales de fzf: controlan colores,
# diseño y comportamiento por defecto
# export FZF_DEFAULT_OPTS="--layout=reverse" # El prompt se abre desde arriba
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

# Ctrl+r -> busqueda en historial
export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS
--bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'"

# Alt+c -> cambio de directorio
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Ctrl+t -> búsqueda de archivos
# export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_CTRL_T_COMMAND="fd --type f ${FZF_FD_OPTS[@]}"

# ──「 History 」─────────────────────────────────────────────
# █   █ ▀▀█▀▀ ▄▀▀▀▀ ▀▀█▀▀ ▄▀▀▀▄ █▀▀▀▄ █   █
# █▀▀▀█   █    ▀▀▀▄   █   █   █ █▀▀▀▄ ▀▀▀▀█
# ▀   ▀ ▀▀▀▀▀ ▀▀▀▀    ▀    ▀▀▀  ▀   ▀ ▀▀▀▀▀
# Opciones: ver `set -o` — https://zsh.sourceforge.io/Doc/Release/Options.html

PROMPT_EOL_MARK="🐙" # marca EOL del prompt
# Historial persistente en XDG_STATE_HOME (no en cache: lo de cache se puede borrar sin avisar)
# Ruta por defecto ~/.local/state/zsh/history; fallback asegura que funcione aunque XDG_STATE_HOME no esté exportado
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}" # asegura directorio existe (idempotente)
# Si hay historial antiguo en la ubicación previa de cache y aún no existe en state, migrarlo para no aparentar pérdida
if [[ -f "$HOME/.cache/zsh_history" && ! -f "$HISTFILE" ]]; then
    mv -- "$HOME/.cache/zsh_history" "$HISTFILE"
fi
HISTSIZE=30000                # Comandos que se mantienen en memoria
SAVEHIST=30000                # Comandos que se guardan en disco
setopt APPEND_HISTORY         # Permite que múltiples sesiones de terminal agreguen comandos al historial en lugar de sobrescribirlo.
setopt BANG_HIST              # Permite tratar el carácter '!' de manera especial durante la expansión de comandos.
setopt COMPLETE_ALIASES       # Activa la auto completado para alias.
setopt EXTENDED_HISTORY       # Registra la marca de tiempo de cada comando en el archivo de historial en el formato ":inicio:transcurrido;comando".
setopt HIST_ALLOW_CLOBBER     # Permite que las referencias al historial sobrescriban archivos, incluso cuando CLOBBER está desactivado.
setopt HIST_BEEP              # Emite un pitido cuando se accede a un historial inexistente.
setopt HIST_EXPIRE_DUPS_FIRST # Elimina comandos duplicados cuando se alcanza el límite de $HISTSIZE.
setopt HIST_FIND_NO_DUPS      # Evita encontrar comandos duplicados durante la búsqueda en el historial.
setopt HIST_IGNORE_ALL_DUPS   # Elimina una entrada anterior en el historial si la nueva es un duplicado.
setopt HIST_IGNORE_DUPS       # Ignora comandos duplicados en la lista del historial.
setopt HIST_IGNORE_SPACE      # Ignora comandos que comienzan con un espacio.
setopt HIST_NO_STORE          # No almacena el comando `fc -l` en el historial.
setopt HIST_REDUCE_BLANKS     # Elimina espacios adicionales de cada línea de comando antes de agregarla al historial.
setopt HIST_SAVE_NO_DUPS      # Ignora duplicados al guardar el historial en el archivo.
setopt HIST_VERIFY            # Muestra el comando antes de ejecutarlo si se selecciona del historial.
setopt INC_APPEND_HISTORY     # Escribe en el archivo de historial de inmediato, no solo cuando la shell termina.
setopt NO_HIST_NO_FUNCTIONS   # No elimina definiciones de funciones del historial.
setopt RM_STAR_WAIT           # Espera 10 segundos antes de ejecutar `rm` con un asterisco (*).
setopt SHARE_HISTORY          # Comparte el historial entre todas las sesiones de terminal.

# Filtra historial: solo almacena comandos existentes y no coincidentes con HISTORY_IGNORE
HISTORY_IGNORE="* --help|clear|exa|exit|ls|lsd|man *|pwd|q|ranger|yt-mp3"

# Hook: decide qué comandos guardar en historial
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
# Fast Zshell Plugin Manager

# Proporciona definiciones adicionales de completado
# para cientos de comandos y utilidades externas que Zsh no incluye por defecto.
# Utiliza  zicompinit + zicdreplay: helper oficial de Zinit para Turbo mode.
zinit ice wait'0' lucid blockf atload'zicompinit; zicdreplay'
zinit light zsh-users/zsh-completions

zinit ice wait'0' lucid blockf # interfaz avanzada para autocompletado con fzf
zinit light Aloxaf/fzf-tab

# Muestra sugerencias basadas en el historial mientras se escribe,
# permitiendo completar con la flecha derecha.
# Inicia automáticamente tras la carga del plugin.
zinit ice wait'0' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Colorea la sintaxis de los comandos a medida que se escriben.
# Carga al final para no interferir con completados
# ni con las sugerencias de autosugestión.
zinit ice wait'0' lucid
zinit light zsh-users/zsh-syntax-highlighting

# Forgit: interfaz interactiva para Git basada en fzf
# https://github.com/wfxr/forgit#full-command-list
# Atajos de ejemplo:
#   glo  -> historial de commits (log interactivo)
#   gd   -> diff interactivo
zinit ice wait'1' lucid
zinit light wfxr/forgit

zinit ice wait'0' lucid # transient prompt: limpia líneas previas
zinit light olets/zsh-transient-prompt

# Configuración personal
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

eval "$(zoxide init zsh)" # zoxide: navegación 'z' (aprende directorios, requiere pacman -S zoxide)

source <(fzf --zsh) # fzf: buscador interactivo (Ctrl+R historial, Ctrl+T archivos, Alt+C directorios, requiere pacman -S fzf)

eval "$(starship init zsh)" # starship: prompt moderno (config en ~/.config/starship/kasumi.toml)
