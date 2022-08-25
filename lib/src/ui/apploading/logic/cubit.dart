import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/models/settings/model.dart';
import 'package:lifestep/src/models/settings/version_check.dart';
import 'package:lifestep/src/ui/apploading/logic/state.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/resources/static.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';


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
    bool isPermission = false;
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
        LANGUAGE = 'ru';
        // }else if(Platform.localeName.contains('en')){
        //   await pref.setString('language', 'en');
        //   LANGUAGE = 'en';
      }else{
        await pref.setString('language', 'az');
        LANGUAGE = 'az';
      }
    }else {
      //////// print("LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_121");
    }
    //////// print("LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_121-v2");


    if (pref.containsKey('token')) {
      TOKEN = pref.getString('token');
      print("TOKEN = ${TOKEN}");
    }

    if(!pref.containsKey('player_id')){
      try {
        String? fcm_token = await FirebaseMessaging.instance.getToken();
        pref.setString('player_id', fcm_token!);
        playerId = fcm_token;
        // print("playerId = 2 ${playerId}");
      }catch(e){
        //////// print(e);
      }
    }else{
      playerId = pref.getString('player_id');
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnectedToWeb = 1;
      //////// print('mobile');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnectedToWeb = 1;
      //////// print('wifi');
    } else {
      isConnectedToWeb = 0;
      //////// print('wifi');
    }

    if (connectivityResult == ConnectivityResult.mobile) {
      isConnectedToWeb = 1;
      //////// print('mobile');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnectedToWeb = 1;
      //////// print('wifi');
    } else {
      isConnectedToWeb = 0;
      //////// print('wifi');
    }





    //////// print("LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_121-v7");

    if (isConnectedToWeb == 1 && TOKEN != null && TOKEN != '') {
      try {

        final data = await authRepo.getUser(extraUrl: sprintf("?player_id=%s&os=%s&app_version=%s", [playerId ?? '', Platform.isIOS ? 1 : 2, Platform.isIOS ? MainConfig.app_version_ios : MainConfig.app_version_android, ]));

        // print("playerId = ${playerId}");
        // print(data);
        switch (data[2]) {
          case WEB_SERVICE_ENUM.SUCCESS:
            {

              ProfileResponse loginResponse = ProfileResponse.fromJson(data[1]);
              userModel = loginResponse.data;
              isLogin = true;
            }
            break;
          case WEB_SERVICE_ENUM.UN_AUTH:
            {
              isLogin = false;
            }
            break;
          case WEB_SERVICE_ENUM.INTERNET_ERROR:
            {
              isConnectedToWeb = 0;
            }
            break;
          default:
            {
             // print("ErrorHappenedState(errorText:");
             // print("------------------ general e ------------------");
             // print(data[2]);
              isError = true;
              errorText = data[1];
            }
            break;
        }
      } on Exception catch (e) {
        //////// print("------------------ general e ------------------");
        isError = true;
      }
    }
    if (isConnectedToWeb == 1) {
      try {

        final data3 = await staticRepository.checkUpdate();

     ////// print("checkUpdate___");
     ////// print(data3[2]);
     ////// print(data3[0]);
        switch (data3[2]) {
          case WEB_SERVICE_ENUM.SUCCESS:
            {

              VersionCheckResponse versionCheckResponse = VersionCheckResponse.fromJson(data3[1]);
              if(versionCheckResponse.data != null && versionCheckResponse.data!.appVersion != null && versionCheckResponse.data!.isRequired != null){
                hasUpdate = versionCheckResponse.data!.appVersion! > (Platform.isAndroid ? MainConfig.app_version_android : MainConfig.app_version_ios);
                isRequiredUpdate = hasUpdate ? (versionCheckResponse.data!.isRequired! == 1) : false;
              }
            }
            break;
          case WEB_SERVICE_ENUM.INTERNET_ERROR:
            {
              isConnectedToWeb = 0;
            }
            break;
          default:
            {
             // print("ErrorHappenedState(errorText:");
             // print("------------------ general e ------------------");
             // print(data[2]);
              isError = true;
              errorText = data3[1];
            }
            break;
        }
      } on Exception catch (e) {
     ////// print("------------------ general e ------------------");
        isError = true;
      }
    }
    if (isConnectedToWeb == 1) {
      try {

        final data3 = await staticRepository.getSettings();

     ////// print("checkUpdate___");
     ////// print(data3[2]);
     ////// print(data3[0]);
        switch (data3[2]) {
          case WEB_SERVICE_ENUM.SUCCESS:
            {

              SettingsResponse  settingsResponse = SettingsResponse.fromJson(data3[1]);
              inMaintenance = settingsResponse.data != null && settingsResponse.data!.maintenance == 1;
            }
            break;
          case WEB_SERVICE_ENUM.INTERNET_ERROR:
            {
              isConnectedToWeb = 0;
            }
            break;
          default:
            {
             // print("ErrorHappenedState(errorText:");
             // print("------------------ general e ------------------");
             // print(data[2]);
              isError = true;
              errorText = data3[1];
            }
            break;
        }
      } on Exception catch (e) {
     ////// print("------------------ general e ------------------");
        isError = true;
      }
    }
    // LOGIN_BOOL = isLogin;
    // print("return_AppLoadingModel");
    // print(isConnectedToWeb);
    // print(isConnectedToWeb);
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