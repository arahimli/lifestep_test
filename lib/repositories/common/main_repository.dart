import 'package:lifestep/tools/db/main_shared_preferences.dart';

class MainRepository {
  Future<dynamic> loadValueHolder() async{
    await MainSharedPreferences.instance.loadValueHolder();
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async{
    await MainSharedPreferences.instance.replaceLoginUserId(
      loginUserId,
    );
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async{
    await MainSharedPreferences.instance.replaceLoginUserName(
      loginUserName,
    );
  }

  Future<dynamic> replaceNotiToken(String notiToken) async{
    await MainSharedPreferences.instance.replaceNotiToken(
      notiToken,
    );
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async{
    await MainSharedPreferences.instance.replaceNotiSetting(
      notiSetting,
    );
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await MainSharedPreferences.instance.replaceIsToShowIntroSlider(
      doNotShowAgain,
    );
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async{
    await MainSharedPreferences.instance.replaceDate(startDate, endDate);
  }

  Future<dynamic> replaceVerifyUserData(String userIdToVerify, String userNameToVerify,
      String userEmailToVerify, String userPasswordToVerify) async{
    await MainSharedPreferences.instance.replaceVerifyUserData(userIdToVerify,
        userNameToVerify, userEmailToVerify, userPasswordToVerify);
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async{
    await MainSharedPreferences.instance.replaceVersionForceUpdateData(
      appInfoForceUpdate,
    );
  }

  Future<dynamic> replaceAppInfoData(String appInfoVersionNo, bool appInfoForceUpdate,
      String appInfoForceUpdateTitle, String appInfoForceUpdateMsg) async{
    await MainSharedPreferences.instance.replaceAppInfoData(appInfoVersionNo,
        appInfoForceUpdate, appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }


  Future<dynamic> replacePublishKey(String pubKey)async{
    await MainSharedPreferences.instance.replacePublishKey(pubKey);
  }


  Future<dynamic> replacePayStackKey(String payStackKey) async{
    await MainSharedPreferences.instance.replacePayStackKey(payStackKey);
  }
}