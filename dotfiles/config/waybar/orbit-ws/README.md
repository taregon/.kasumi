# orbit-ws

Indicador event-driven de workspaces para Waybar y Sway. Lee el estado por IPC
de sway y emite JSON para el módulo `custom/workspaces`.

Repositorio canónico: https://github.com/taregon/orbit-ws

## Contenido

Mínimo necesario para compilar sin el repositorio: manifiesto, fuente único (sin
módulos ni assets) y configuración.

- `Cargo.toml` — manifiesto del crate.
- `src/main.rs` — fuente único.
- `workspaces.toml` — configuración (colores, iconos, formato, tooltip).

## Compilación en máquina limpia

Requiere toolchain Rust (`rustup` con canal estable).

```bash
cd ~/.config/waybar/orbit-ws
cargo build --release
install -m755 target/release/orbit-ws ~/.local/bin/orbit-ws
rm -rf target Cargo.lock
```

`rm -rf target Cargo.lock` evita dejar artefactos de compilación en la
configuración desplegada (`Cargo.lock` se regenera en cada build).

## Despliegue

```bash
dotdrop install -p kasumi   # enlaza workspaces.toml en ~/.config/waybar/orbit-ws/
swaymsg reload              # recarga waybar con el nuevo exec
```

Waybar ejecuta `orbit-ws ~/.config/waybar/orbit-ws/workspaces.toml` (ver
`custom/workspaces` en `../config.jsonc`).

## Sincronización con el repositorio

Los ajustes se desarrollan en el repositorio canónico. Tras compilar OK ahí,
copiar `Cargo.toml` y `src/main.rs` a este directorio para mantener el espejo al
día. Dirección única: repositorio → espejo.
