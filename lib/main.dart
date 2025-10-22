// lib/main.dart
import 'package:app_chain_view/views/login_screen.dart';
import 'package:app_chain_view/views/viewmodels/login_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_chain_view/views/onboarding/onboarding_screen.dart';
import 'package:app_chain_view/views/start/start_gate.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginAuthViewModel>(
          create: (_) => LoginAuthViewModel(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
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
          cardTheme: const CardThemeData(
            color: AppColors.surfaceLight,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        initialRoute: StartGate.routeName,
        routes: {
          StartGate.routeName: (_) => const StartGate(),
          SplashScreen.routeName: (_) => const SplashScreen(),
          OnboardingScreen.routeName: (_) => const OnboardingScreen(),
          MetricsScreen.routeName: (_) => const MetricsScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(), // agora simples
        },
      ),
    );
  }
}
