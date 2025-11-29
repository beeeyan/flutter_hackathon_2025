import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../feature/auth/application/state/auth_state.dart';
import '../feature/home/home_page.dart';
import '../feature/join_room/join_room_page.dart';
import '../feature/profile_setup/profile_setup_page.dart';
import '../feature/result/result_page.dart';
import '../feature/room_lobby/room_lobby_page.dart';
import '../feature/user/infra/user_repository.dart';
import '../feature/voting/voting_page.dart';
import 'no_animation_transition.dart';

part 'go_router.g.dart';

/*
 go_router_builderでgo_router.g.dartを生成するため、
 goRouterProviderはriverpod_generatorで実装しない。
 */

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: HomePage.path,
    routes: $appRoutes,
    redirect: (context, state) async {
      if (authState.isLoading || authState.hasError) {
        return null;
      }

      // ユーザードキュメントが存在しない場合はプロフィール設定画面に遷移
      final isUserExists = await ref.read(userRepositoryProvider).userExists();
      if (!isUserExists) {
        return ProfileSetupPage.path;
      }

      return null;
    },
  );
});

@TypedGoRoute<ProfileSetupPageRoute>(
  path: ProfileSetupPage.path,
  name: ProfileSetupPage.name,
)
class ProfileSetupPageRoute extends GoRouteData with $ProfileSetupPageRoute {
  const ProfileSetupPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const ProfileSetupPage());
  }
}

@TypedGoRoute<HomePageRoute>(
  path: HomePage.path,
  name: HomePage.name,
)
class HomePageRoute extends GoRouteData with $HomePageRoute {
  const HomePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const HomePage());
  }
}

@TypedGoRoute<JoinRoomPageRoute>(
  path: JoinRoomPage.path,
  name: JoinRoomPage.name,
)
class JoinRoomPageRoute extends GoRouteData with $JoinRoomPageRoute {
  const JoinRoomPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const JoinRoomPage());
  }
}

@TypedGoRoute<RoomLobbyPageRoute>(
  path: RoomLobbyPage.path,
  name: RoomLobbyPage.name,
)
class RoomLobbyPageRoute extends GoRouteData with $RoomLobbyPageRoute {
  const RoomLobbyPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const RoomLobbyPage());
  }
}

@TypedGoRoute<VotingPageRoute>(
  path: VotingPage.path,
  name: VotingPage.name,
)
class VotingPageRoute extends GoRouteData with $VotingPageRoute {
  const VotingPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const VotingPage());
  }
}

@TypedGoRoute<ResultPageRoute>(
  path: ResultPage.path,
  name: ResultPage.name,
)
class ResultPageRoute extends GoRouteData with $ResultPageRoute {
  const ResultPageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildNoAnimationTransition(const ResultPage());
  }
}
