#!/usr/bin/env python3
"""Enable native GTK frame (traffic lights) for Termius on Linux."""

from __future__ import annotations

import sys
from pathlib import Path

OLD = b'n.platform==="linux"&&(p.icon=Es)'
NEW = b'n.platform==="linux"&&(p.frame=1)'


def is_patched(path: Path) -> bool:
    return NEW in path.read_bytes()


def patch(path: Path) -> bool:
    data = path.read_bytes()
    if NEW in data:
        return False
    count = data.count(OLD)
    if count != 1:
        raise SystemExit(f"expected exactly 1 patch site in {path}, found {count}")
    path.write_bytes(data.replace(OLD, NEW, 1))
    return True


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
    patch(path)
    print("patched Termius app.asar for native Linux frame")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())