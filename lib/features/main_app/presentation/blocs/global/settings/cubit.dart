import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/settings/state.dart';
import 'package:lifestep/features/main_app/data/models/settings/model.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/main_app/resources/static.dart';




class SettingsCubit extends Cubit<SettingsState> {
  final IStaticRepository staticRepository;
  SettingsModel? settingsModel;


  SettingsCubit({required this.staticRepository}) : super(SettingsLoading()) {
    getSettings();
  }


  Future<void> getSettings() async {
    List listData = await staticRepository.getSettings();
    if(listData[2] == WEB_SERVICE_ENUM.success) {
      SettingsResponse  termsPrivacyResponse = SettingsResponse.fromJson(listData[1]);
      emit(SettingsStateLoaded(settingsModel: termsPrivacyResponse.data));
    } else if(listData[2] == WEB_SERVICE_ENUM.success) {
      emit(SettingsError(errorCode: listData[2]));
    }
  }
}
