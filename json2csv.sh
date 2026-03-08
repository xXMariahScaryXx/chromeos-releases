#!/usr/bin/env bash
set -euo pipefail

input="${1:-}"
output="${2:-${1%.json}.csv}"

[[ -z "$input" ]] && exit 1
[[ -f "$input" ]] || exit 1
command -v jq &>/dev/null || exit 1

{
  echo "device,platform_version,chrome_version,channel,last_modified,url"
  jq -r '
    to_entries[] | .key as $device | .value.images[] |
    [$device, .platform_version, .chrome_version, .channel, (.last_modified | tostring), .url] | @csv
  ' "$input"
} > "$output"
