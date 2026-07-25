import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/constants/app_constants.dart';
import 'package:nari_suraksha/core/routes/app_router.dart';
import 'package:nari_suraksha/core/routes/app_routes.dart';
import 'package:nari_suraksha/core/theme/app_theme.dart';

class NarisurakshaApp extends StatelessWidget {
  const NarisurakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Start at splash; the splash screen resolves the correct next route.
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      onUnknownRoute: AppRouter.onUnknownRoute,
    );
  }
}