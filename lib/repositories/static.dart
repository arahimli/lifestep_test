import 'dart:io';

import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class StaticRepository {
  final staticProvider = StaticProvider();



  Future<List> getTermsPrivacy() => staticProvider.getTermsPrivacy();
  Future<List> getSettings() => staticProvider.getSettings();
  Future<List> checkUpdate() => staticProvider.checkUpdate();

}



class StaticProvider {

  Future<List> getTermsPrivacy() async {
    String requestUrl = TERMS_PRIVACY_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    });
    return data;
  }
  Future<List> getSettings() async {
    String requestUrl = SETTINGS_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    });
    return data;
  }

  Future<List> checkUpdate() async {
    String requestUrl = sprintf(APP_VERSION_CHECK_URL, [Platform.isAndroid ? 2 : 1, Platform.isAndroid ? MainConfig.app_version_android : MainConfig.app_version_ios]);
 ////// print(requestUrl);
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    });
    return data;
  }
}


