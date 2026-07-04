#!/usr/bin/env python3
"""Enable native GTK frame (traffic lights) for Termius on Linux."""

from __future__ import annotations

import sys
from pathlib import Path

OLD = b'n.platform==="linux"&&(p.icon=Es)'
NEW = b'n.platform==="linux"&&(p.frame=1)'


def patch(path: Path) -> bool:
    data = path.read_bytes()
    count = data.count(OLD)
    if count != 1:
        raise SystemExit(f"expected exactly 1 patch site in {path}, found {count}")
    path.write_bytes(data.replace(OLD, NEW, 1))
    return True


def main() -> int:
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <app.asar>", file=sys.stderr)
        return 2
    patch(Path(sys.argv[1]))
    print("patched Termius app.asar for native Linux frame")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())