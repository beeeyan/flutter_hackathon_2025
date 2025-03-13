// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$rootShellRoute];

RouteBase get $rootShellRoute => ShellRouteData.$route(
  navigatorKey: RootShellRoute.$navigatorKey,
  factory: $RootShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/home',
      name: 'home',

      factory: $MyHomePageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: '/sample1',
      name: 'sample1',

      factory: $Sample1PageRouteExtension._fromState,
    ),
    GoRouteData.$route(
      path: '/sample2',
      name: 'sample2',

      factory: $Sample2PageRouteExtension._fromState,
    ),
  ],
);

extension $RootShellRouteExtension on RootShellRoute {
  static RootShellRoute _fromState(GoRouterState state) =>
      const RootShellRoute();
}

extension $MyHomePageRouteExtension on MyHomePageRoute {
  static MyHomePageRoute _fromState(GoRouterState state) =>
      const MyHomePageRoute();

  String get location => GoRouteData.$location('/home');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $Sample1PageRouteExtension on Sample1PageRoute {
  static Sample1PageRoute _fromState(GoRouterState state) =>
      const Sample1PageRoute();

  String get location => GoRouteData.$location('/sample1');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $Sample2PageRouteExtension on Sample2PageRoute {
  static Sample2PageRoute _fromState(GoRouterState state) =>
      const Sample2PageRoute();

  String get location => GoRouteData.$location('/sample2');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
