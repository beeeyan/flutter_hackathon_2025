import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/firebase/dev/firebase_options.dart' as dev;
import 'config/firebase/prod/firebase_options.dart' as prod;
import 'config/theme/theme.dart';
import 'enum/flavor.dart';
import 'routing/go_router.dart';
import 'util/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebaseApp();

  // Flavor を取得し Logging
  logger.i('FLAVOR : ${flavor.name}');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      // TODO(abe-tk): デザインサイズを確認し必要に応じて変更する
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: lightTheme(),
          // アプリ内文字サイズを固定（本体設定の影響を受けない）
          builder: (context, child) {
            return MediaQuery.withNoTextScaling(child: child!);
          },
          routerConfig: ref.watch(goRouterProvider),
        );
      },
    );
  }
}

Future<void> initializeFirebaseApp() async {
  final firebaseOptions = switch (flavor) {
    Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
    Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
  };
  await Firebase.initializeApp(options: firebaseOptions);
  logger.i('Firebase initialized : ${firebaseOptions.projectId}');
}
