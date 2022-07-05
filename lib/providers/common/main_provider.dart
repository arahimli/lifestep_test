import 'package:flutter/foundation.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/repositories/common/main_repository.dart';

class MainProvider extends ChangeNotifier {
  MainProvider(this.mainRepository, int limit) {
    if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  MainRepository mainRepository;

  int offset = 0;
  int limit = MainConfig.DEFAULT_LOADING_LIMIT;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
    await mainRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
    await mainRepository.replaceLoginUserId(loginUserId);
  }

  Future<void> replaceLoginUserName(String loginUserName) async {
    await mainRepository.replaceLoginUserName(loginUserName);
  }

  Future<void> replaceNotiToken(String notiToken) async {
    await mainRepository.replaceNotiToken(notiToken);
  }

  Future<void> replaceNotiSetting(bool notiSetting) async {
    await mainRepository.replaceNotiSetting(notiSetting);
  }

  Future<void> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await mainRepository.replaceIsToShowIntroSlider(doNotShowAgain);
  }

  Future<void> replaceDate(String startDate, String endDate) async {
    await  mainRepository.replaceDate(startDate, endDate);
  }

  Future<void> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await mainRepository.replaceVerifyUserData(userIdToVerify, userNameToVerify,
        userEmailToVerify, userPasswordToVerify);
  }

  Future<void> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await mainRepository.replaceVersionForceUpdateData(appInfoForceUpdate);
  }

  Future<void> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await mainRepository.replaceAppInfoData(appInfoVersionNo, appInfoForceUpdate,
        appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }


  Future<void> replacePublishKey(String pubKey) async {
    await mainRepository.replacePublishKey(pubKey);
  }

  Future<void> replacePayStackKey(String payStackKey) async {
    await mainRepository.replacePayStackKey(payStackKey);
  }
}