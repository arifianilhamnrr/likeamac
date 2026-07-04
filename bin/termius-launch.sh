#!/usr/bin/env bash
set -euo pipefail

RUNTIME="${XDG_CONFIG_HOME}/termius-runtime"
SOURCE="/app/extra/termius"
PATCH_SCRIPT="${XDG_CONFIG_HOME}/patch-termius-asar.py"
STAMP="${RUNTIME}/.patch-version"
PATCH_ID="linux-frame-v1"

if [[ ! -x "${RUNTIME}/termius-app" ]] || [[ ! -f "${STAMP}" ]] || [[ "$(cat "${STAMP}")" != "${PATCH_ID}" ]]; then
    rm -rf "${RUNTIME}"
    cp -a "${SOURCE}" "${RUNTIME}"
    python3 "${PATCH_SCRIPT}" "${RUNTIME}/resources/app.asar"
    echo "${PATCH_ID}" > "${STAMP}"
fi

exec /app/bin/zypak-wrapper.sh "${RUNTIME}/termius-app" "$@"