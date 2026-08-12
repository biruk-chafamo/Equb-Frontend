part of 'capture_fixtures.dart';

class _Store {
  _Store({required this.check});

  final bool check;
  final _Stabiliser _stabiliser = _Stabiliser();
  final Map<String, Map<String, Object?>> _index = {};
  final List<String> _changed = [];
  int _unchanged = 0;
  int _smoke = 0;

  void record(String path, int status, Object? decoded) {
    final entry = <String, Object?>{'status': status};
    if (decoded is List) {
      entry['shape'] = 'array';
      entry['count'] = decoded.length;
    } else if (decoded is Map) {
      entry['shape'] = 'object';
      entry['keys'] = (decoded.keys.cast<String>().toList()..sort());
    } else {
      entry['shape'] = decoded == null ? 'empty' : 'scalar';
    }
    _index['GET ${_stabiliser.redactQuery(path)}'] = entry;
    _smoke++;
  }

  /// [sortLists] is off for endpoints whose ordering is part of the contract,
  /// such as /bids/ with its `-round, -amount` Meta.ordering.
  void write(String name, Object? value,
          {bool sortLists = true, String? rootKind}) =>
      _persist(
          name,
          _stabiliser.stabilise(value,
              sortLists: sortLists, rootKind: rootKind));

  /// Written without timestamp rewriting, so the real wire format stays visible
  /// somewhere. The only fixture expected to churn on a re-seed.
  void writeRaw(String name, Object? value) => _persist(
      name, _stabiliser.stabilise(value, rewriteTimestamps: false));

  void writeIndex() => _persist('api_index.json', _sortDeep(_index));

  void _persist(String name, Object? value) {
    final file = File('$_outDir/$name');
    final text = '${const JsonEncoder.withIndent('  ').convert(value)}\n';

    final existing = file.existsSync() ? file.readAsStringSync() : null;
    if (existing == text) {
      _unchanged++;
      return;
    }
    _changed.add(name);
    if (check) return;

    file.parent.createSync(recursive: true);
    file.writeAsStringSync(text);
  }

  int report() {
    if (check) {
      if (_changed.isEmpty) {
        stdout.writeln('fixtures match the live api ($_unchanged files)');
        return 0;
      }
      stdout.writeln('${_changed.length} fixture(s) would change:');
      for (final name in _changed) {
        stdout.writeln('  $name');
      }
      return 1;
    }
    stdout.writeln(
        'wrote ${_changed.length}, unchanged $_unchanged, endpoints $_smoke');
    return 0;
  }
}

Object? _sortDeep(Object? node) {
  if (node is Map) {
    final keys = node.keys.cast<String>().toList()..sort();
    return {for (final k in keys) k: _sortDeep(node[k])};
  }
  if (node is List) return node.map(_sortDeep).toList();
  return node;
}
