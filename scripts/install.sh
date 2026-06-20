#!/bin/sh
# GitHub Release から nullpointerpunch をダウンロードして apt install する
set -eu

REPO="GoldenPoisonedApple/NullPointerExceptionPunch"
PKG="nullpointerpunch"
LATEST_URL="https://github.com/${REPO}/releases/latest/download/nullpointerpunch_all.deb"

usage() {
    cat <<EOF
Usage: install.sh [VERSION]

  VERSION  インストールするバージョン (例: 1.0.0, v1.0.0)
           省略時は最新 Release を使用

Examples:
  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/scripts/install.sh | sh
  curl -fsSL ... | sh -s -- 1.0.0
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "install.sh: apt が必要です (Debian/Ubuntu)" >&2
    exit 1
fi

download() {
    url=$1
    dest=$2
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL -o "$dest" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$dest" "$url"
    else
        echo "install.sh: curl または wget が必要です" >&2
        exit 1
    fi
}

VERSION="${1:-}"
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

if [ -z "$VERSION" ]; then
    DEB="${PKG}_all.deb"
    URL="$LATEST_URL"
else
    VERSION=$(echo "$VERSION" | sed 's/^v//')
    DEB="${PKG}_${VERSION}_all.deb"
    URL="https://github.com/${REPO}/releases/download/v${VERSION}/${DEB}"
fi

echo "Downloading ${URL} ..."
download "$URL" "${tmpdir}/${DEB}"

echo "Installing ${PKG} ..."
sudo apt install -y "${tmpdir}/${DEB}"

echo "Installed. Try: ぬるぽ"
