import 'dart:convert';
import 'dart:io';

part 'fixture_store.dart';
part 'stabiliser.dart';

const _usage = '''
capture_fixtures - record real backend responses as test fixtures

  dart run tool/capture_fixtures.dart [options]

  --check         report which fixtures would change, write nothing, exit 1 if any
  --base-url URL  backend to capture from (default http://localhost:8000)
  --help          this text

Run this against a locally running, seeded backend before a deploy:

  cd ../equb_backend_main
  POSTGRES_HOST=localhost REDIS_URL=redis://localhost:6379 python manage.py seed_dev
  POSTGRES_HOST=localhost REDIS_URL=redis://localhost:6379 python manage.py runserver 8000

  cd ../equb_frontend_main
  dart run tool/capture_fixtures.dart --check

Exit 0 there means the committed fixtures still describe the live API. A non-zero
exit means the backend has drifted and the contract tests are describing a past.

Only localhost backends are accepted. There is no flag to override that.
''';

const _password = 'equbtest123';
const _localHosts = {'localhost', '127.0.0.1', '::1'};
const _sentinelHost = 'https://api.example';
const _outDir = 'test/fixtures/captured';

const _seedEqubs = [
  'Weekly Savers',
  'Coffee Fund',
  'Rent Circle',
  'Final Stretch',
  'Payment Due',
  'Holiday Pot',
];

Future<void> main(List<String> args) async {
  exitCode = await _run(args);
}

Future<int> _run(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    stdout.write(_usage);
    return 0;
  }

  final check = args.contains('--check');
  final baseUrl = _argValue(args, '--base-url') ?? 'http://localhost:8000';

  final host = Uri.tryParse(baseUrl)?.host;
  if (host == null || !_localHosts.contains(host)) {
    stderr.writeln('refusing to capture from "$baseUrl"');
    stderr.writeln('only localhost backends are accepted; there is no override');
    return 2;
  }

  final api = _Api(baseUrl);
  final store = _Store(check: check);

  try {
    await api.login('alice');
  } on _CaptureFailure catch (e) {
    stderr.writeln(e.message);
    return e.code;
  }

  try {
    final ids = await _discover(api);
    await _capture(api, store, ids);
  } on _CaptureFailure catch (e) {
    stderr.writeln(e.message);
    return e.code;
  } finally {
    api.close();
  }

  return store.report();
}

String? _argValue(List<String> args, String flag) {
  final i = args.indexOf(flag);
  return i == -1 || i + 1 >= args.length ? null : args[i + 1];
}

class _CaptureFailure implements Exception {
  _CaptureFailure(this.code, this.message);
  final int code;
  final String message;
}

class _Ids {
  final Map<String, int> users = {};
  final Map<String, int> equbs = {};
  int paymentDueRound = 1;
}

Future<_Ids> _discover(_Api api) async {
  final ids = _Ids();

  final me = await api.getJson('/users/currentuser/');
  ids.users['alice'] = me['id'] as int;

  for (final friend in await api.getList('/users/friends/')) {
    final user = friend as Map<String, dynamic>;
    ids.users[user['username'] as String] = user['id'] as int;
  }

  for (final name in ['grace', 'erin', 'frank', 'heidi']) {
    if (ids.users.containsKey(name)) continue;
    final page = await api.getJson('/users/search/?name=$name');
    for (final row in (page['results'] as List<dynamic>)) {
      final user = row as Map<String, dynamic>;
      if (user['username'] == name) ids.users[name] = user['id'] as int;
    }
  }

  for (final row in await api.getList('/equbs/')) {
    final equb = row as Map<String, dynamic>;
    ids.equbs[equb['name'] as String] = equb['id'] as int;
    if (equb['name'] == 'Payment Due') {
      ids.paymentDueRound = equb['current_round'] as int;
    }
  }

  final missing = _seedEqubs.where((n) => !ids.equbs.containsKey(n)).toList();
  if (missing.isNotEmpty) {
    throw _CaptureFailure(
      4,
      'seeded equbs not found: ${missing.join(', ')}\n'
      'run: POSTGRES_HOST=localhost REDIS_URL=redis://localhost:6379 '
      'python manage.py seed_dev',
    );
  }

  return ids;
}

