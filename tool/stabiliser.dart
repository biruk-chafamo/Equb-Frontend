part of 'capture_fixtures.dart';

final _isoTimestamp = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}');
final _jwt = RegExp(r'^[\w-]+\.[\w-]+\.[\w-]+$');
final _hyperlinkPath = RegExp(r'^/([a-z]+)/(\d+)/$');

const _kindUser = 'user';
const _kindEqub = 'equb';

/// Keys whose value is an id, or a list of ids, rather than a nested object.
const _scalarIdKinds = {
  'friends': _kindUser,
  'joined_equbs': _kindEqub,
  'creator_id': _kindUser,
  'current_highest_bidder_id': _kindUser,
  'unpaid_member_ids': _kindUser,
  'confirmed_payer_ids': _kindUser,
  'unconfirmed_payer_ids': _kindUser,
  'rejected_payer_ids': _kindUser,
};

const _kindByCollection = {
  'users': _kindUser,
  'equbs': _kindEqub,
  'paymentmethods': 'paymentmethod',
  'bids': 'bid',
  'friendrequests': 'friendrequest',
  'equbinviterequests': 'equbinvite',
  'paymentconfirmationrequest': 'paymentconfirmation',
};

/// Rewrites a captured payload so that re-running capture against a re-seeded
/// backend produces byte-identical output. Without this every fixture churns on
/// every run: ids come from sequences that are never reset, timestamps and
/// countdowns are computed per request, and several list endpoints have no
/// ordering at all.
///
/// Aliases are assigned in a pre-pass that sorts by raw id within each entity
/// kind, so they never depend on the order a document happens to be walked in.
class _Stabiliser {
  final Map<String, Map<int, int>> _aliases = {};
  final Map<String, int> _nextAlias = {};

  Object? stabilise(
    Object? node, {
    bool rewriteTimestamps = true,
    bool sortLists = true,
    String? rootKind,
  }) {
    _collect(node, rootKind);
    _assign();
    return _transform(node, rootKind,
        rewriteTimestamps: rewriteTimestamps, sortLists: sortLists);
  }

  /// Root objects of a collection endpoint carry no field that identifies their
  /// kind, so it comes from the path the payload was fetched from.
  static String? kindForPath(String path) {
    final segment = path.split('?').first.split('/').where((s) => s.isNotEmpty);
    return segment.isEmpty ? null : _kindByCollection[segment.first];
  }

  String redactQuery(String path) => path
      .replaceAll(RegExp(r'=\d+'), '=')
      .replaceAll(RegExp(r'/\d+/'), '/{id}/');

  final Map<String, Set<int>> _pending = {};

  /// An object's kind comes from its own fields where possible, so a nested
  /// equb is never mistaken for a user just because their ids happen to match.
  String? _kindOf(Map<dynamic, dynamic> node, String? hint) {
    if (node.containsKey('username')) return _kindUser;
    if (node.containsKey('max_members')) return _kindEqub;
    if (node.containsKey('service') && node.containsKey('detail')) {
      return 'paymentmethod';
    }
    return hint;
  }

  void _collect(Object? node, String? hint) {
    if (node is List) {
      for (final item in node) {
        _collect(item, hint);
      }
      return;
    }
    if (node is! Map) return;

    final kind = _kindOf(node, hint);
    final id = node['id'];
    if (kind != null && id is int) {
      (_pending[kind] ??= <int>{}).add(id);
    }

    for (final entry in node.entries) {
      final key = entry.key as String;
      final value = entry.value;
      final scalarKind = _scalarIdKinds[key];
      if (scalarKind != null) {
        _collectScalars(value, scalarKind);
      } else if (value is String) {
        _collectHyperlink(value);
      } else {
        _collect(value, _childHint(key, kind));
      }
    }
  }

  void _collectScalars(Object? value, String kind) {
    if (value is int) {
      (_pending[kind] ??= <int>{}).add(value);
      return;
    }
    if (value is! List) return;
    for (final item in value) {
      if (item is int) (_pending[kind] ??= <int>{}).add(item);
    }
  }

  void _collectHyperlink(String value) {
    final parsed = _parseHyperlink(value);
    if (parsed != null) {
      (_pending[parsed.kind] ??= <int>{}).add(parsed.id);
    }
  }

  String? _childHint(String key, String? parentKind) {
    switch (key) {
      case 'equb':
      case 'equbDetail':
        return _kindEqub;
      case 'sender':
      case 'receiver':
      case 'user':
      case 'members':
      case 'latest_winner':
      case 'current_highest_bidder':
      case 'rejected_payers':
      case 'confirmed_payers':
      case 'unconfirmed_payers':
      case 'unpaid_members':
        return _kindUser;
      case 'payment_method':
      case 'selected_payment_methods':
        return 'paymentmethod';
      case 'results':
        return parentKind;
      default:
        return null;
    }
  }

