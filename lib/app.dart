import 'package:flutter/material.dart';

import 'package:agenda_app/core/di/auth_di.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppDependencies deps = AppDependencies.build();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router(deps),
    );
  }
}
