#!/usr/bin/env bash

set -euo pipefail

# Server configuration. These can also be overridden with environment variables.
REMOTE_USER="${REMOTE_USER:-luffy}"
REMOTE_HOST="${REMOTE_HOST:-ssh.mengyunyi.top}"
REMOTE_PORT="${REMOTE_PORT:-22}"
REMOTE_WEB_DIR="${REMOTE_WEB_DIR:-/vol1/1003/server/www/html}"

# Build configuration.
BUILD_DIR="${BUILD_DIR:-dist}"
INSTALL_CMD="${INSTALL_CMD:-npm install}"
BUILD_CMD="${BUILD_CMD:-npm run build}"
RSYNC_OPTS="${RSYNC_OPTS:---archive --verbose --compress --delete}"
DEPLOY_TRANSPORT="${DEPLOY_TRANSPORT:-auto}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Missing required command: $1" >&2
        exit 1
    fi
}

require_cmd npm
require_cmd ssh
require_cmd tar

if [ "${DEPLOY_TRANSPORT}" = "rsync" ] || [ "${DEPLOY_TRANSPORT}" = "auto" ]; then
    require_cmd rsync
fi

remote_ssh() {
    ssh -p "${REMOTE_PORT}" \
        -o TCPKeepAlive=yes \
        -o ServerAliveInterval=60 \
        -o ConnectTimeout=10 \
        "${REMOTE_USER}@${REMOTE_HOST}" \
        "$@"
}

deploy_with_rsync() {
    echo "Syncing ${BUILD_DIR}/ to ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_WEB_DIR} via rsync"
    rsync ${RSYNC_OPTS} \
        -e "ssh -p ${REMOTE_PORT} -o TCPKeepAlive=yes -o ServerAliveInterval=60 -o ConnectTimeout=10" \
        "${BUILD_DIR}/" \
        "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_WEB_DIR}/"
}

deploy_with_tar() {
    echo "Syncing ${BUILD_DIR}/ to ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_WEB_DIR} via tar over ssh"
    remote_ssh "mkdir -p \"${REMOTE_WEB_DIR}\" && find \"${REMOTE_WEB_DIR}\" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +"
    tar -czf - -C "${BUILD_DIR}" . | remote_ssh "tar -xzf - -C \"${REMOTE_WEB_DIR}\""
}

echo "Deploy root: ${SCRIPT_DIR}"
cd "${SCRIPT_DIR}"

echo "Installing dependencies..."
eval "${INSTALL_CMD}"

echo "Building project..."
eval "${BUILD_CMD}"

if [ ! -d "${BUILD_DIR}" ]; then
    echo "Build output not found: ${BUILD_DIR}" >&2
    exit 1
fi

echo "Ensuring remote directory exists: ${REMOTE_WEB_DIR}"
remote_ssh "mkdir -p \"${REMOTE_WEB_DIR}\""

case "${DEPLOY_TRANSPORT}" in
    rsync)
        deploy_with_rsync
        ;;
    tar)
        deploy_with_tar
        ;;
    auto)
        if ! deploy_with_rsync; then
            echo "rsync failed, falling back to tar over ssh..."
            deploy_with_tar
        fi
        ;;
    *)
        echo "Unsupported DEPLOY_TRANSPORT: ${DEPLOY_TRANSPORT}" >&2
        exit 1
        ;;
esac

echo "Deployment complete."
