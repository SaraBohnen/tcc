// lib/utils/constants.dart

import 'package:flutter/material.dart';

class AppColors {
  // Cores de fundo
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Cores de texto e ícones (escuro sobre fundo claro)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF424242);

  // Cor de destaque
  static const Color accentBlue = Color(0xFF2979FF);

  // Para BottomNavigationBar ao ficar selecionado / não selecionado
  static const Color navSelected = accentBlue;
  static const Color navUnselected = Color(0xFF9E9E9E); // cinza médio
}

class AppStrings {
  static const String appTitle = 'Chain View';
  static const String splashSlogan =
      'Monitoramento inteligente das suas carteiras';
}

class AppStyles {
  static const TextStyle splashTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.accentBlue,
  );

  // Títulos de AppBar (escuro para tema claro)
  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Cor padrão de texto do corpo
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
}
