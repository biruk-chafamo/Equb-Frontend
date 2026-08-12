#!/usr/bin/env bash
#
# Build the web bundle exactly as a deploy would, prove it points at production,
# then serve it with the literal Procfile command so it can be clicked through
# before the build is committed.
#
#   tool/verify_web_build.sh              build, assert, serve on 8080
#   tool/verify_web_build.sh --no-serve   build and assert only
#   tool/verify_web_build.sh --port 8899  serve on another port
#
# Exit codes
#   1  build failed, or an unrecognised argument
#   2  main.dart.js missing after a successful build
#   3  production api url absent from the bundle
#   4  localhost url present in the bundle
#   5  node/npx unavailable
#
# This never runs git. On success it prints the commands the deploy convention
# expects and stops.

set -euo pipefail
cd "$(dirname "$0")/.."

PROD_URL="https://api.equbfinance.com"
DEV_URL="http://localhost:8000"
BUNDLE="build/web/main.dart.js"
PORT=8080
SERVE=1

while [ $# -gt 0 ]; do
  case "$1" in
    --no-serve) SERVE=0; shift ;;
    --port) PORT="${2:-}"; shift 2 ;;
    *) echo "unrecognised argument: $1" >&2; exit 1 ;;
  esac
done

if [ -f .fvmrc ] && command -v jq >/dev/null 2>&1; then
  pinned="$(jq -r .flutter .fvmrc)"
  running="$(flutter --version 2>/dev/null | head -1 | awk '{print $2}')"
  if [ "$pinned" != "$running" ]; then
    echo "warning: .fvmrc pins Flutter $pinned but $running is on PATH" >&2
  fi
fi

if ! git diff --quiet -- build/ 2>/dev/null; then
  echo "warning: build/ is already modified before this run" >&2
fi

# No flags, ever. STAGE_ENV defaults to prod, so the only way to produce a
# localhost bundle is to pass one, which is exactly what this script prevents.
echo "building..."
flutter build web || exit 1

[ -f "$BUNDLE" ] || { echo "$BUNDLE missing after build" >&2; exit 2; }

prod_hits="$(grep -c "$PROD_URL" "$BUNDLE" || true)"
dev_hits="$(grep -c "$DEV_URL" "$BUNDLE" || true)"

echo "  $PROD_URL: $prod_hits"
echo "  $DEV_URL: $dev_hits"

if [ "$prod_hits" -lt 1 ]; then
  echo "the bundle does not reference the production api; it would ship pointing nowhere" >&2
  exit 3
fi
if [ "$dev_hits" -ne 0 ]; then
  echo "the bundle references localhost; a dev build leaked in" >&2
  exit 4
fi

echo
echo "bundle looks deployable. build/ is now modified; commit it or run"
echo "  git checkout -- build/"
echo "before pushing anything else, or CI will reject the dirty tree."
echo
echo "to deploy:"
echo "  git add lib/ test/ && git commit -m \"<short lowercase message>\""
echo "  git add build/web && git commit -m \"build web $(date +%m.%d.%y) -v1\""
echo

if [ "$SERVE" -eq 0 ]; then
  exit 0
fi

command -v npx >/dev/null 2>&1 || { echo "npx not found; skip with --no-serve" >&2; exit 5; }

echo "serving on http://localhost:$PORT with the Procfile command, ctrl-c to stop"
npx http-server build/web -p "$PORT"
