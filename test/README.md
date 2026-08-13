# Frontend tests

These run with no backend and no network. Fake repositories stand in for the
real ones to avoid expensive test.

## Run the tests

To run all test:

```bash
./tool/run_tests.sh
```

To run one folder or one file:

```bash
flutter test test/[[folder]]
flutter test test/flow/[[file]]
```

`pumpAndSettle` is not usable in this suite. Parts of this app animate forever,
so it hangs instead of failing. Use `pumpFrames` or `pumpUntilFound` from
`test/support/harness/pump_helpers.dart`. The check on GitHub enforces this.

## Run the app against the backend for manual testing

Run the backend first:

```bash
cd [[backend dir]]
source equb_venv/bin/activate
POSTGRES_HOST=localhost REDIS_URL=redis://localhost:6379
python3 manage.py seed_dev
python3 manage.py runserver 8000
```

Then the app:

```bash
flutter run -d chrome --web-port=56937 --dart-define=STAGE_ENV=dev
```

`STAGE_ENV=dev` points the app at localhost. Without it the app talks to the
live production server. The port matters because the backend only accepts
browser requests from the ports listed in `CORS_ALLOWED_ORIGINS` in
`config/settings.py`.

Sign in as `alice`, password `equbtest123`.

## Keeping fixtures in step with the API

`test/fixtures/captured/` holds backend responses. The contract tests read
them to confirm the app still understands what the server sends.

### Steps

After an API response changes, start a seeded local backend:

```bash
cd [[backend dir]]
POSTGRES_HOST=localhost REDIS_URL=redis://localhost:6379 
python3 manage.py seed_dev --reset  # this ensures that previous edits don't change fixtures
python3 manage.py seed_dev
```

then immediately capture the fixture before making any db changes:

```bash
cd [[frontend dir]]
dart run tool/capture_fixtures.dart --check   # exit 0 means fixtures still match
dart run tool/capture_fixtures.dart           # rewrite them if they don't match
```

Run `--check` before a deploy. A non-zero exit means the backend has moved on
and the contract tests describe an API that no longer exists. Review rewritten
files before committing, since a change there is a change to what the app
expects.

## Tests in the CI pipeline

`.github/workflows/ci.yml`, on every pull request and every push to `main`. It
runs `flutter analyze`, runs the tests with coverage, rejects `pumpAndSettle`,
and fails if anything under `build/` changed.

On a push to `main`, a second job builds the web bundle and pushes it to
Heroku.
