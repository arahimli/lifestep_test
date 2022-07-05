import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/model/settings/model.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/repositories/static.dart';



class SettingsCubit extends Cubit<SettingsState> {
  final StaticRepository staticRepository;
  SettingsModel? settingsModel;


  SettingsCubit({required this.staticRepository}) : super(SettingsLoading()) {
    this.getSettings();
  }


  Future<void> getSettings() async {
    List listData = await staticRepository.getSettings();
    if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
      SettingsResponse  termsPrivacyResponse = SettingsResponse.fromJson(listData[1]);
      emit(SettingsStateLoaded(settingsModel: termsPrivacyResponse.data));
    } else if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
      emit(SettingsError(errorCode: listData[2]));
    }
  }
}
