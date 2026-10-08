# ╒══════════════════════════════════════════════════════════╕
# │                          ZLOGIN                          │
# ╘══════════════════════════════════════════════════════════╛
# Se lee después de .zshrc solo en login shell (ly, ssh, zsh -l).
# Aquí van tareas una vez por sesión, no en cada subshell.

if [[ -o interactive ]]; then
    fastfetch
fi
