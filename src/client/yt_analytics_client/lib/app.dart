import 'package:flutter/material.dart';
import 'package:yt_analytics_client/colors.dart';
import 'package:yt_analytics_client/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitNBytes Analytics',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(context),
      darkTheme: _buildDarkTheme(context),
      home: Home(),
    );
  }
}

ThemeData _buildLightTheme(BuildContext context) {
  final base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: ClientColors.red500,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData _buildDarkTheme(BuildContext context) {
  final base = ThemeData.dark();
  return base.copyWith(
    primaryColor: ClientColors.grey500,
    colorScheme: const ColorScheme.dark(
      primary: ClientColors.red500,
      surface: ClientColors.grey500,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
