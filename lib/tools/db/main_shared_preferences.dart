import 'dart:async';
import 'package:lifestep/tools/common/main_value_holder.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/main_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainSharedPreferences {
  MainSharedPreferences._() {
    Utils.psPrint('init PsSharePerference $hashCode');
    futureShared = SharedPreferences.getInstance();
    futureShared!.then((SharedPreferences shared) {
      this.shared = shared;
      //loadUserId('Admin');
      loadValueHolder();
    });
  }


  Future<SharedPreferences>? futureShared;
  SharedPreferences? shared;

// Singleton instance
  static final MainSharedPreferences _singleton = MainSharedPreferences._();

  // Singleton accessor
  static MainSharedPreferences get instance => _singleton;

  final StreamController<MainValueHolder> _valueController =
  StreamController<MainValueHolder>();
  Stream<MainValueHolder> get mainValueHolder => _valueController.stream;

  Future<dynamic> loadValueHolder() async{
    final String? _loginUserId = shared!.getString(MainConst.VALUE_HOLDER__USER_ID);
    final String? _loginUserName =
    shared!.getString(MainConst.VALUE_HOLDER__USER_NAME);
    final String? _userIdToVerify =
    shared!.getString(MainConst.VALUE_HOLDER__USER_ID_TO_VERIFY);
    final String? _userNameToVerify =
    shared!.getString(MainConst.VALUE_HOLDER__USER_NAME_TO_VERIFY);
    final String? _userEmailToVerify =
    shared!.getString(MainConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY);
    final String? _userPasswordToVerify =
    shared!.getString(MainConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY);
    final String? _notiToken =
    shared!.getString(MainConst.VALUE_HOLDER__NOTI_TOKEN);
    final bool? _notiSetting =
    shared!.getBool(MainConst.VALUE_HOLDER__NOTI_SETTING);
    final bool _isToShowIntroSlider =
        shared!.getBool(MainConst.VALUE_HOLDER__SHOW_INTRO_SLIDER) ?? true;
    final String? _overAllTaxLabel =
    shared!.getString(MainConst.VALUE_HOLDER__OVERALL_TAX_LABEL);
    final String? _overAllTaxValue =
    shared!.getString(MainConst.VALUE_HOLDER__OVERALL_TAX_VALUE);
    final String? _shippingTaxLabel =
    shared!.getString(MainConst.VALUE_HOLDER__SHIPPING_TAX_LABEL);
    final String? _shippingTaxValue =
    shared!.getString(MainConst.VALUE_HOLDER__SHIPPING_TAX_VALUE);
    final String? _shippingId =
    shared!.getString(MainConst.VALUE_HOLDER__SHIPPING_ID);
    final String?  _shopId = shared!.getString(MainConst.VALUE_HOLDER__SHOP_ID);
    final String? _messenger = shared!.getString(MainConst.VALUE_HOLDER__MESSENGER);
    final String? _whatsApp = shared!.getString(MainConst.VALUE_HOLDER__WHATSAPP);
    final String? _phone = shared!.getString(MainConst.VALUE_HOLDER__PHONE);
    final String? _appInfoVersionNo =
    shared!.getString(MainConst.APPINFO_PREF_VERSION_NO);
    final bool? _appInfoForceUpdate =
    shared!.getBool(MainConst.APPINFO_PREF_FORCE_UPDATE);
    final String? _appInfoForceUpdateTitle =
    shared!.getString(MainConst.APPINFO_FORCE_UPDATE_TITLE);
    final String? _appInfoForceUpdateMsg =
    shared!.getString(MainConst.APPINFO_FORCE_UPDATE_MSG);
    final String? _startDate =
    shared!.getString(MainConst.VALUE_HOLDER__START_DATE);
    final String? _endDate = shared!.getString(MainConst.VALUE_HOLDER__END_DATE);

    final String? _codEnabled =
    shared!.getString(MainConst.VALUE_HOLDER__COD_ENABLED);
    final String? _publishKey =
    shared!.getString(MainConst.VALUE_HOLDER__NO_SHIPPING_ENABLE);
    final MainValueHolder _valueHolder = MainValueHolder(
      loginUserId: _loginUserId,
      loginUserName: _loginUserName,
      userIdToVerify: _userIdToVerify,
      userNameToVerify: _userNameToVerify,
      userEmailToVerify: _userEmailToVerify,
      userPasswordToVerify: _userPasswordToVerify,
      deviceToken: _notiToken,
      notiSetting: _notiSetting,
      isToShowIntroSlider: _isToShowIntroSlider,
      overAllTaxLabel: _overAllTaxLabel,
      overAllTaxValue: _overAllTaxValue,
      shippingTaxLabel: _shippingTaxLabel,
      shippingTaxValue: _shippingTaxValue,
      shopId: _shopId,
      messenger: _messenger,
      whatsApp: _whatsApp,
      phone: _phone,
      appInfoVersionNo: _appInfoVersionNo,
      appInfoForceUpdate: _appInfoForceUpdate,
      appInfoForceUpdateTitle: _appInfoForceUpdateTitle,
      appInfoForceUpdateMsg: _appInfoForceUpdateMsg,
      startDate: _startDate,
      endDate: _endDate,
      codEnabled: _codEnabled,
      publishKey: _publishKey,
      shippingId: _shippingId,
    );

    _valueController.add(_valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared!.setString(MainConst.VALUE_HOLDER__USER_ID, loginUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await shared!.setString(MainConst.VALUE_HOLDER__USER_NAME, loginUserName);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await shared!.setString(MainConst.VALUE_HOLDER__NOTI_TOKEN, notiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await shared!.setBool(MainConst.VALUE_HOLDER__NOTI_SETTING, notiSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await shared!.setBool(MainConst.VALUE_HOLDER__SHOW_INTRO_SLIDER, doNotShowAgain);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiMessage(String message) async {
    await shared!.setString(MainConst.VALUE_HOLDER__NOTI_MESSAGE, message);
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await shared!.setString(MainConst.VALUE_HOLDER__START_DATE, startDate);
    await shared!.setString(MainConst.VALUE_HOLDER__END_DATE, endDate);

    loadValueHolder();
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await shared!.setString(
        MainConst.VALUE_HOLDER__USER_ID_TO_VERIFY, userIdToVerify);
    await shared!.setString(
        MainConst.VALUE_HOLDER__USER_NAME_TO_VERIFY, userNameToVerify);
    await shared!.setString(
        MainConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY, userEmailToVerify);
    await shared!.setString(
        MainConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY, userPasswordToVerify);

    loadValueHolder();
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await shared!.setBool(MainConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);

    loadValueHolder();
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await shared!.setString(MainConst.APPINFO_PREF_VERSION_NO, appInfoVersionNo);
    await shared!.setBool(MainConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);
    await shared!.setString(
        MainConst.APPINFO_FORCE_UPDATE_TITLE, appInfoForceUpdateTitle);
    await shared!.setString(
        MainConst.APPINFO_FORCE_UPDATE_MSG, appInfoForceUpdateMsg);

    loadValueHolder();
  }


  Future<dynamic> replacePublishKey(String pubKey) async {
    await shared!.setString(MainConst.VALUE_HOLDER__PUBLISH_KEY, pubKey);

    loadValueHolder();
  }

  Future<dynamic> replacePayStackKey(String payStackKey) async {
    await shared!.setString(MainConst.VALUE_HOLDER__PAYSTACK_KEY, payStackKey);

    loadValueHolder();
  }
}