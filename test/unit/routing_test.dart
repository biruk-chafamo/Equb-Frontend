import 'package:equb_v3_frontend/routing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> _flatten(List<RouteBase> routes) => [
      for (final route in routes) ...[
        if (route is GoRoute) route,
        ..._flatten(route.routes),
      ]
    ];

void main() {
  late GoRouter router;

  setUp(() => router = createRouter());

  List<GoRoute> allRoutes() => _flatten(router.configuration.routes);

  test('every route is addressable by name', () {
    final named = allRoutes().where((r) => r.name != null);

    expect(named.length, allRoutes().length,
        reason: 'an unnamed route cannot be navigated to by name');
  });

  test('route names are unique', () {
    final names = allRoutes().map((r) => r.name!).toList();

    expect(names.toSet().length, names.length);
  });

  test('createRouter honours its initial location', () {
    final atLogin = createRouter(initialLocation: '/login');

    expect(atLogin.routeInformationProvider.value.uri.path, '/login');
  });

  test('two routers do not share navigation state', () {
    final first = createRouter(initialLocation: '/login');
    final second = createRouter();

    expect(first.routeInformationProvider.value.uri.path, '/login');
    expect(second.routeInformationProvider.value.uri.path, '/');
    expect(identical(first, second), isFalse);
  });

  group('path parameters', () {
    test('the routes that take an id declare it in their path', () {
      final withParams = {
        for (final route in allRoutes())
          if (route.path.contains(':')) route.name!: route.path
      };

      expect(withParams.keys, contains('equb_invite'));
      expect(withParams['equb_invite'], contains(':equbId'));
      expect(withParams.keys, contains('password_reset'));
    });

    test('a named route with a parameter builds its location', () {
      expect(
        router.namedLocation('equb_invite', pathParameters: {'equbId': '7'}),
        contains('7'),
      );
    });
  });
}