Future<void> _capture(_Api api, _Store store, _Ids ids) async {
  final equb = ids.equbs;
  final user = ids.users;

  Future<void> body(String path, String file, {String as = 'alice'}) async {
    await api.login(as);
    final value = await api.getAny(path);
    store.record(path, value.status, value.decoded);
    store.write(file, value.decoded, rootKind: _Stabiliser.kindForPath(path));
  }

  Future<void> smoke(String path, {String as = 'alice'}) async {
    await api.login(as);
    final value = await api.getAny(path);
    store.record(path, value.status, value.decoded);
  }

  await body('/equbs/${equb['Weekly Savers']}/', 'equb_detail_pending.json');
  await body('/equbs/${equb['Coffee Fund']}/', 'equb_detail_invited.json');
  await body('/equbs/${equb['Rent Circle']}/', 'equb_detail_active_bid.json');
  await body('/equbs/${equb['Final Stretch']}/', 'equb_detail_final_round.json');
  await body('/equbs/${equb['Payment Due']}/', 'equb_detail_payment_stage.json');
  await body('/equbs/${equb['Holiday Pot']}/', 'equb_detail_completed.json');
  await body('/equbs/${equb['Payment Due']}/',
      'equb_detail_payment_stage_winner.json',
      as: 'bob');

  await body('/equbs/activeequbs/', 'equbs_active.json');
  await body('/equbs/invitedequbs/', 'equbs_invited.json');
  await body('/equbs/recommendedequbs/', 'equbs_recommended.json', as: 'carol');
  await smoke('/equbs/pendingequbs/');
  await smoke('/equbs/pastequbs/');
  await smoke('/equbs/by-user/?user=${user['bob']}');

  await body('/users/currentuser/', 'user_current.json');
  await body('/users/search/?name=a', 'users_search.json');
  await body('/users/friends/', 'users_friends.json');
  await smoke('/users/${user['bob']}/');
  await smoke('/users/friends/?id=${user['bob']}');

  await body('/friendrequests/received/', 'friend_requests_received.json');
  await smoke('/friendrequests/sent/');
  await body('/equbinviterequests/received/', 'equb_invites_received.json');
  await body('/equbinviterequests/by-equb/?equb=${equb['Weekly Savers']}',
      'equb_invites_by_equb.json');

  await body('/paymentmethods/', 'payment_methods.json');
  await body('/paymentmethods/services/', 'payment_services.json');
  await smoke('/paymentmethods/by-user/?user=${user['bob']}');

  await body(
    '/paymentconfirmationrequest/by-equb-round/'
    '?equb=${equb['Payment Due']}&round=${ids.paymentDueRound}',
    'payment_confirmation_requests.json',
  );
  await api.login('alice');
  final bids = await api.getAny('/bids/');
  store.record('/bids/', bids.status, bids.decoded);
  store.write('bids.json', bids.decoded,
      sortLists: false, rootKind: _Stabiliser.kindForPath('/bids/'));

  store.writeRaw('timestamp_samples.json', await api.timestampSamples(
    '/equbs/${equb['Rent Circle']}/',
  ));

  store.write('auth_token.json', await api.tokenPair());
  store.write('auth_refresh.json', await api.refreshOnly());
  store.write('error_envelopes.json', await api.errorEnvelopes(
    finalRoundEqubId: equb['Final Stretch']!,
    someUserId: user['bob']!,
  ));

  store.writeIndex();
}

class _Response {
  _Response(this.status, this.decoded);
  final int status;
  final Object? decoded;
}

class _Api {
  _Api(this.baseUrl);

  final String baseUrl;
  final HttpClient _client = HttpClient();

