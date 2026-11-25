#!/usr/bin/env bash
# Validates every example record against the lexicons on this branch.
# Refs outside garden/, e.g. community.lexicon.*, resolve over the
# network.
set -euo pipefail

scripts_dir="$(dirname "$0")"
source "$scripts_dir/lib.sh"

status=0
while IFS= read -r -d '' file; do
  if ! "$scripts_dir/goat.sh" lex validate -c garden "$file"; then
    report_error "$file" "doesn't match its lexicon"
    status=1
  fi
done < <(find examples -name '*.json' -print0)

exit $status
