import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/common/utlis.dart';

import 'main_config.dart';

class MainStyles {
  MainStyles._();

  ///
  /// Main Style
  ///
  static TextStyle mainAppbarStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily, fontSize: 28, height: 1.2, fontWeight: FontWeight.w800);
  static TextStyle appbarStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily, fontSize: 24, height: 1.2, fontWeight: FontWeight.w700);
  static TextStyle blackTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w900);
  static TextStyle extraBoldTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w800);
  static TextStyle boldTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w700);
  static TextStyle semiBoldTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w600);
  static TextStyle mediumTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w500);
  static TextStyle regularTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w400);
  static TextStyle lightTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w300);
  static TextStyle extraLightTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, height: 1.2, fontWeight: FontWeight.w200);

  static TextStyle tabTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 12, height: 1.2, fontWeight: FontWeight.w800);

  // static TextStyle darkGrayTextStyle = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 16, fontWeight: FontWeight.w200, color: MainColors.mainDarkColor);
  // static TextStyle darkGrayText18Style = const TextStyle( fontFamily: MainConfig.mainDefaultFontFamily,fontSize: 18, fontWeight: FontWeight.w200, color: MainColors.mainDarkColor);





  static void _loadDarkStyles() {
    ///
    /// Main Style
    ///
    mainAppbarStyle = mainAppbarStyle.copyWith(color: Colors.white);
    appbarStyle = appbarStyle.copyWith(color: Colors.white);
    boldTextStyle = boldTextStyle.copyWith(color: Colors.white);
    blackTextStyle = blackTextStyle.copyWith(color: Colors.white);
    extraBoldTextStyle = extraBoldTextStyle.copyWith(color: Colors.white);
    boldTextStyle = boldTextStyle.copyWith(color: Colors.white);
    semiBoldTextStyle = semiBoldTextStyle.copyWith(color: Colors.white);
    mediumTextStyle = mediumTextStyle.copyWith(color: Colors.white);
    regularTextStyle = regularTextStyle.copyWith(color: Colors.white);
    lightTextStyle = lightTextStyle.copyWith(color: Colors.white);
    extraLightTextStyle = extraLightTextStyle.copyWith(color: Colors.white);

  }

  static void _loadLightStyles() {
    ///
    /// Main Style
    ///
    mainAppbarStyle = mainAppbarStyle.copyWith(color: Colors.black);
    appbarStyle = appbarStyle.copyWith(color: Colors.black);
    boldTextStyle = boldTextStyle.copyWith(color: Colors.black);
    blackTextStyle = blackTextStyle.copyWith(color: Colors.black);
    extraBoldTextStyle = extraBoldTextStyle.copyWith(color: Colors.black);
    boldTextStyle = boldTextStyle.copyWith(color: Colors.black);
    semiBoldTextStyle = semiBoldTextStyle.copyWith(color: Colors.black);
    mediumTextStyle = mediumTextStyle.copyWith(color: Colors.black);
    regularTextStyle = regularTextStyle.copyWith(color: Colors.black);
    lightTextStyle = lightTextStyle.copyWith(color: Colors.black);
    extraLightTextStyle = extraLightTextStyle.copyWith(color: Colors.black);

  }









  static void loadStyle(BuildContext context) {
    if (Utils.isLightMode(context)) {
      _loadLightStyles();
    } else {
      _loadDarkStyles();
    }
  }

  static void loadStyle2(bool isLightMode) {
    if (isLightMode) {
      _loadLightStyles();
    } else {
      _loadDarkStyles();
    }
  }

}