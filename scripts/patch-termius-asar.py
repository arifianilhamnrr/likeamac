#!/usr/bin/env python3
"""Patch Termius app.asar for native window frame on Linux (Electron 21)."""

from __future__ import annotations

import sys
from pathlib import Path

PATCHES: list[tuple[bytes, bytes, str]] = [
    (
        b'n.platform==="linux"&&(p.icon=Es)',
        b'n.platform==="linux"&&(p.frame=1)',
        "enable native frame on Linux",
    ),
    (
        b'backgroundColor:this.type==="primary"?"transparent":"#101021",frame:!1,transparent:!1',
        b'backgroundColor:this.type==="primary"?"transparent":"#101021",frame:!0,transparent:!1',
        "enable frame in BrowserWindow defaults",
    ),
    (
        b'{actionType:"disabled",buttonCallbacks:{onClick:or,onFocus:ir}},{actionType:"maximize",buttonCallbacks:{onClick:sr,onFocus:ir}},{actionType:"none_"',
        b'{actionType:"disabled",buttonCallbacks:{onClick:or,onFocus:ir}},{actionType:"disabled",buttonCallbacks:{onClick:sr,onFocus:ir}},{actionType:"none_"',
        "hide custom maximize button",
    ),
]

# Unique marker for --check (frame enabled in BrowserWindow defaults).
MARKER = PATCHES[1][1]


def is_patched(path: Path) -> bool:
    return MARKER in path.read_bytes()


def patch(path: Path) -> bool:
    data = path.read_bytes()
    changed = False

    for old, new, label in PATCHES:
        if new in data:
            continue
        count = data.count(old)
        if count != 1:
            raise SystemExit(f"expected exactly 1 patch site for {label}, found {count}")
        data = data.replace(old, new, 1)
        changed = True

    if changed:
        path.write_bytes(data)
    return changed


def main() -> int:
    if len(sys.argv) == 3 and sys.argv[1] == "--check":
        return 0 if is_patched(Path(sys.argv[2])) else 1
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} [--check] <app.asar>", file=sys.stderr)
        return 2

    path = Path(sys.argv[1])
    if is_patched(path):
        print("Termius app.asar already patched")
        return 0

    if patch(path):
        print("patched Termius app.asar for native Linux window frame")
    else:
        print("Termius app.asar already patched")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())