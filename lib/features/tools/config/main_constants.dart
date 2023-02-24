

import 'package:intl/intl.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/main_config.dart';

class MainConst {
  MainConst._();

  static const List<String> customWeekDays =  ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
  static const List<String> imageFileFormats =  ["tif", "tiff", "bmp", "jpeg", "jpg", "gif", "png", "heic"];
  static List<Map<String, dynamic>> genderDataMap = [
    {
    'keyword': '1',
    'key': "general__gender_options_male",
    'display': Utils.getStringWithoutContext("general__gender_options_male"),
    },
    {
      'keyword': '2',
      'key': "general__gender_options_female",
      'display': Utils.getStringWithoutContext("general__gender_options_female")
    },
  ];

  static const String themeIsDarkTheme = 'THEME__IS_DARK_THEME';

  static const String filteringDesc = 'desc'; // Don't Change
  static const String filteringAsc = 'asc'; // Don't Change
  static const String one = '1';
  // static const String FILTERING_FEATURE = 'featured_date';
  // static const String FILTERING_TRENDING = 'touch_count';

  static const String platform = 'android';

  static const String valueHolderToken = 'token';

  static final NumberFormat mainFormat = NumberFormat(MainConfig.priceFormat);
  static const String priceTwoDecimalFormatString = '###.00';
  static final NumberFormat priceTwoDecimalFormat =
  NumberFormat(priceTwoDecimalFormatString);

  ///
  /// Hero Tags
  ///
  static const String heroTagImage = '_image';
  static const String heroTagTitle = '_title';
  static const String heroTagOriginalPrice = '_original_price';
  static const String heroTagUnitPrice = '_unit_price';

  ///
  /// Firebase Auth Providers
  ///
  static const String emailAuthProvider = 'password';
  static const String appleAuthProvider = 'apple';
  static const String facebookAuthProvider = 'facebook';
  static const String googleAuthProvider = 'google';
  ///
  /// Error Codes
  ///
  static const String errorCode10001 = '10001'; // Totally No Record
  static const String errorCode10002 =
      '10002'; // No More Record at pagination
}