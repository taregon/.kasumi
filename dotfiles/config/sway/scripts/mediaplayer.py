#!/usr/bin/env python3
# Emisor de estado de reproduccion multimedia para Waybar.
# Consume players MPRIS via Playerctl y emite JSON con informacion del track
# en reproduccion. Disenado para entornos PipeWire/WirePlumber sobre Wayland.

import argparse
import html
import json
import logging
import signal
import sys
from dataclasses import dataclass

import gi

gi.require_version("Playerctl", "2.0")
from gi.repository import GLib, Playerctl  # type: ignore

logger = logging.getLogger(__name__)

# ── Data models ────────────────────────────────────────────────

@dataclass
class TrackInfo:
    """Structured representation of current track metadata."""

    text: str = ""
    artist: str = ""
    title: str = ""
    album: str = ""
    player: str = ""
    status: str = "Stopped"
    is_ad: bool = False

    @property
    def tooltip(self) -> str:
        parts = []
        if self.artist and self.title:
            parts.append(f"{self.artist} - {self.title}")
        elif self.title:
            parts.append(self.title)
        if self.album:
            parts.append(self.album)
        return " \n".join(parts) if parts else ""

    def to_waybar(self) -> dict:
        status_icon = " " if self.status == "Playing" else "⏸ "
        display_text = f"{status_icon}{self.text}" if self.text else ""

        # Escapar caracteres especiales para Pango markup en Waybar
        safe_text = html.escape(display_text) if display_text else ""
        safe_tooltip = html.escape(self.tooltip) if self.tooltip else ""

        result = {
            "text": safe_text,
            "class": f"custom-{self.player}" if self.player else "custom-mediaplayer",
            "alt": self.player or "mediaplayer",
            "tooltip": safe_tooltip,
        }

        if self.is_ad:
            result["text"] = "  AD PLAYING"
            result["tooltip"] = "Advertisement in progress"

        return result

# ── Player monitor ─────────────────────────────────────────────

class MediaPlayerMonitor:
    """Monitors MPRIS players and emits JSON status to stdout."""

    def __init__(self, player_filter: str | None = None):
        self.player_filter = player_filter
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()

        self.manager.connect("name-appeared", self._on_player_appeared)
        self.manager.connect("player-vanished", self._on_player_vanished)

        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)

    def start(self) -> None:
        """Initialize existing players and run the event loop."""
        for player_name in self.manager.props.player_names:
            if self.player_filter and player_name.name != self.player_filter:
                logger.debug(
                    "Skipping %s (filter: %s)", player_name.name, self.player_filter
                )
                continue
            self._init_player(player_name)

        logger.info(
            "Monitoring players%s",
            f" (filter: {self.player_filter})" if self.player_filter else "",
        )
        self.loop.run()

    def _init_player(self, player_name: Playerctl.PlayerName) -> None:
        logger.debug("Initializing player: %s", player_name.name)
        player = Playerctl.Player.new_from_name(player_name)
        player.connect("playback-status", self._on_playback_status)
        player.connect("metadata", self._on_metadata)
        self.manager.manage_player(player)
        self._emit_status(player)

    def _on_player_appeared(
        self, _manager: Playerctl.PlayerManager, player_name: Playerctl.PlayerName
    ) -> None:
        if self.player_filter and player_name.name != self.player_filter:
            logger.debug("New player %s ignored (filter active)", player_name.name)
            return
        self._init_player(player_name)

    def _on_player_vanished(
        self, _manager: Playerctl.PlayerManager, player: Playerctl.Player
    ) -> None:
        logger.info("Player vanished: %s", player.props.player_name)
        self._write_output(TrackInfo())

    def _on_playback_status(self, player: Playerctl.Player, status: str) -> None:
        logger.debug(
            "Playback status changed: %s -> %s", player.props.player_name, status
        )
        self._emit_status(player)

    def _on_metadata(self, player: Playerctl.Player, _metadata: dict) -> None:
        logger.debug("Metadata changed: %s", player.props.player_name)
        self._emit_status(player)

    def _emit_status(self, player: Playerctl.Player) -> None:
        track = self._build_track_info(player)
        self._write_output(track)

    def _build_track_info(self, player: Playerctl.Player) -> TrackInfo:
        metadata = player.props.metadata or {}
        player_name = player.props.player_name or "unknown"
        status = player.props.status or "Stopped"

        # Detect Spotify ads via mpris:trackid
        if player_name == "spotify" and "mpris:trackid" in metadata.keys():
            track_id = metadata.get("mpris:trackid", "")
            if ":ad:" in track_id:
                return TrackInfo(player=player_name, status=status, is_ad=True)

        artist = ""
        title = ""
        album = ""

        try:
            artist = player.get_artist() or ""
        except GLib.GError:
            pass

        try:
            title = player.get_title() or ""
        except GLib.GError:
            pass

        try:
            album = player.get_album() or ""
        except GLib.GError:
            pass

        # Build display text
        if artist and title:
            text = f"{artist} - {title}"
        elif title:
            text = title
        else:
            text = ""

        return TrackInfo(
            text=text,
            artist=artist,
            title=title,
            album=album,
            player=player_name,
            status=status,
        )

    def _write_output(self, track: TrackInfo) -> None:
        output = track.to_waybar()
        line = json.dumps(output, ensure_ascii=False)
        logger.info("Output: %s", line)
        sys.stdout.write(line + "\n")
        sys.stdout.flush()

    def _signal_handler(self, sig: int, _frame: object) -> None:
        logger.debug("Received signal %s, exiting", sig)
        self._write_output(TrackInfo())
        self.loop.quit()

# ── CLI ────────────────────────────────────────────────────────

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Media player status emitter for Waybar",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Increase verbosity (repeat for more)",
    )
    parser.add_argument(
        "--player",
        type=str,
        default=None,
        help="Filter by player name (e.g. spotify, firefox)",
    )
    return parser.parse_args()

# ── Entry point ────────────────────────────────────────────────

def main() -> None:
    args = parse_args()

    logging.basicConfig(
        stream=sys.stderr,
        format="%(name)s %(levelname)s %(message)s",
    )
    log_level = max((3 - args.verbose) * 10, 0)
    logger.setLevel(log_level)

    logger.debug("Arguments: %s", vars(args))

    monitor = MediaPlayerMonitor(player_filter=args.player)
    monitor.start()

if __name__ == "__main__":
    main()
