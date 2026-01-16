#!/usr/bin/env bash
set -euo pipefail

# Print a header line: "= <title> =..." padded to 20 characters total
header() {
  title="$1"
  # title centered within equals signs; second param is total line length
  total=${2:-40}
  title_part=" $title "
  tlen=${#title_part}
  if [ $tlen -ge $total ]; then
    # Too long to pad - just print the title surrounded by single equals
    printf '= %s =\n' "$title"
    return
  fi
  rem=$(( total - tlen ))
  left=$(( rem / 2 ))
  right=$(( rem - left ))
  # Print left equals
  if [ $left -gt 0 ]; then
    printf '=%.0s' $(seq 1 $left)
  fi
  # Print title part
  printf '%s' "$title_part"
  # Print right equals
  if [ $right -gt 0 ]; then
    printf '=%.0s' $(seq 1 $right)
  fi
  printf '\n'
}

# Initialize and verify sibling repositories exist. This moves to the repo root
# (parent of this `scripts` directory) so downstream scripts operate from the
# repository root like the original script did.
DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Workspace directory is the directory above the repository root
DIR_WORKSPACE="$(cd "$DIR_SCRIPT/../.." && pwd)"

# Export commonly used sibling directories for other scripts
export DIR_WEB="$DIR_WORKSPACE/race-times-web"
export DIR_APP="$DIR_WORKSPACE/race-times-app"
export DIR_API="$DIR_WORKSPACE/race-times-api"

header "_init.sh"
echo "- DIR_WORKSPACE=$DIR_WORKSPACE"
echo "- DIR_API=$DIR_API"
echo "- DIR_WEB=$DIR_WEB"
echo "- DIR_APP=$DIR_APP"
echo "- DIR_SCRIPT=$DIR_SCRIPT"
echo

# Check the workspace and repos are set-up correctly
MISSING=()
for d in "$DIR_APP" "$DIR_WEB" "$DIR_API"; do
  if [ ! -d "$d" ]; then
    MISSING+=("$d")
  fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
  echo "🔴 Missing directories:" >&2
  for md in "${MISSING[@]}"; do
    echo "- $md" >&2
  done
  exit 1
fi

# Move to this repository root (race-times-api)
cd "$DIR_API"

return 0 2>/dev/null || exit 0
