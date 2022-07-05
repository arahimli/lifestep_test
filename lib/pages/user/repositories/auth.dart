import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

class UserRepository {
  final userProvider = UserProvider();
  //
  // Future<LoginResponse> loginUser(String email, String password) =>
  //     userProvider.loginUser(email, password);

  //
  // Future<LoginResponse> loginSocial(String token, String loginSocial, String email) =>
  //     userProvider.loginSocial(token, loginSocial, email);
  //
  // Future<RegistrationResponse> registerUser(String firstName, String lastName,
  //     String telephone, String email, String password) =>
  //     userProvider.registerUser(
  //         firstName, lastName, telephone, email, password);
  //
  // Future<MainResponseData> setProfilePhoto(File file) =>
  //     userProvider.setProfilePhoto(file);


  Future<List> logoutUser() => userProvider.logoutUser();

  Future<List> loginWithCredential({required String phone}) => userProvider.loginWithCredential(phone);
  Future<List> registerUser({required Map<String, dynamic> data, required Map<String, dynamic> header}) => userProvider.registerUser(data, header);
  Future<List> editUser({required Map<String, dynamic> data, Map<String, dynamic>? header}) => userProvider.editUser(data, header);
  Future<List> loginOtp({required Map<String, dynamic> data, required Map<String, dynamic> header}) => userProvider.checkOtp(data, header);

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

      String requestUrl = LOGOUT_URL;
      List data = await WebService.postCall(
          url: requestUrl,
          headers: {
            'Authorization': "Bearer $TOKEN",
            'Accept-Language': LANGUAGE,
            'Accept': 'application/json'
          },
          data: {}
      );
      return data;
  }

  Future<List> getUser({String? extraUrl}) async {
    String requestUrl = GET_USER_URL + (extraUrl ?? '');
    print(requestUrl);
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    });
    return data;
  }

  Future<List> getAchievements(CancelToken dioToken) async {
    String requestUrl = ACHIEVEMENTS_URL;
    // String requestUrl = "https://app.lifestep.az/api/charities/0/10?search=";
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
    token: dioToken);
    return data;
  }

  Future<List> getNotifications(int pageValue, CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = sprintf(NOTIFICATIONS_URL, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count]);
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
    token: dioToken);
    return data;
  }

  Future<List> loginWithCredential(String phone) async {
    String requestUrl = LOGIN_URL;
    List data = await WebService.postCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
    data: {
      'phone': phone
    }
  );
    return data;
  }

  Future<List> registerUser(Map<String, dynamic> requestData, Map<String, dynamic> header) async {
    String requestUrl = REGISTRATION_URL;
    List data = await WebService.postCall(url: requestUrl, headers: header,
    data: requestData
  );
    return data;
  }


  Future<List> editUser(Map<String, dynamic> requestData, Map<String, dynamic>? header) async {
    String requestUrl = EDIT_USER_URL;
    List data = await WebService.postCall(url: requestUrl, headers: header,
    data: requestData
  );
    return data;
  }


  Future<List> checkOtp(Map<String, dynamic> mainData, Map<String, dynamic> header) async {
    String requestUrl = CONFIRM_OTP_URL;
    List data = await WebService.postCall(url: requestUrl, headers: header,
    data: mainData
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
    String requestUrl = STEP_INFO_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
        token: dioToken);
    return data;
  }

  Future<List> setStepInfo(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = SET_STEP_INFO_URL;
    List data = await WebService.postCall(url: requestUrl,
      headers: {
        'Authorization': "Bearer $TOKEN",
        'Accept-Language': LANGUAGE,
        'Accept': 'application/json'
      },
      data: requestData
    );
    return data;
  }

  Future<List> setStepInfo2(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = SET_STEP_INFO_URL2;
    List data = await WebService.postCall(url: requestUrl,
      headers: {
        'Authorization': "Bearer $TOKEN",
        'Accept-Language': LANGUAGE,
        'Accept': 'application/json'
      },
      data: requestData
    );
    return data;
  }

  Future<List> getDailyStepInfo(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = STEP_DAILY_INFO_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
        token: dioToken);
    return data;
  }

  Future<List> getAchievementsControlInfo(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = USER_ACHIEVEMENTS_CONTROL_INFO_URL;
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
        token: dioToken);
    return data;
  }

  Future<List> getDailyStepInfo2(CancelToken dioToken) async {
    // String requestUrl = FOND_USERS_URL;
    String requestUrl = STEP_DAILY_INFO_URL2;
    List data = await WebService.getCall(url: requestUrl, headers: {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json'
    },
        token: dioToken);
    return data;
  }

  Future<List> setDailyStepInfo(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = SET_STEP_DAILY_INFO_URL;
   ///////// print("setDailyStepInfo = ${requestUrl}");
    List data = await WebService.postCall(url: requestUrl,
      headers: {
        'Authorization': "Bearer $TOKEN",
        'Accept-Language': LANGUAGE,
        'Accept': 'application/json'
      },
      data: requestData
    );
    return data;
  }


  Future<List> setDailyStepInfo2(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = SET_STEP_DAILY_INFO_URL2;
   ///////// print("setDailyStepInfo = ${requestUrl}");
    List data = await WebService.postCall(url: requestUrl,
      headers: {
        'Authorization': "Bearer $TOKEN",
        'Accept-Language': LANGUAGE,
        'Accept': 'application/json'
      },
      data: requestData
    );
    return data;
  }


  Future<List> socialLogin(Map<String, dynamic> requestData, CancelToken dioToken) async {
    String requestUrl = SOCIAL_LOGIN_URL;
    List data = await WebService.postCall(url: requestUrl,
      headers: {
        'Authorization': "Bearer $TOKEN",
        'Accept-Language': LANGUAGE,
        'Accept': 'application/json'
      },
      data: requestData
    );
    return data;
  }


}
