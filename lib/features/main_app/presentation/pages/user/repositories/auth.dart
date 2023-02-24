import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

class UserRepository {
  final userProvider = UserProvider();

  Future<List> logoutUser() => userProvider.logoutUser();

  Future<List> loginWithCredential({required String phone}) => userProvider.loginWithCredential(phone);
  Future<List> registerUser({required Map<String, dynamic> data, required Map<String, dynamic> header, String? extraUrl}) => userProvider.registerUser(data, header, extraUrl: extraUrl);
  Future<List> editUser({required Map<String, dynamic> data, Map<String, dynamic>? header}) => userProvider.editUser(data, header);
  Future<List> loginOtp({required Map<String, dynamic> data, required Map<String, dynamic> header}) => userProvider.checkOtp(data, header);
  Future<List> deleteOtp({required Map<String, dynamic> data}) => userProvider.deleteOtp(data);
  Future<List> deleteUser({required Map<String, dynamic> data}) => userProvider.deleteUser(data);

  Future<List> getUser({String? extraUrl}) => userProvider.getUser(extraUrl: extraUrl);
  Future<List> getAchievements({required CancelToken token}) => userProvider.getAchievements(token);
  Future<List> getNotifications({required int pageValue, required CancelToken token}) => userProvider.getNotifications(pageValue, token);
  Future<List> getStepInfo({required CancelToken token}) => userProvider.getStepInfo(token);
  Future<List> setStepInfo({required Map<String, dynamic> data, required CancelToken token}) => userProvider.setStepInfo(data,token);
  Future<List> setStepInfo2({required Map<String, dynamic> data, required CancelToken token}) => userProvider.setStepInfo2(data,token);
  Future<List> getAchievementsControlInfo({required CancelToken token}) => userProvider.getAchievementsControlInfo(token);
  Future<List> getDailyStepInfo({required CancelToken token}) => userProvider.getDailyStepInfo(token);
  Future<List> getDailyStepInfo2({required CancelToken token}) => userProvider.getDailyStepInfo2(token);
  Future<List> setDailyStepInfo({required Map<String, dynamic> data, required CancelToken token}) => userProvider.setDailyStepInfo(data,token);
  Future<List> setDailyStepInfo2({required Map<String, dynamic> data, required CancelToken token}) => userProvider.setDailyStepInfo2(data,token);
  Future<List> socialLogin({required Map<String, dynamic> data, required CancelToken token}) => userProvider.socialLogin(data,token);



}

class LoginResponseText {
  bool? code;
  String? text;
}

class UserProvider {


  Future<List> logoutUser() async {

      String requestUrl = EndpointConfig.logout;
      List data = await WebService.postCall(
          url: requestUrl,
          data: {}
      );
      return data;
  }

  Future<List> getUser({String? extraUrl}) async {
    String requestUrl = EndpointConfig.getUser + (extraUrl ?? '');
    log(requestUrl);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> getAchievements(CancelToken dioToken) async {
    String requestUrl = EndpointConfig.achievements;
    // String requestUrl = "https://app.lifestep.az/api/charities/0/10?search=";
    List data = await WebService.getCall(url: requestUrl,
    token: dioToken);
    return data;
  }

  Future<List> getNotifications(int pageValue, CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = sprintf(EndpointConfig.notifications, [MainConfig.mainAppDataCount * (pageValue - 1), MainConfig.mainAppDataCount]);
    List data = await WebService.getCall(url: requestUrl,
    token: dioToken);
    return data;
  }

  Future<List> loginWithCredential(String phone) async {
    String requestUrl = EndpointConfig.login;
    List data = await WebService.postCall(url: requestUrl,
    data: {
      'phone': phone
    }
  );
    // print(data);
    return data;
  }

  Future<List> registerUser(Map<String, dynamic> requestData, Map<String, dynamic> header, {String? extraUrl}) async {
    String requestUrl = EndpointConfig.registration + (extraUrl ?? '');
    List data = await WebService.postCall(url: requestUrl, headers: header,
    data: requestData
  );
    return data;
  }


  Future<List> editUser(Map<String, dynamic> requestData, Map<String, dynamic>? header) async {
    String requestUrl = EndpointConfig.editUser;
    List data = await WebService.postCall(url: requestUrl, headers: header,
    data: requestData
  );
    return data;
  }


  Future<List> checkOtp(Map<String, dynamic> mainData, Map<String, dynamic> header) async {
    String requestUrl = EndpointConfig.confirm;
    List data = await WebService.postCall(url: requestUrl, headers: header,
    data: mainData
  );
    // print(data);
    return data;
  }

  Future<List> deleteOtp(Map<String, dynamic> requestData) async {
    String requestUrl = EndpointConfig.deleteConfirmOtp;
    List data = await WebService.deleteCall(url: requestUrl,data: requestData
    );
    return data;
  }

  Future<List> deleteUser(Map<String, dynamic> requestData) async {
    String requestUrl = EndpointConfig.deleteUserUrl;
    List data = await WebService.postCall(url: requestUrl, data: requestData
    );
    return data;
  }

  Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    return true;
  }



  Future<List> getStepInfo(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = EndpointConfig.stepInfo;
    List data = await WebService.getCall(url: requestUrl, token: dioToken);
    return data;
  }

  Future<List> setStepInfo(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = EndpointConfig.setStepInfo;
    List data = await WebService.postCall(url: requestUrl, data: requestData
    );
    return data;
  }

  Future<List> setStepInfo2(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = EndpointConfig.setStepInfo2;
    List data = await WebService.postCall(url: requestUrl, data: requestData
    );
    return data;
  }

  Future<List> getDailyStepInfo(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = EndpointConfig.stepDailyInfo;
    List data = await WebService.getCall(url: requestUrl, token: dioToken);
    return data;
  }

  Future<List> getAchievementsControlInfo(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = EndpointConfig.userAchievementsControl;
    List data = await WebService.getCall(url: requestUrl, token: dioToken);
    return data;
  }

  Future<List> getDailyStepInfo2(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = EndpointConfig.stepDailyInfo2;
    List data = await WebService.getCall(url: requestUrl, token: dioToken);
    return data;
  }

  Future<List> setDailyStepInfo(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = EndpointConfig.setStepDailyInfo;
   // print("setDailyStepInfo = ${requestUrl}");
   // print("setDailyStepInfo = ${requestUrl}");
   // print(requestData);
    List data = await WebService.postCall(url: requestUrl, data: requestData
    );
    // print(data);
    return data;
  }


  Future<List> setDailyStepInfo2(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = EndpointConfig.setStepDailyInfo2;
    List data = await WebService.postCall(url: requestUrl, data: requestData);
    return data;
  }


  Future<List> socialLogin(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = EndpointConfig.socialLogin;
    List data = await WebService.postCall(url: requestUrl, data: requestData
    );
    return data;
  }


}
