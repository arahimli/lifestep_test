import 'package:flutter/material.dart';
import 'main_colors.dart';
import 'main_config.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    MainColors.loadColor2(false);

    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: MainColors.mainColor,
      primaryColorDark: MainColors.mainDarkColor,
      primaryColorLight: MainColors.mainLightColor,
      textTheme: TextTheme(
        headline1: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family),
        headline2: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family),
        headline3: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family),
        headline4: TextStyle(
          color: MainColors.textPrimaryColor,
          fontFamily: MainConfig.main_default_font_family,
        ),
        headline5: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family),
        subtitle1: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family,
            fontWeight: FontWeight.bold),
        subtitle2: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family,
            fontWeight: FontWeight.bold),
        bodyText1: TextStyle(
          color: MainColors.textPrimaryColor,
          fontFamily: MainConfig.main_default_font_family,
        ),
        bodyText2: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family,
            fontWeight: FontWeight.bold),
        button: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family),
        caption: TextStyle(
            color: MainColors.textPrimaryLightColor,
            fontFamily: MainConfig.main_default_font_family),
        overline: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family),
      ),
      iconTheme: IconThemeData(color: MainColors.iconColor),
      appBarTheme: AppBarTheme(color: MainColors.coreBackgroundColor),
    );
  } else {
    MainColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: MainColors.mainColor,
        primaryColorDark: MainColors.mainDarkColor,
        primaryColorLight: MainColors.mainLightColor,
        textTheme: TextTheme(
          headline1: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family),
          headline2: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family),
          headline3: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family),
          headline4: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family,
          ),
          headline5: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family,
              fontWeight: FontWeight.bold),
          headline6: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family),
          subtitle1: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family,
              fontWeight: FontWeight.bold),
          subtitle2: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family,
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
            color: MainColors.textPrimaryColor,
            fontFamily: MainConfig.main_default_font_family,
          ),
          bodyText2: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family,
              fontWeight: FontWeight.bold),
          button: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family),
          caption: TextStyle(
              color: MainColors.textPrimaryLightColor,
              fontFamily: MainConfig.main_default_font_family),
          overline: TextStyle(
              color: MainColors.textPrimaryColor,
              fontFamily: MainConfig.main_default_font_family),
        ),
        iconTheme: IconThemeData(color: MainColors.iconColor),
        appBarTheme: AppBarTheme(color: MainColors.coreBackgroundColor));
  }
}