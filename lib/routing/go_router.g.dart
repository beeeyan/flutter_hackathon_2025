// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $profileSetupPageRoute,
  $homePageRoute,
  $joinRoomPageRoute,
  $roomLobbyPageRoute,
  $votingPageRoute,
  $resultPageRoute,
];

RouteBase get $profileSetupPageRoute => GoRouteData.$route(
  path: '/profile_setup',
  name: 'profile_setup',
  factory: $ProfileSetupPageRoute._fromState,
);

mixin $ProfileSetupPageRoute on GoRouteData {
  static ProfileSetupPageRoute _fromState(GoRouterState state) =>
      const ProfileSetupPageRoute();

  @override
  String get location => GoRouteData.$location('/profile_setup');

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

RouteBase get $homePageRoute => GoRouteData.$route(
  path: '/home_page',
  name: 'home_page',
  factory: $HomePageRoute._fromState,
);

mixin $HomePageRoute on GoRouteData {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  @override
  String get location => GoRouteData.$location('/home_page');

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

RouteBase get $joinRoomPageRoute => GoRouteData.$route(
  path: '/join_room',
  name: 'join_room',
  factory: $JoinRoomPageRoute._fromState,
);

mixin $JoinRoomPageRoute on GoRouteData {
  static JoinRoomPageRoute _fromState(GoRouterState state) =>
      const JoinRoomPageRoute();

  @override
  String get location => GoRouteData.$location('/join_room');

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

RouteBase get $roomLobbyPageRoute => GoRouteData.$route(
  path: '/room_lobby/:qrCode',
  name: 'room_lobby',
  factory: $RoomLobbyPageRoute._fromState,
);

mixin $RoomLobbyPageRoute on GoRouteData {
  static RoomLobbyPageRoute _fromState(GoRouterState state) =>
      RoomLobbyPageRoute(qrCode: state.pathParameters['qrCode']!);

  RoomLobbyPageRoute get _self => this as RoomLobbyPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/room_lobby/${Uri.encodeComponent(_self.qrCode)}');

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

RouteBase get $votingPageRoute => GoRouteData.$route(
  path: '/voting',
  name: 'voting',
  factory: $VotingPageRoute._fromState,
);

mixin $VotingPageRoute on GoRouteData {
  static VotingPageRoute _fromState(GoRouterState state) =>
      VotingPageRoute(qrCode: state.uri.queryParameters['qr-code']!);

  VotingPageRoute get _self => this as VotingPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/voting', queryParams: {'qr-code': _self.qrCode});

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

RouteBase get $resultPageRoute => GoRouteData.$route(
  path: '/result',
  name: 'result',
  factory: $ResultPageRoute._fromState,
);

mixin $ResultPageRoute on GoRouteData {
  static ResultPageRoute _fromState(GoRouterState state) =>
      ResultPageRoute(qrCode: state.uri.queryParameters['qr-code']!);

  ResultPageRoute get _self => this as ResultPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/result', queryParams: {'qr-code': _self.qrCode});

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
