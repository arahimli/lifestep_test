import 'package:flutter/widgets.dart';

class AppConstant {
  static const trLocale = Locale("tr", "TR");
  static const enLocale = Locale("en", "EN");
  static const ruLocale = Locale("ru", "RU");
  static const langPath = "assets/langs";

  static const supportedLocale = [
    AppConstant.enLocale,
    AppConstant.trLocale,
    AppConstant.ruLocale,
  ];
}