#!/bin/sh
# GitHub Release から nullpointerpunch をダウンロードして apt install する
set -eu

REPO="GoldenPoisonedApple/NullPointerExceptionPunch"
PKG="nullpointerpunch"

usage() {
    cat <<EOF
Usage: install.sh [VERSION]

  VERSION  インストールするバージョン (例: 1.0.0, v1.0.0)
           省略時は GitHub の最新 Release を使用

Examples:
  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/scripts/install.sh | sh
  curl -fsSL ... | sh -s -- 1.0.0
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "install.sh: curl が必要です" >&2
    exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "install.sh: apt が必要です (Debian/Ubuntu)" >&2
    exit 1
fi

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    VERSION=$(
        curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
            | grep '"tag_name":' \
            | sed -E 's/.*"tag_name": "v([^"]+)".*/\1/'
    )
fi

# v1.0.0 → 1.0.0
VERSION=$(echo "$VERSION" | sed 's/^v//')

DEB="${PKG}_${VERSION}_all.deb"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${DEB}"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Downloading ${URL} ..."
curl -fsSL -o "${tmpdir}/${DEB}" "${URL}"

echo "Installing ${PKG} ${VERSION} ..."
sudo apt install -y "${tmpdir}/${DEB}"

echo "Installed. Try: ぬるぽ"
