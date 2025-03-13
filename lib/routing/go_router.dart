import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../feature/home/home.dart';
import '../feature/root.dart';
import '../feature/sample1.dart';
import '../feature/sample2.dart';
import 'no_animation_transition.dart';

part 'go_router.g.dart';

/*
 go_router_builderでgo_router.g.dartを生成するため、
 goRouterProviderはriverpod_generatorで実装しない。
 */

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: MyHomePage.path,
    routes: $appRoutes,
  );
});

@TypedShellRoute<RootShellRoute>(
  routes: [
    TypedGoRoute<MyHomePageRoute>(path: MyHomePage.path, name: MyHomePage.name),
    TypedGoRoute<Sample1PageRoute>(
      path: Sample1Page.path,
      name: Sample1Page.name,
    ),
    TypedGoRoute<Sample2PageRoute>(
      path: Sample2Page.path,
      name: Sample2Page.name,
    ),
  ],
)
class RootShellRoute extends ShellRouteData {
  const RootShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootPage(child: navigator);
  }
}

class MyHomePageRoute extends GoRouteData {
  const MyHomePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const MyHomePage());
  }
}

class Sample1PageRoute extends GoRouteData {
  const Sample1PageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const Sample1Page());
  }
}

class Sample2PageRoute extends GoRouteData {
  const Sample2PageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const Sample2Page());
  }
}
