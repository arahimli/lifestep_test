import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/cubits/global/settings/state.dart';
import 'package:lifestep/src/models/settings/model.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/resources/static.dart';




class SettingsCubit extends Cubit<SettingsState> {
  final IStaticRepository staticRepository;
  SettingsModel? settingsModel;


  SettingsCubit({required this.staticRepository}) : super(SettingsLoading()) {
    getSettings();
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
