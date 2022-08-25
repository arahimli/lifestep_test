import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/common/utlis.dart';

class MainColors {
  MainColors._();

  ///
  /// Main Color
  ///
  static Color? mainColor;
  static Color? primaryColor;
  static Color? textGreyColor;
  static Color? darkPink100 = const Color(0xFFFBCEDA);
  static Color? darkPink150 = const Color(0xFFF9B9CA);
  static Color? darkPink200 = const Color(0xFFF7A4BA);
  static Color? darkPink300 = const Color(0xFFF3799A);
  static Color? darkPink400 = const Color(0xFFF04F7A);
  static Color? darkPink500 = const Color(0xFFEC255A);
  static Color? darkPink600 = const Color(0xFFCC1243);
  static Color? darkPink700 = const Color(0xFF9D0E34);


  static Color? middleGrey50 = const Color(0xFFFBFBFB);
  static Color? middleGrey100 = const Color(0xFFEDEDEE);
  static Color? middleGrey150 = const Color(0xFFDEDFE0);
  static Color? middleGrey200 = const Color(0xFFD0D1D3);
  static Color? middleGrey300 = const Color(0xFFB3B5B7);
  static Color? middleGrey400 = const Color(0xFF96989C);
  static Color? middleGrey500 = const Color(0xFF797C81);
  static Color? middleGrey600 = const Color(0xFF5B5E61);
  static Color? middleGrey700 = const Color(0xFF3E3F42);
  static Color? middleGrey750 = const Color(0xFF2F3032);
  static Color? middleGrey800 = const Color(0xFF202122);
  static Color? middleGrey850 = const Color(0xFF111212);
  static Color? middleGrey900 = const Color(0xFF030303);


  static Color? middleBlue50 = const Color(0xFFD2D3EE);
  static Color? middleBlue100 = const Color(0xFFBABCE5);
  static Color? middleBlue150 = const Color(0xFFA2A5DC);
  static Color? middleBlue200 = const Color(0xFF8A8DD3);
  static Color? middleBlue300 = const Color(0xFF5A5EC1);
  static Color? middleBlue400 = const Color(0xFF3B3F9D);
  static Color? middleBlue500 = const Color(0xFF292C6D);
  static Color? middleBlue600 = const Color(0xFF151739);

  static Color? darkBlue50 = const Color(0xFF3337C0);
  static Color? darkBlue100 = const Color(0xFF3034B4);
  static Color? darkBlue150 = const Color(0xFF2C30A8);
  static Color? darkBlue200 = const Color(0xFF292D9C);
  static Color? darkBlue300 = const Color(0xFF232683);
  static Color? darkBlue400 = const Color(0xFF1C1F6B);
  static Color? darkBlue500 = const Color(0xFF161853);
  static Color? darkBlue600 = const Color(0xFF0F1037);
  static Color? generalColor = const Color(0xFF012485);
  static Color? generalSubtitleColor = const Color(0xFF3337C0);
  static Color? generalCupertinoSearchPlaceholder = const Color(0xFF96989C);
  static Color? bottomBarUnselectedColor = const Color(0xFF70707E);
  static Color? primaryDisableColor;
  static Color? mainDividerColor;
  static Color? inputBorderColor;
  static Color? successGreenColor;

  static Color? liderboardBackgroundColor;
  static Color? howCanWinOrderColor;
  static Color? softBorderColor;
  static Color? coreBackgroundColor;
  static Color? backgroundColor;
  static Color? stopButtonColor;
  ///
  /// Base Color
  ///
  static Color? baseColor;
  static Color? baseDarkColor;
  static Color? baseLightColor;
  static Color mainDarkColor = const Color(0xFF7F7F7F);
  static Color mainGrayColor = const Color(0xFF7F7F7F);
  static Color mainBorderColor = const Color(0xFFE2E2E2);
  static Color? mainLightColor;


  ///
  /// Icon Color
  ///
  static Color? iconColor;

  ///
  /// Text Color
  ///
  static Color? textPrimaryColor;
  static Color? textPrimaryDarkColor;
  static Color? textPrimaryLightColor;
  ///
  /// General
  ///
  static Color? white;
  static Color? black;
  static Color? red;
  static Color? grey;
  static Color? green;
  static Color? yellow;
  static Color? greyLight;
  static Color? dotColor;
  static Color? transparent;


  ///
  /// Light Theme
  ///
  static const Color _l_base_color = const Color(0xFEFAFAFA);
  static const Color _l_base_dark_color = const Color(0xFFFFFFFF);
  static const Color _l_base_light_color = const Color(0xFFFFFFFF);

  static const Color _l_text_primary_color = const Color(0xFF445E76);
  static const Color _l_text_primary_light_color = const Color(0xFFadadad);
  static const Color _l_text_primary_dark_color = const Color(0xFF25425D);

  static const Color _l_icon_color = const Color(0xFF445E76);

  static const Color _l_divider_color = const Color(0x15505050);

  ///
  /// Dark Theme
  ///
  static const Color _d_base_color = const Color(0xFF212121);
  static const Color _d_base_dark_color = const Color(0xFF303030);
  static const Color _d_base_light_color = const Color(0xFF454545);

  static const Color _l_liderboard_light_color = const Color(0xFFE3E4FA);
  static const Color _d_liderboard_dark_color = const Color(0xFFE3E4FA);

  static const Color _lHowCanWinOrderColor = const Color(0xFFE3E4FA);
  static const Color _dHowCanWinOrderColor = const Color(0xFFE3E4FA);

  static const Color _lSoftBorderColor = const Color(0xFFF7F7F8);
  static const Color _dSoftBorderColor = const Color(0xFFF7F7F8);

