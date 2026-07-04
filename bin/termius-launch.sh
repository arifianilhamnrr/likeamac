#!/usr/bin/env bash
# Runs inside the Termius flatpak sandbox.
set -euo pipefail

exec /app/bin/zypak-wrapper.sh /app/extra/termius/termius-app "$@"