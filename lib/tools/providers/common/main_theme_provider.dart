import 'package:flutter/material.dart';
import 'package:lifestep/repositories/common/main_theme_repository.dart';

import 'main_provider.dart';

class MainThemeProvider extends MainProvider {
  MainThemeProvider({required MainThemeRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
  }
  MainThemeRepository? _repo;

  Future<dynamic> updateTheme(bool isDarkTheme) {
    return _repo!.updateTheme(isDarkTheme);
  }

  ThemeData getTheme() {
    return _repo!.getTheme();
  }
}