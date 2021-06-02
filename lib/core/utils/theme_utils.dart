import 'package:flutter/material.dart';

import 'package:marine_watch/core/utils/color_utils.dart';

class ThemeUtils {
  ThemeData get themeData {
    return ThemeData(
        dividerColor: Colors.white70,
        indicatorColor: ColorUtils.accentColor,
        dialogBackgroundColor: ColorUtils.backgroundColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: ColorUtils.backgroundColor,
        ),
        appBarTheme: AppBarTheme(
          color: ColorUtils.backgroundColor,
          iconTheme: IconThemeData(
            color: ColorUtils.white87,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorUtils.accentColor, //thereby
        ),
        // textSelectionHandleColor: ColorUtils.accentColor,
        // textSelectionColor: ColorUtils.accentColor,
        primarySwatch: MaterialColor(
          0xFF242729,
          <int, Color>{
            50: ColorUtils.cardColor,
            100: ColorUtils.cardColor,
            200: ColorUtils.cardColor,
            300: ColorUtils.cardColor,
            400: ColorUtils.cardColor,
            500: ColorUtils.backgroundColor,
            600: ColorUtils.backgroundColor,
            700: ColorUtils.backgroundColor,
            800: ColorUtils.backgroundColor,
            900: ColorUtils.backgroundColor,
          },
        ),
        cardColor: ColorUtils.cardColor,
        accentColor: ColorUtils.accentColor,
        canvasColor: ColorUtils.accentColor,
        scaffoldBackgroundColor: ColorUtils.backgroundColor,
        backgroundColor: ColorUtils.backgroundColor,
        hintColor: Colors.white38,
        textTheme: getMainTextTheme(),
        iconTheme: IconThemeData(
          size: 16,
          color: ColorUtils.accentColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: Colors.white38,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorUtils.accentColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorUtils.backgroundColor,
            ),
          ),
        ),
        tooltipTheme: TooltipThemeData(
            decoration: BoxDecoration(
          color: ColorUtils.accentColor,
        )));
  }

  TextTheme getMainTextTheme() {
    return ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
            color: ColorUtils.white87,
          ),
          headline2: TextStyle(
            color: ColorUtils.white87,
          ),
          headline3: TextStyle(
            color: ColorUtils.white87,
          ),
          headline4: TextStyle(
            color: ColorUtils.white87,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          headline5: TextStyle(
            color: ColorUtils.white87,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headline6: TextStyle(
            color: ColorUtils.white87,
          ),
          subtitle2: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          subtitle1: TextStyle(
            color: ColorUtils.white87,
          ),
          // caption: TextStyle(
          //   color: ColorUtils.white60,
          // ),
          button: TextStyle(
            color: ColorUtils.backgroundColor,
          ),
          bodyText2: TextStyle(
            color: ColorUtils.white87,
          ),
        );
  }
}
