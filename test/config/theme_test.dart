import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano/config/theme.dart';

void main() {
  group('AppTheme', () {
    test('primaryColorは落ち着いた青緑色である', () {
      expect(AppTheme.primaryColor, const Color(0xFF2E7D8E));
    });

    test('primaryVariantは濃い青緑色である', () {
      expect(AppTheme.primaryVariant, const Color(0xFF1A5564));
    });

    test('secondaryColorは優しい緑色である', () {
      expect(AppTheme.secondaryColor, const Color(0xFF4A9D5F));
    });

    test('secondaryVariantは濃い緑色である', () {
      expect(AppTheme.secondaryVariant, const Color(0xFF357A47));
    });

    test('backgroundColorは明るいグレーである', () {
      expect(AppTheme.backgroundColor, const Color(0xFFF8F9FA));
    });

    test('surfaceColorは白色である', () {
      expect(AppTheme.surfaceColor, const Color(0xFFFFFFFF));
    });

    test('errorColorは赤色である', () {
      expect(AppTheme.errorColor, const Color(0xFFD32F2F));
    });

    test('whiteKeyColorは白色である', () {
      expect(AppTheme.whiteKeyColor, const Color(0xFFFFFFFF));
    });

    test('whiteKeyPressedColorはグレーである', () {
      expect(AppTheme.whiteKeyPressedColor, const Color(0xFFE0E0E0));
    });

    test('blackKeyColorは黒色である', () {
      expect(AppTheme.blackKeyColor, const Color(0xFF212121));
    });

    test('blackKeyPressedColorは濃いグレーである', () {
      expect(AppTheme.blackKeyPressedColor, const Color(0xFF424242));
    });

    test('lightThemeはMaterial3を使用する', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, true);
    });

    test('lightThemeのカラースキームはprimaryColorから生成される', () {
      final theme = AppTheme.lightTheme;
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('lightThemeのscaffoldBackgroundColorはbackgroundColorである', () {
      final theme = AppTheme.lightTheme;
      expect(theme.scaffoldBackgroundColor, AppTheme.backgroundColor);
    });

    test('lightThemeのappBarはセンター配置である', () {
      final theme = AppTheme.lightTheme;
      expect(theme.appBarTheme.centerTitle, true);
    });

    test('lightThemeのappBarは影がない', () {
      final theme = AppTheme.lightTheme;
      expect(theme.appBarTheme.elevation, 0);
    });

    test('lightThemeのcardには角丸がある', () {
      final theme = AppTheme.lightTheme;
      final shape = theme.cardTheme.shape as RoundedRectangleBorder?;
      expect(shape, isNotNull);
      final radius = shape!.borderRadius as BorderRadius;
      expect(radius.topLeft.x, 12);
    });

    test('darkThemeはMaterial3を使用する', () {
      final theme = AppTheme.darkTheme;
      expect(theme.useMaterial3, true);
    });

    test('darkThemeのカラースキームはダークモードである', () {
      final theme = AppTheme.darkTheme;
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('darkThemeのscaffoldBackgroundColorは暗い色である', () {
      final theme = AppTheme.darkTheme;
      expect(theme.scaffoldBackgroundColor, const Color(0xFF121212));
    });
  });
}
