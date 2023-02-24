
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/config/settings.dart';
import 'package:lifestep/features/tools/config/endpoints.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/data/models/auth/profile.dart';
import 'package:lifestep/features/main_app/data/models/settings/model.dart';
import 'package:lifestep/features/main_app/data/models/settings/version_check.dart';
import 'package:lifestep/features/main_app/presentation/pages/apploading/logic/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/main_app/resources/static.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

import 'package:lifestep/features/tools/config/get_it.dart';


class ApploadingCubit extends Cubit<ApploadingState> {
  final UserRepository authRepo;
  final IStaticRepository staticRepository;
  ApploadingCubit({required this.authRepo, required this.staticRepository, }) : super(ApploadingLoading()) {
    builderData();
  }

  Future<void> builderData() async {
    int isConnectedToWeb;
    bool isLogin = false;
    bool isError = false;
    // bool isPermission = false;
    UserModel? userModel;
    String? errorText = '';
    String? playerId = '';
    String language = 'az';
    bool inMaintenance = false;
    bool hasUpdate = false;
    bool isRequiredUpdate = false;
    // await Future.delayed(const Duration(seconds: 1));
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('language')) {
      if(Platform.localeName.contains('ru')){
        await pref.setString('language', 'ru');
        languageGlobal = 'ru';
        // }else if(Platform.localeName.contains('en')){
        //   await pref.setString('language', 'en');
        //   languageGlobal = 'en';
      }else{
        await pref.setString('language', 'az');
        languageGlobal = 'az';
      }
    }else {
    }


    // if (pref.containsKey('token')) {
      // TOKEN = pref.getString('token');
      // sl<Settings>().accessToken = pref.getString('token') ?? '';
      // print("TOKEN = ${TOKEN}");
      // log("TOKEN = ${sl<Settings>().accessToken}");
    // }

    if(sl<Settings>().fcmToken != ''){
      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        // pref.setString('player_id', fcmToken!);
        sl<Settings>().fcmToken = fcmToken ?? '';
        playerId = fcmToken;
      }catch(_){
      }
    }else{
      playerId = sl<Settings>().fcmToken;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnectedToWeb = 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnectedToWeb = 1;
    } else {
      isConnectedToWeb = 0;
    }

    if (connectivityResult == ConnectivityResult.mobile) {
      isConnectedToWeb = 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnectedToWeb = 1;
    } else {
      isConnectedToWeb = 0;
    }






    if (isConnectedToWeb == 1 && sl<Settings>().accessToken != '') {
      try {

        final data = await authRepo.getUser(extraUrl: sprintf("?player_id=%s&os=%s&app_version=%s", [playerId ?? '', Platform.isIOS ? 1 : 2, Platform.isIOS ? MainConfig.appVersionIos : MainConfig.appVersionAndroid, ]));

        switch (data[2]) {
          case WEB_SERVICE_ENUM.success:
            {

              ProfileResponse loginResponse = ProfileResponse.fromJson(data[1]);
              userModel = loginResponse.data;
              isLogin = true;
            }
            break;
          case WEB_SERVICE_ENUM.unAuth:
            {
              isLogin = false;
            }
            break;
          case WEB_SERVICE_ENUM.internetError:
            {
              isConnectedToWeb = 0;
            }
            break;
          default:
            {
              isError = true;
              errorText = data[1];
            }
            break;
        }
      } on Exception catch (_) {
        isError = true;
      }
    }
    if (isConnectedToWeb == 1) {
      try {

        final data3 = await staticRepository.checkUpdate();

        switch (data3[2]) {
          case WEB_SERVICE_ENUM.success:
            {

              VersionCheckResponse versionCheckResponse = VersionCheckResponse.fromJson(data3[1]);
              if(versionCheckResponse.data != null && versionCheckResponse.data!.appVersion != null && versionCheckResponse.data!.isRequired != null){
                hasUpdate = versionCheckResponse.data!.appVersion! > (Platform.isAndroid ? MainConfig.appVersionAndroid : MainConfig.appVersionIos);
                isRequiredUpdate = hasUpdate ? (versionCheckResponse.data!.isRequired! == 1) : false;
              }
            }
            break;
          case WEB_SERVICE_ENUM.internetError:
            {
              isConnectedToWeb = 0;
            }
            break;
          default:
            {
              isError = true;
              errorText = data3[1];
            }
            break;
        }
      } on Exception catch (_) {
        isError = true;
      }
    }
    if (isConnectedToWeb == 1) {
      try {

        final data3 = await staticRepository.getSettings();

        switch (data3[2]) {
          case WEB_SERVICE_ENUM.success:
            {

              SettingsResponse  settingsResponse = SettingsResponse.fromJson(data3[1]);
              inMaintenance = settingsResponse.data != null && settingsResponse.data!.maintenance == 1;
            }
            break;
          case WEB_SERVICE_ENUM.internetError:
            {
              isConnectedToWeb = 0;
            }
            break;
          default:
            {
              isError = true;
              errorText = data3[1];
            }
            break;
        }
      } on Exception catch (_) {
        isError = true;
      }
    }
    // LOGIN_BOOL = isLogin;
    emit(ApploadingResult(result: AppLoadingModel(
        pref: pref,
        isConnectedToWeb: isConnectedToWeb,
        inMaintenance: inMaintenance,
        isPermission: true,
        // isPermission: await Utils.checkPermissions(),
        isLogin: isLogin,
        errorText: errorText,
        language: language,
        isError: isError,
        userModel: userModel,
        hasUpdate: hasUpdate,
        isRequiredUpdate: isRequiredUpdate,
    )));
  }


}


class AppLoadingModel {
  final SharedPreferences pref;
  final int isConnectedToWeb;
  final String? language;
  final String? errorText;
  final bool isError;
  final bool isLogin;
  final bool isPermission;
  final bool hasUpdate;
  final bool isRequiredUpdate;
  final bool inMaintenance;
  final UserModel? userModel;

  AppLoadingModel({required this.pref, required this.isConnectedToWeb, this.language, this.errorText, required this.isError, required this.isLogin, required this.isPermission, this.userModel, required this.hasUpdate, required this.inMaintenance, required this.isRequiredUpdate, });
}