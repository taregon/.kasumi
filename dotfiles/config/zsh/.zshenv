# ╒══════════════════════════════════════════════════════════╕
# │                     ZSHENV - ZDOTDIR                     │
# ╘══════════════════════════════════════════════════════════╛
# Propósito: env principal leído cuando ZDOTDIR está exportado
# (toda invocación con ZDOTDIR heredado: hijos, login vía ly, systemd).
# Precedencia: aquí se ajustan PATH y SSH_AUTH_SOCK;
# tiene prioridad sobre bootstrap para env no interactivo.
# No re-exportar ZDOTDIR (ya seteado por ~/.zshenv).
# ly: ZDOTDIR hereda vía ly→sway (proc); XDG_STATE_HOME no en sway environ.
# /etc/ly/setup.sh:28 re-exec zsh → ~/.zshenv (ZDOTDIR) antes, luego $ZDOTDIR/.zprofile.
# Cada zsh hijo re-sourcea ZDOTDIR/.zshenv; systemctl --user show-environment no lo refleja.

# ──「 Xdg State 」───────────────────────────────────────────
# State persistente no portable (historial, logs) — spec 0.8 https://specifications.freedesktop.org/basedir/latest/
# Default ~/.local/state si no exportada; idempotente via :-
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
[[ -d "$XDG_STATE_HOME" ]] || mkdir -p -m 0700 "$XDG_STATE_HOME"

# ──「 Xdg Data 」────────────────────────────────────────────
# Datos persistentes (plugins, assets) — spec 0.8 https://specifications.freedesktop.org/basedir/latest/
# Default ~/.local/share si no exportada; idempotente via :-
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
[[ -d "$XDG_DATA_HOME" ]] || mkdir -p -m 0700 "$XDG_DATA_HOME"

# ──「 Ssh Agent 」───────────────────────────────────────────
# Permite usar claves SSH sin pedir passphrase cada vez
# El socket se crea automáticamente en $XDG_RUNTIME_DIR/ssh-agent.socket
# Requisito systemd: systemctl --user enable --now ssh-agent
# Guarda XDG_RUNTIME_DIR evita ruta inválida en cron/TTY pre-login
if [[ -z "$SSH_AUTH_SOCK" && -n "$XDG_RUNTIME_DIR" ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi

# ──「 Path 」────────────────────────────────────────────────
# Helpers y tooling personal reutilizable
# Facilita pruebas, automatización y ejecución sin rutas largas
typeset -U path PATH

path=(
    "$HOME/.local/bin"
    "$HOME/.local/bin/kasumi/helpers"
    $path
)
