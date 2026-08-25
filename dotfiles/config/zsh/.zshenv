# ╒══════════════════════════════════════════════════════════╕
# │                     ZSHENV - ZDOTDIR                     │
# ╘══════════════════════════════════════════════════════════╛
# Propósito: env principal leído cuando ZDOTDIR está exportado
# (toda invocación con ZDOTDIR heredado: hijos, login vía ly, systemd).
# Precedencia: aquí se ajustan PATH y SSH_AUTH_SOCK;
# tiene prioridad sobre bootstrap para env no interactivo.
# No re-exportar ZDOTDIR (ya seteado por ~/.zshenv).

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
