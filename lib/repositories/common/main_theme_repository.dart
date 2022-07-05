import 'package:flutter/material.dart';
import 'package:lifestep/config/main_constants.dart';
import 'package:lifestep/config/main_theme_data.dart';
import 'package:lifestep/tools/db/main_shared_preferences.dart';
import 'package:lifestep/repositories/common/main_repository.dart';


class MainThemeRepository extends MainRepository {
  MainThemeRepository({required MainSharedPreferences mainSharedPreferences}) {
    _mainSharedPreferences = mainSharedPreferences;
  }

  MainSharedPreferences? _mainSharedPreferences;

  Future<void> updateTheme(bool isDarkTheme) async {
    await _mainSharedPreferences!.shared!
        .setBool(MainConst.THEME__IS_DARK_THEME, isDarkTheme);
  }

  ThemeData getTheme() {
    final bool isDarkTheme =
        _mainSharedPreferences!.shared!.getBool(MainConst.THEME__IS_DARK_THEME) ??
            false;

    if (isDarkTheme) {
      return themeData(ThemeData.dark());
    } else {
      return themeData(ThemeData.light());
    }
  }
}