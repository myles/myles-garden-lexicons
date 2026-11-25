#!/usr/bin/env bash
# Tests for check-ids.sh, against throwaway lexicon trees.
set -euo pipefail

check_ids="$(cd "$(dirname "$0")" && pwd)/check-ids.sh"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

failures=0

# Writes a lexicon at <dir>/garden/<path> declaring <id>.
_write_lexicon() {
  local dir="$1"
  local path="$2"
  local id="$3"

  mkdir -p "$(dirname "$dir/garden/$path")"
  echo "{\"lexicon\": 1, \"id\": \"$id\"}" > "$dir/garden/$path"
}

# Runs check-ids.sh on <dir>/garden and compares its exit code.
_expect_exit() {
  local name="$1"
  local dir="$2"
  local expected="$3"
  local actual=0

  "$check_ids" "$dir/garden" > /dev/null 2>&1 || actual=$?

  if [ "$actual" -ne "$expected" ]; then
    echo "FAIL: $name: exit $actual, expected $expected"
    failures=$((failures + 1))
    return
  fi

  echo "ok: $name"
}

_write_lexicon "$tmp_dir/good" "a/b/c.json" "garden.a.b.c"
_expect_exit "matching id passes" "$tmp_dir/good" 0

_write_lexicon "$tmp_dir/bad" "a/b/c.json" "garden.a.b.wrong"
_expect_exit "mismatched id fails" "$tmp_dir/bad" 1

_write_lexicon "$tmp_dir/mixed" "a/b/c.json" "garden.a.b.c"
_write_lexicon "$tmp_dir/mixed" "a/b/d.json" "garden.a.b.c"
_expect_exit "one bad file among good ones fails" "$tmp_dir/mixed" 1

# Unset GITHUB_ACTIONS so the local message format is what's checked.
_write_lexicon "$tmp_dir/message" "x/y.json" "garden.x.z"
message="$(
  env -u GITHUB_ACTIONS "$check_ids" "$tmp_dir/message/garden" 2>&1 \
    || true
)"
expected="error: garden/x/y.json: id is 'garden.x.z', expected 'garden.x.y'"
if [ "$message" != "$expected" ]; then
  echo "FAIL: error message: got '$message'"
  failures=$((failures + 1))
else
  echo "ok: error message"
fi

if [ "$failures" -gt 0 ]; then
  exit 1
fi
