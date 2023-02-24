import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/endpoints.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/profile/language/state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalLanguageCubit extends Cubit<LocalLanguageState> {
  String? language;
  bool changed = false;


  setLanguage(String? value) {
    language = value;
    changed = languageGlobal != value ? true : false;
    emit(LocalLanguageState(language: value, changed: languageGlobal != value ? true : false));
  }

  applyLanguage() async{
    if(state.changed && state.language != null && state.language != ''){
      languageGlobal = state.language ?? 'az';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lingua_code', Utils.generateLanguageHeader(state.language!));
      await prefs.setString('language', state.language!);
    }
  }

  LocalLanguageCubit() : super(LocalLanguageState(language: languageGlobal, changed: false)) {
    initialize();
  }

  Future<void> initialize() async {

  }
}
