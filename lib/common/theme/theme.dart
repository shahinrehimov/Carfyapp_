import 'package:flutter/material.dart';

class AppTheme extends InheritedWidget {
  final _lightColors = _LightColors();
  final _darkColors = _LightColors();

  final ThemeMode themeMode;

  Brightness get brightness => themeMode == ThemeMode.light ? Brightness.light : Brightness.dark;

  ColorScheme get colors => themeMode == ThemeMode.light ? _lightColors : _darkColors;

  AppTheme({super.key, required super.child, required this.themeMode});

  ThemeData getTheme() => ThemeData(brightness: brightness, useMaterial3: false);

  static AppTheme of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppTheme>()!;

  @override
  bool updateShouldNotify(AppTheme oldWidget) => oldWidget.themeMode != themeMode;
}

extension ThemeContextExtension on BuildContext {
  AppTheme get theme => AppTheme.of(this);
}

abstract interface class ColorScheme {
  Color get white;

  Color get black;

  Color get shimmerBaseColor;

  Color get shimmerHighlightColor;

  Color get primary;

  Color get secondary;

  Color get textBlack;

  Color get textDark;

  Color get textGray;

  Color get textLight;

  Color get lightGray;

  Color get darkGray;

  Color get error;

  Color get border;

  Color get bg;

  Color get divider;
}

class _LightColors extends ColorScheme {
  @override
  Color get black => Colors.black;

  @override
  Color get white => Colors.white;

  @override
  Color get shimmerBaseColor => Colors.grey.shade300;

  @override
  Color get shimmerHighlightColor => Colors.grey.shade100;

  @override
  Color get primary => Color(0xFF00569C);

  @override
  Color get secondary => Color(0xFF3696E7);

  @override
  Color get textBlack => Color(0xFF000000);

  @override
  Color get textDark => Color(0xFF242323);

  @override
  Color get textGray => Color(0xFF727272);

  @override
  Color get textLight => Color(0xFF9F9F9F);

  @override
  Color get lightGray => Color(0xFF969EA5);

  @override
  Color get darkGray => Color(0xFF7B7B7B);

  @override
  Color get error => Color(0xFFF6683C);

  @override
  Color get border => Color(0xFFD8D7D7);

  @override
  Color get bg => Color(0xFFF7FBFE);

  @override
  Color get divider => Color(0xFFE3E3E3);
}