  static const Color _l_background_light_color = const Color(0xFFF7F7F8);
  static const Color _d_background_dark_color = const Color(0xFFF7F7F8);

  static const Color _lStopButtonColor = const Color(0xFFF7F7F8);
  static const Color _dStopButtonColor = const Color(0xFFF7F7F8);

  static const Color _d_text_primary_color = const Color(0xFFFFFFFF);
  static const Color _d_text_primary_light_color = const Color(0xFFFFFFFF);
  static const Color _d_text_primary_dark_color = const Color(0xFFFFFFFF);

  static const Color _l_text_grey_light_color = const Color(0xFFB3B5B7);
  static const Color _d_text_grey_dark_color = const Color(0xFFB3B5B7);

  static const Color _d_icon_color = Colors.white;

  static const Color _d_divider_color = const Color(0x1FFFFFFF);
  static const Color _d_main_border_color = const Color(0xFFD0D1D3);
  static const Color _l_main_border_color = const Color(0xFFD0D1D3);

  static const Color _d_successGreenColor = const Color(0xFF2DD685);
  static const Color _l_successGreenColor = const Color(0xFF2DD685);

  ///
  /// Common Theme
  ///
  // static const Color _c_main_color = const Color(0xFFFFCC29);
  static const Color _c_main_color = const Color(0xFFFFD35F);
  static const Color _c_main_primary_color = const Color(0xFF161853);
  static const Color _c_main_primary_disable_color = const Color(0xFFFFEAA8);
  static const Color _c_main_dark_primary_color = const Color(0xFF3337C0);
  static const Color _c_main_dark_primary_disable_color = const Color(0xFF000000);


  static const Color _c_main_light_color = const Color(0xFFf4f4f4);
  static const Color _c_main_dark_color = const Color(0xFF7F7F7F);

  static const Color _c_white_color = Colors.white;
  static const Color _c_black_color = Colors.black;
  static const Color _c_red_color = Colors.red;
  static const Color _c_grey_color = Colors.grey;
  static const Color _c_green_color = Colors.green;
  static const Color _c_yellow_color = Colors.yellow;
  static const Color _c_grey_light_color = const Color(0xffD2D2D2);
  static const Color _c_dot_color = const Color(0xFFCDD5DE);
  static const Color _c_transparent_color = Colors.transparent;

  static const Color ps_ctheme__color_about_us = Colors.cyan;
  static const Color ps_ctheme__color_application = Colors.blue;
  static const Color ps_ctheme__color_line = const Color(0xFFbdbdbd);



  // static const Color _c_middle_blue_50 = const Color(0xFFFFD35F);


  static void loadColor(BuildContext context) {
    if (Utils.isLightMode(context)) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void loadColor2(bool isLightMode) {
    if (isLightMode) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void _loadDarkColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    primaryColor = _c_main_dark_primary_color;
    primaryDisableColor = _c_main_dark_primary_disable_color;
    mainDividerColor = _d_divider_color;
    inputBorderColor = _d_main_border_color;
    successGreenColor = _d_successGreenColor;

    textGreyColor = _d_text_grey_dark_color;

    ///
    /// Base Color
    ///
    baseColor = _d_base_color;
    baseDarkColor = _d_base_dark_color;
    baseLightColor = _d_base_light_color;
    mainLightColor = _c_main_light_color;
    mainDarkColor = _c_main_dark_color;

    ///
    /// Icon Color
    ///
    iconColor = _d_icon_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _d_text_primary_color;
    textPrimaryDarkColor = _d_text_primary_dark_color;
    textPrimaryLightColor = _d_text_primary_light_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _d_base_color;
    backgroundColor = _d_background_dark_color;
    stopButtonColor = _dStopButtonColor;
    liderboardBackgroundColor = _d_liderboard_dark_color;
    howCanWinOrderColor = _dHowCanWinOrderColor;
    softBorderColor = _dSoftBorderColor;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    red = _c_red_color;
    grey = _c_grey_color;
    green = _c_green_color;
    yellow = _c_yellow_color;
    greyLight = _c_grey_light_color;
    greyLight = _c_grey_color;
    dotColor = _c_dot_color;
    transparent = _c_transparent_color;

  }

  static void _loadLightColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    primaryColor = _c_main_primary_color;
    primaryDisableColor = _c_main_primary_disable_color;
    mainDividerColor = _l_divider_color;
    inputBorderColor = _l_main_border_color;
    successGreenColor = _d_successGreenColor;

    textGreyColor = _l_text_grey_light_color;


    ///
    /// Base Color
    ///
    baseColor = _l_base_color;
    baseDarkColor = _l_base_dark_color;
    baseLightColor = _l_base_light_color;
    mainLightColor = _c_main_light_color;
    mainDarkColor = _c_main_dark_color;

    ///
    /// Icon Color
    ///
    iconColor = _d_icon_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _l_text_primary_color;
    textPrimaryDarkColor = _l_text_primary_dark_color;
    textPrimaryLightColor = _l_text_primary_light_color;
    ///
    /// Background Color
    ///
    coreBackgroundColor = _l_base_color;
    backgroundColor = _l_background_light_color;
    stopButtonColor = _lStopButtonColor;
    liderboardBackgroundColor = _l_liderboard_light_color;
    howCanWinOrderColor = _lHowCanWinOrderColor;
    softBorderColor = _lSoftBorderColor;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    green = _c_green_color;
    yellow = _c_yellow_color;
    red = _c_red_color;
    greyLight = _c_grey_light_color;
    dotColor = _c_dot_color;
    transparent = _c_transparent_color;

  }
}