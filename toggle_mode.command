#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: toggle_mode.command debug|dev|prod
EOF
  exit 1
}

if (( $# != 1 )); then
  usage
fi

case "$1" in
  debug)
    mode="debug"
    scale="adaptive"
    ;;
  dev)
    mode="development"
    scale="adaptive"
    ;;
  prod)
    mode="production"
    scale="letterbox"
    ;;
  *)
    usage
    ;;
esac

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
main_file="$repo_root/Solar2D/main.lua"
config_file="$repo_root/Solar2D/config.lua"

PY_MODE="$mode" PY_SCALE="$scale" \
PY_MAIN="$main_file" PY_CONFIG="$config_file" \
python3 <<'PY'
import os
import re
import sys
from pathlib import Path

mode = os.environ["PY_MODE"]
scale = os.environ["PY_SCALE"]
main_path = Path(os.environ["PY_MAIN"])
config_path = Path(os.environ["PY_CONFIG"])

text = main_path.read_text()
mode_pattern = re.compile(r'^(?!\s*--)(?P<prefix>\s*env\.mode\s*=\s*)"[^"]*"', re.MULTILINE)
new_text, count = mode_pattern.subn(lambda m: f'{m.group("prefix")}"{mode}"', text, count=1)
if count != 1:
    sys.exit(f"env.mode assignment not found or ambiguous (found {count})")
main_path.write_text(new_text)

config_text = config_path.read_text()
scale_pattern = re.compile(r'^(?!\s*--)(?P<indent>\s*scale\s*=\s*)"[^"]*"(,?)', re.MULTILINE)
def repl(m):
    indent = m.group("indent")
    comma = m.group(2)
    return f'{indent}"{scale}"{comma}'
new_config_text, scale_count = scale_pattern.subn(repl, config_text, count=1)
if scale_count != 1:
    sys.exit(f"scale assignment not found or ambiguous (found {scale_count})")
config_path.write_text(new_config_text)
PY

printf 'Set env.mode=%s and scale=%s\n' "$mode" "$scale"
