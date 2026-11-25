# Shared helpers. Source, don't run.

# Prints an error for a file. Under GitHub Actions it's also an
# annotation, so it shows inline on the PR.
report_error() {
  local file="$1"
  local message="$2"

  if [ -n "${GITHUB_ACTIONS:-}" ]; then
    echo "::error file=$file::$message"
    return
  fi

  echo "error: $file: $message" >&2
}
