#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
flutter run --web-port=56937 --dart-define-from-file=.env "$@"
