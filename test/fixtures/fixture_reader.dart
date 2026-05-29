import 'dart:convert';
import 'dart:io';

Map<String, dynamic> jsonFixture(String name) =>
    jsonDecode(_read(name)) as Map<String, dynamic>;

List<dynamic> jsonListFixture(String name) =>
    jsonDecode(_read(name)) as List<dynamic>;

String _read(String name) {
  final file = File('test/fixtures/$name');
  if (!file.existsSync()) {
    throw ArgumentError('No fixture at ${file.path}');
  }
  return file.readAsStringSync();
}
