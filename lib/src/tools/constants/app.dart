import 'package:flutter/widgets.dart';

class AppConstant {
  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale("en", "EN");
  static const RU_LOCALE = Locale("ru", "RU");
  static const LANG_PATH = "assets/langs";

  static const SUPPORTED_LOCALE = [
    AppConstant.EN_LOCALE,
    AppConstant.TR_LOCALE,
    AppConstant.RU_LOCALE,
  ];
}