#!/usr/bin/env bash
# Runs the same checks GitHub runs, minus the coverage report and the deploy.
# Arguments are passed through to `flutter test`:
#   ./tool/run_tests.sh test/flow
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> Getting packages"
flutter pub get

echo "==> Analyzing"
flutter analyze

echo "==> Testing"
flutter test "$@"

echo "==> Checking for pumpAndSettle"
if grep -rn "\.pumpAndSettle(" test/; then
  echo
  echo "Found pumpAndSettle above. It hangs on this app's animated placeholders"
  echo "and countdowns, so the test would freeze instead of failing."
  echo "Use pumpFrames or pumpUntilFound from test/support/harness/pump_helpers.dart."
  exit 1
fi

echo
echo "All checks passed."
