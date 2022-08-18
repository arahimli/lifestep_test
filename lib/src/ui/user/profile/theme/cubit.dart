import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/app/theme.dart';
import 'package:lifestep/src/ui/user/profile/theme/state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeCubit extends Cubit<ThemeState> {
  bool dark = false;


  applyTheme(int themeId) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeId', themeId);
      emit(ThemeState(dark: themeId == AppThemes.DarkBlue));
  }

  ThemeCubit() : super(ThemeState(dark: false)) {
    initialize();
  }

  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(ThemeState(dark: !prefs.containsKey('themeId') ? false : prefs.getInt("themeId") == AppThemes.DarkBlue));
  }
}
