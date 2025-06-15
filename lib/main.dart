// lib/main.dart

import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/metrics_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const AppChainView());
}

class AppChainView extends StatelessWidget {
  const AppChainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primaryWhite,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryWhite,
          elevation: 0,
          titleTextStyle: AppStyles.screenTitle,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.primaryWhite,
          selectedItemColor: AppColors.navSelected,
          unselectedItemColor: AppColors.navUnselected,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          bodyLarge: AppStyles.bodyText,
          bodyMedium: AppStyles.bodyText,
          bodySmall: AppStyles.bodyText,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accentBlue,
          foregroundColor: AppColors.primaryWhite,
        ),
        cardTheme: const CardTheme(
          color: AppColors.surfaceLight,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        MetricsScreen.routeName: (_) => const MetricsScreen(),
      },
    );
  }
}