  void _assign() {
    for (final entry in _pending.entries) {
      final kind = entry.key;
      final known = _aliases[kind] ??= <int, int>{};
      final base = kind == _kindUser
          ? 101
          : kind == _kindEqub
              ? 201
              : 1;
      final fresh = entry.value.where((id) => !known.containsKey(id)).toList()
        ..sort();
      for (final id in fresh) {
        known[id] = base + (_nextAlias[kind] ??= 0);
        _nextAlias[kind] = _nextAlias[kind]! + 1;
      }
    }
    _pending.clear();
  }

  int _alias(String kind, int id) => _aliases[kind]?[id] ?? id;

  Object? _transform(
    Object? node,
    String? hint, {
    required bool rewriteTimestamps,
    required bool sortLists,
  }) {
    if (node is List) {
      final items = node
          .map((item) => item is String
              ? _string(item, rewriteTimestamps: rewriteTimestamps)
              : _transform(item, hint,
                  rewriteTimestamps: rewriteTimestamps, sortLists: sortLists))
          .toList();
      if (sortLists && items.every((i) => i is Map && i['id'] is int)) {
        items.sort((a, b) =>
            ((a as Map)['id'] as int).compareTo((b as Map)['id'] as int));
      }
      return items;
    }
    if (node is! Map) return node;

    final kind = _kindOf(node, hint);
    final keys = node.keys.cast<String>().toList()..sort();
    final out = <String, Object?>{};

    for (final key in keys) {
      final value = node[key];

      if (key == 'time_left_till_next_round' && value is Map) {
        out[key] = _countdown(value);
      } else if (key == 'id' && value is int && kind != null) {
        out[key] = _alias(kind, value);
      } else if (_scalarIdKinds.containsKey(key) && value is List) {
        out[key] = _aliasScalars(value, _scalarIdKinds[key]!);
      } else if (_scalarIdKinds.containsKey(key) && value is int) {
        out[key] = _alias(_scalarIdKinds[key]!, value);
      } else if (value is String) {
        out[key] = _string(value, rewriteTimestamps: rewriteTimestamps);
      } else {
        out[key] = _transform(value, _childHint(key, kind),
            rewriteTimestamps: rewriteTimestamps, sortLists: sortLists);
      }
    }
    return out;
  }

  List<Object?> _aliasScalars(List<dynamic> value, String kind) {
    final ids = value.map((v) => v is int ? _alias(kind, v) : v).toList();
    ids.sort((a, b) => a is int && b is int ? a.compareTo(b) : 0);
    return ids;
  }

  /// Recomputed against now() on every request, so it can never be captured
  /// verbatim. Only the all-zero case, a round that has not started, is stable.
  Map<String, Object?> _countdown(Map<dynamic, dynamic> value) {
    if (value.values.every((v) => v == 0)) {
      return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};
    }
    return {'days': value['days'], 'hours': 23, 'minutes': 59, 'seconds': 59};
  }

  String _string(String value, {required bool rewriteTimestamps}) {
    if (_jwt.hasMatch(value) && value.length > 100) return _dummyJwt;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return _hyperlink(value);
    }
    if (rewriteTimestamps && _isoTimestamp.hasMatch(value)) {
      return _timestamp(value);
    }
    return value;
  }

  _Hyperlink? _parseHyperlink(String value) {
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return null;
    }
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    final match = _hyperlinkPath.firstMatch(uri.path);
    if (match == null) return null;
    final kind = _kindByCollection[match.group(1)];
    final id = int.tryParse(match.group(2)!);
    if (kind == null || id == null) return null;
    return _Hyperlink(kind, id, match.group(1)!);
  }

  String _hyperlink(String value) {
    final parsed = _parseHyperlink(value);
    if (parsed == null) return _sentinelHost;
    return '$_sentinelHost/${parsed.collection}/'
        '${_alias(parsed.kind, parsed.id)}/';
  }

  String _timestamp(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final anchor = DateTime.utc(2026, 1, 1);
    final days = parsed.toUtc().difference(anchor).inDays.clamp(-3650, 3650);
    return '${anchor.add(Duration(days: days)).toIso8601String().split('.').first}Z';
  }
}

class _Hyperlink {
  _Hyperlink(this.kind, this.id, this.collection);
  final String kind;
  final int id;
  final String collection;
}

const _dummyJwt = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    '.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjowLCJ1c2VyX2lkIjoxMDF9'
    '.signature';
