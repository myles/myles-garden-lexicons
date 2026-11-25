#!/usr/bin/env bash
# Runs a pinned goat, building it into .bin/ on first use.
#
# goat 0.2.9 can't parse `"type": "space"`; indigo added it on
# 2026-11-24. Build goat against that indigo commit until a goat
# release ships it, then replace this with a plain `go install`.
set -euo pipefail

GOAT_REPO_URL="https://github.com/bluesky-social/goat"
GOAT_REF="beec4d7868e0b221ff81b5d042fee336aa31ec3a"
INDIGO_REF="6017e7ee0a79"

bin_dir="$(cd "$(dirname "$0")/.." && pwd)/.bin"

# The refs are in the file name, so bumping either one triggers a
# rebuild instead of reusing a stale binary.
goat_bin="$bin_dir/goat-${GOAT_REF:0:12}-$INDIGO_REF"

_build_goat() {
  if ! command -v go > /dev/null; then
    echo "error: building goat needs Go: https://go.dev/dl/" >&2
    exit 1
  fi

  local src_dir
  src_dir="$(mktemp -d)"
  trap 'rm -rf "$src_dir"' EXIT

  echo "Building goat ${GOAT_REF:0:12} (indigo $INDIGO_REF)…" >&2
  git clone --quiet "$GOAT_REPO_URL" "$src_dir"
  (
    cd "$src_dir"
    git checkout --quiet "$GOAT_REF"
    go get "github.com/bluesky-social/indigo@$INDIGO_REF"
    go build -o "$goat_bin" .
  )

  # `exec` below skips EXIT traps, so clean up here on success.
  rm -rf "$src_dir"
  trap - EXIT
}

if [ ! -x "$goat_bin" ]; then
  mkdir -p "$bin_dir"
  _build_goat
fi

exec "$goat_bin" "$@"