  String? _username;
  String? _access;
  String? _refresh;
  DateTime? _issued;

  void close() => _client.close(force: true);

  Future<void> login(String username) async {
    if (_username == username && !_stale) return;
    _username = username;
    final res = await _send('POST', '/api-auth/token/', body: {
      'username': username,
      'password': _password,
    });
    if (res.status != 200) {
      throw _CaptureFailure(
        3,
        'login as $username failed with ${res.status}; is the backend seeded?',
      );
    }
    final tokens = res.decoded as Map<String, dynamic>;
    _access = tokens['access'] as String;
    _refresh = tokens['refresh'] as String;
    _issued = DateTime.now();
  }

  // SimpleJWT access tokens live 5 minutes; re-login well inside that rather
  // than implementing refresh, which returns only a new access token anyway.
  bool get _stale =>
      _issued == null ||
      DateTime.now().difference(_issued!) > const Duration(minutes: 4);

  Future<void> _ensureFresh() async {
    if (_stale && _username != null) {
      final username = _username!;
      _username = null;
      await login(username);
    }
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final res = await getAny(path);
    return res.decoded as Map<String, dynamic>;
  }

  Future<List<dynamic>> getList(String path) async {
    final res = await getAny(path);
    return res.decoded as List<dynamic>;
  }

  Future<_Response> getAny(String path) async {
    await _ensureFresh();
    var res = await _send('GET', path, auth: true);
    if (res.status == 401 && _username != null) {
      final username = _username!;
      _username = null;
      await login(username);
      res = await _send('GET', path, auth: true);
    }
    return res;
  }

  Future<Map<String, dynamic>> tokenPair() async {
    final res = await _send('POST', '/api-auth/token/',
        body: {'username': 'alice', 'password': _password});
    return res.decoded as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refreshOnly() async {
    final res = await _send('POST', '/api-auth/token/refresh/',
        body: {'refresh': _refresh});
    return res.decoded as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> timestampSamples(String equbPath) async {
    final equb = await getJson(equbPath);
    return {
      'creation_date': equb['creation_date'],
      'payment_collection_dates': equb['payment_collection_dates'],
    };
  }

  Future<Map<String, dynamic>> errorEnvelopes({
    required int finalRoundEqubId,
    required int someUserId,
  }) async {
    final login401 = await _send('POST', '/api-auth/token/',
        body: {'username': 'alice', 'password': 'wrong-password'});

    await login('alice');
    final bid400 = await _send('POST', '/bids/', auth: true, body: {
      'equb': '$baseUrl/equbs/$finalRoundEqubId/',
      'amount': '0.100',
    });
    final missingParam = await _send('GET', '/equbs/by-user/', auth: true);
    final notFound =
        await _send('GET', '/paymentmethods/by-user/?user=$someUserId', auth: true);

    return {
      'login_401': {'status': login401.status, 'body': login401.decoded},
      'bid_final_round_400': {'status': bid400.status, 'body': bid400.decoded},
      'missing_param_400': {
        'status': missingParam.status,
        'body': missingParam.decoded
      },
      'not_found_404': {'status': notFound.status, 'body': notFound.decoded},
    };
  }

  Future<_Response> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final request = await _client.openUrl(method, Uri.parse('$baseUrl$path'));
    request.headers.contentType = ContentType.json;
    if (auth && _access != null) {
      request.headers.set('Authorization', 'Bearer $_access');
    }
    if (body != null) {
      // Django's WSGI dev server does not read chunked request bodies, which is
      // what dart:io sends when contentLength is left unset.
      final payload = utf8.encode(jsonEncode(body));
      request.contentLength = payload.length;
      request.add(payload);
    }

    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    Object? decoded;
    if (text.isNotEmpty) {
      try {
        decoded = jsonDecode(text);
      } on FormatException {
        decoded = text;
      }
    }
    return _Response(response.statusCode, decoded);
  }
}
