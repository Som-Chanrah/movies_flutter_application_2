import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/movie_theme_logic.dart';
import '../screens/parent_screen.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<MovieThemeLogic>().dark;
    Color seedColor = Colors.deepOrange;
    Color secondaryColor = Colors.lime.shade300;
    Color appBarColor = Colors.deepOrange.shade400;

    return MaterialApp(
      home: ParentScreen(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryColor,
          shape: CircleBorder(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryColor.withAlpha(96), //0 dark -> 255 light
          shape: CircleBorder(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor.withAlpha(180),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
