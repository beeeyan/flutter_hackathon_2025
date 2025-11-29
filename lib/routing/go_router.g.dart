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
      factory: $MyHomePageRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/sample1',
      name: 'sample1',
      factory: $Sample1PageRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/sample2',
      name: 'sample2',
      factory: $Sample2PageRoute._fromState,
    ),
  ],
);

extension $RootShellRouteExtension on RootShellRoute {
  static RootShellRoute _fromState(GoRouterState state) =>
      const RootShellRoute();
}

mixin $MyHomePageRoute on GoRouteData {
  static MyHomePageRoute _fromState(GoRouterState state) =>
      const MyHomePageRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $Sample1PageRoute on GoRouteData {
  static Sample1PageRoute _fromState(GoRouterState state) =>
      const Sample1PageRoute();

  @override
  String get location => GoRouteData.$location('/sample1');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $Sample2PageRoute on GoRouteData {
  static Sample2PageRoute _fromState(GoRouterState state) =>
      const Sample2PageRoute();

  @override
  String get location => GoRouteData.$location('/sample2');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
