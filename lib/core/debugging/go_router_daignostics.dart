import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterDiagnostics {
  GoRouterDiagnostics._();

  static bool _attached = false;

  static void attach(GoRouter router) {
    if (_attached || !kDebugMode) return;
    _attached = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logFullState(router, trigger: 'INITIAL_ROUTE');
    });

    router.routerDelegate.addListener(() {
      logFullState(router, trigger: 'NAVIGATION_CHANGE');
    });
  }

  static void logFullState(GoRouter router, {String trigger = 'MANUAL'}) {
    if (!kDebugMode) return;

    final delegate = router.routerDelegate;
    final config = delegate.currentConfiguration;

    if (config.matches.isEmpty) {
      debugPrint(
        '🧭 GOROUTER [$trigger]: currentConfiguration is empty (no matches yet).',
      );
      return;
    }

    final state = delegate.state;
    final uri = state.uri;

    final buffer = StringBuffer()
      ..writeln(
        '╔══════════════════════════════════════════════════════════════',
      )
      ..writeln('║ 🧭 GOROUTER FULL DIAGNOSTICS [$trigger]')
      ..writeln(
        '╠══════════════════════════════════════════════════════════════',
      )
      ..writeln('║ [GoRouterState]')
      ..writeln('║   • uri (full):        ${state.uri}')
      ..writeln('║   • matchedLocation:   ${state.matchedLocation}')
      ..writeln('║   • path (segment):    ${state.path}')
      ..writeln('║   • fullPath (pattern):${state.fullPath}')
      ..writeln('║   • name:              ${state.name}')
      ..writeln('║   • pageKey:           ${state.pageKey}')
      ..writeln('║   • pathParameters:    ${state.pathParameters}')
      ..writeln(
        '║   • extra:             ${state.extra} (${state.extra?.runtimeType})',
      )
      ..writeln('║   • metadata:          ${state.metadata}')
      ..writeln('║   • error:             ${state.error}')
      ..writeln('║   • topRoute:          ${_describeRoute(state.topRoute)}')
      ..writeln(
        '╠──────────────────────────────────────────────────────────────',
      )
      ..writeln('║ [URI Breakdown]')
      ..writeln('║   • scheme:            ${uri.scheme}')
      ..writeln('║   • host / authority:  ${uri.host} / ${uri.authority}')
      ..writeln('║   • path:              ${uri.path}')
      ..writeln('║   • pathSegments:      ${uri.pathSegments}')
      ..writeln('║   • query:             ${uri.query}')
      ..writeln('║   • queryParameters:   ${uri.queryParameters}')
      ..writeln('║   • queryParamsAll:    ${uri.queryParametersAll}')
      ..writeln('║   • fragment:          ${uri.fragment}')
      ..writeln(
        '╠──────────────────────────────────────────────────────────────',
      )
      ..writeln('║ [Router / Navigator Status]')
      ..writeln('║   • canPop():          ${router.canPop()}')
      ..writeln('║   • routerNeglect:     ${delegate.routerNeglect}')
      ..writeln('║   • navigatorKey:      ${delegate.navigatorKey}')
      ..writeln(
        '║   • rootNav canPop:    ${delegate.navigatorKey.currentState?.canPop()}',
      )
      ..writeln(
        '╠──────────────────────────────────────────────────────────────',
      )
      ..writeln(
        '║ [RouteMatchList / Active Stack] (count: ${config.matches.length})',
      )
      ..writeln('║   • config.fullPath:   ${config.fullPath}')
      ..writeln('║   • config.uri:        ${config.uri}')
      ..writeln('║   • config.isError:    ${config.isError}')
      ..writeln('║   • config.pathParams: ${config.pathParameters}')
      ..writeln('║   • config.extra:      ${config.extra}')
      ..writeln('║   • config.error:      ${config.error}');

    for (var i = 0; i < config.matches.length; i++) {
      _dumpMatch(buffer, config.matches[i], index: i, indent: '  ');
    }

    buffer
      ..writeln(
        '╠──────────────────────────────────────────────────────────────',
      )
      ..writeln('║ [Diagnosticable Tree (toStringDeep)]')
      ..writeln(
        config
            .toDiagnosticsNode()
            .toStringDeep(prefixLineOne: '║   ', prefixOtherLines: '║   ')
            .trimRight(),
      )
      ..writeln(
        '╚══════════════════════════════════════════════════════════════',
      );

    debugPrint(buffer.toString());
  }

  static void _dumpMatch(
    StringBuffer buffer,
    RouteMatchBase match, {
    required int index,
    required String indent,
  }) {
    buffer.writeln('║ $indent[$index] ${match.runtimeType}');
    buffer.writeln('║ $indent    • matchedLocation: ${match.matchedLocation}');
    buffer.writeln('║ $indent    • pageKey:         ${match.pageKey}');

    if (match is RouteMatch) {
      buffer.writeln(
        '║ $indent    • route:           ${_describeRoute(match.route)}',
      );
    }

    if (match is ImperativeRouteMatch) {
      buffer.writeln('║ $indent    • imperativeUri:   ${match.matches.uri}');
      buffer.writeln('║ $indent    • imperativeExtra: ${match.matches.extra}');
    }

    if (match is ShellRouteMatch) {
      buffer.writeln('║ $indent    • shellMatches (${match.matches.length}):');
      for (var j = 0; j < match.matches.length; j++) {
        _dumpMatch(buffer, match.matches[j], index: j, indent: '$indent      ');
      }
    }
  }

  static String _describeRoute(RouteBase? route) {
    if (route == null) return 'null';
    if (route is GoRoute) {
      return 'GoRoute(name: ${route.name}, path: "${route.path}", '
          'parentNavKey: ${route.parentNavigatorKey}, '
          'hasRedirect: ${route.redirect != null}, '
          'hasOnExit: ${route.onExit != null}, '
          'subRoutes: ${route.routes.length})';
    }
    if (route is StatefulShellRoute) {
      return 'StatefulShellRoute(branches: ${route.branches.length}, '
          'parentNavKey: ${route.parentNavigatorKey})';
    }
    if (route is ShellRoute) {
      return 'ShellRoute(navigatorKey: ${route.navigatorKey}, '
          'parentNavKey: ${route.parentNavigatorKey}, '
          'subRoutes: ${route.routes.length})';
    }
    return route.runtimeType.toString();
  }
}
