import 'package:flutter/material.dart';

/// アプリケーションテーマ
class AppTheme {
  AppTheme._();

  // カラーパレット（落ち着いた青緑系）
  static const Color primaryColor = Color(0xFF2E7D8E); // 落ち着いた青緑
  static const Color primaryVariant = Color(0xFF1A5564); // 濃い青緑
  static const Color secondaryColor = Color(0xFF4A9D5F); // 優しい緑
  static const Color secondaryVariant = Color(0xFF357A47); // 濃い緑
  static const Color backgroundColor = Color(0xFFF8F9FA); // 明るいグレー
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);

  // ピアノ鍵盤カラー
  static const Color whiteKeyColor = Color(0xFFFFFFFF);
  static const Color whiteKeyPressedColor = Color(0xFFE0E0E0);
  static const Color blackKeyColor = Color(0xFF212121);
  static const Color blackKeyPressedColor = Color(0xFF424242);

  // テキストカラー
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textOnPrimaryColor = Color(0xFFFFFFFF);

  /// ライトテーマ
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondaryColor),
      ),
    );
  }

  /// ダークテーマ（将来の拡張用）
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
