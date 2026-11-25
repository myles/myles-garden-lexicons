#!/usr/bin/env bash
# Checks each lexicon's `id` matches its path, so
# garden/myles/aster/chart.json declares garden.myles.aster.chart.
#
# Usage: scripts/check-ids.sh [lexicons-dir]   (default: garden)
set -euo pipefail

source "$(dirname "$0")/lib.sh"

lexicons_dir="${1:-garden}"

# Ids include the top-level directory name, so walk from its parent.
cd "$(dirname "$lexicons_dir")"
root="$(basename "$lexicons_dir")"

status=0
while IFS= read -r -d '' file; do
  expected="$(echo "${file%.json}" | tr / .)"
  actual="$(jq -r .id "$file")"

  if [ "$actual" != "$expected" ]; then
    report_error "$file" "id is '$actual', expected '$expected'"
    status=1
  fi
done < <(find "$root" -name '*.json' -print0)

exit $status
