import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health/health.dart';
import 'package:lifestep/src/tools/components/buttons/advanced_button.dart';
import 'package:lifestep/src/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/src/tools/components/common/confetti.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/models/challenge/map.dart';
import 'package:lifestep/src/tools/constants/health/element.dart';
import 'package:lifestep/src/ui/index/logic/navigation_bloc.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/tools/packages/humanize/humanize_big_int_base.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class Utils {
  Utils._();

  static String getString(BuildContext context, String key) {
    if (key != '') {
      return tr(key);
    } else {
      return '';
    }
  }
  static String getStringWithoutContext(String? key) {
    if (key != '') {
      return tr(key!);
    } else {
      return '';
    }
  }

  static Future<String> getPlayerId() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String playerId = '';
    if(!pref.containsKey('player_id')){
      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        pref.setString('player_id', fcmToken!);
        playerId = fcmToken;
        // print("playerId = 2 ${playerId}");
      }catch(e){
        //////// print(e);
      }
    }else{
      playerId = pref.getString('player_id') ?? '';
    }
    return playerId;
  }

  static dynamic getListMapDisplay(String value, List<Map<String, dynamic>> dataMap, {String key = "keyword", String valueKey = "display"}) {
    try {
      List<Map<String, dynamic>> listResult = dataMap.where((map) =>
      value == map[key].toString()).toList();
      if (listResult.isNotEmpty) {
        return listResult.first[valueKey];
      }
      return '';
    }catch(e){
      return '';
    }
  }

  static dynamic getListMapKey(String value, List<Map<String, dynamic>> dataMap, {String key = "keyword", String valueKey = "key"}) {
    try {
      List<Map<String, dynamic>> listResult = dataMap.where((map) =>
      value == map[key].toString()).toList();
      if (listResult.isNotEmpty) {
        return listResult.first[valueKey];
      }
      return '';
    }catch(e){
      return '';
    }
  }

  static double parseDouble(String value) {
    try{
      return double.parse(value);
    }catch(_){
      return 0.0;
    }
  }

  static void focusClose(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Color hexToColor(String hexColor) {
    try{
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor;
      }
      if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      }else{
        return Color(0xFFFFFFFF);
      }
    }catch(_){
      return Color(0xFFFFFFFF);
    }
  }



  static Color selectInputColor(Map<String, dynamic> dataMap, String key) {
    try{
      return dataMap[key] ?? Color(0xFFE5EAF5);
      // return dataMap[key] ?? MainColors.generalBackgorundColor;
    }catch(_){
      return Color(0xFFE5EAF5);
    }
  }

  static String humanizeDouble(BuildContext context, double value) {
    try{
      double newValue = Utils.roundNumber(value);
      if(newValue.toString().length > 5){
        return "${humanizeInt(context, value.round()).toLowerCase()}${newValue.toString().split('.')[0].length < 4 ? "."+newValue.toString().split('.')[1] : ''}";
      }else{
        return newValue.toString();
      }
    }catch(_){
      return '0';
    }
  }

  static String humanizeInteger(BuildContext context, int value) {
    try{
        return humanizeInt(context, value).toLowerCase();
    }catch(_){
      return '0';
    }
  }

  static String montToString(BuildContext context, int value) {
    try{
        return humanizeInt(context, value);
    }catch(_){
      return '0';
    }
  }


  static DateTime stringToDate({String? value, String format = "yyyy-MM-dd", DateTime? defaultDate}) {
    try{
      return DateFormat(format).parse(value!);
    }catch(_){
      return defaultDate ?? DateTime.now();
    }
  }


  static String stringToDatetoString({required String value, String formatFrom = "dd.MM.yyyy", String formatTo = "yyyy-MM-dd", DateTime? defaultDate}) {
    String returnVal = '';
    DateTime returnDate;
    final formatter2 = DateFormat(formatTo);
    try{
      returnDate =  DateFormat(formatFrom).parse(value);
    }catch(_){
      returnDate =  defaultDate ?? DateTime.now();
    }
    returnVal = formatter2.format(returnDate);

    return returnVal;
  }


  static String dateToString(DateTime defaultDate, {String format = "yyyy-MM-dd", String langCode = 'az'}) {
    String returnVal = '';
    final formatter = DateFormat(format, langCode);
    returnVal = formatter.format(defaultDate);

    return returnVal;
  }

  static TimeOfDay stringToTime({String? value}) {
    try{
      return TimeOfDay(hour: int.parse(value!.split(":")[0]), minute: int.parse(value.split(":")[1]));
    }catch(_){
      return TimeOfDay(hour: 00, minute: 00);
    }
  }
  static double stringToDouble({String? value}) {
    try{
      return double.parse(value!);
    }catch(_){
      return 0;
    }
  }

  static int stringToInt({String? value}) {
    try{
      return int.parse(value!);
    }catch(_){
      return 0;
    }
  }


  Future<List<int>> getDistanceBetweenPoints(LatLng startPosition, LatLng endPosition) async {
    // String reqUrl = sprintf('https://maps.googleapis.com/maps/api/distancematrix/json?origins=${startPosition.latitude},${startPosition.longitude}&destinations=${"40.454411"},${"49.738991"}&departure_time=now&key=%s', [MainConfig.main_map_api_key]);
    try {
      String reqUrl = sprintf(
          'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${startPosition
              .latitude},${startPosition.longitude}&destinations=${endPosition
              .latitude},${endPosition
              .longitude}&departure_time=now&mode=walking&key=%s',
          [MainConfig.main_map_api_key]);
      // //////// print(reqUrl);
      final response = await WebService.getCallHttp(
          url: reqUrl
      );
      //////// print(response);
      //////// print(response[1]);
      MapDistanceResponse mapDistanceResponse = MapDistanceResponse.fromJson(
          response[1]);
      // // //////// print(response[1]['rows'][0]['elements'][0]['duration']['text']);
      // // //////// print(
      // //     "RESPONSE DISTANCE AND TIME ${response[1]['rows'][0]['elements'][0]['duration_in_traffic']['value']}");
      return [
        mapDistanceResponse.rows![0].elements![0].distance!.value!,
        0
        // mapDistanceResponse.rows![0].elements![0].durationInTraffic!.value!,
      ];
    }catch(e){
      return [
        -1,
        -1,
      ];
    }
  }

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  // static String getDateFormat(String dateTime) {
  //   final DateTime date = DateTime.parse(dateTime);
  //   return DateFormat(MainConfig.dateFormat).format(date);
  // }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }
  static String generateLanguageHeader(String lang){
    String returnVal  = lang;
    if(lang.length == 2){
      if(lang == 'en')
        returnVal = "$returnVal-en";
      else
        returnVal = "$returnVal-$lang";
    }
    return returnVal;
  }

  // static String errorCodeToString(WEB_SERVICE_ENUM errorCode) {
  //   switch(errorCode){
  //     case WEB_SERVICE_ENUM.
  //   }
  // }

  static void launchPhone(String tel) {
    try{
      launch("tel:${tel}");
    }catch(_){

    }
  }



  static void launchUrl(String value) {
    try{
      launch(value.contains('http') ? value : "${SITE_URL}${value}");
    }catch(_){
    }
  }

  static void launchPlayStoreApp(String value) {
    try{
      launch(sprintf("https://play.google.com/store/apps/details?id=%s", [value]));
    }catch(_){
    }
  }

  static double roundNumber(double value, {int toPoint = 2}) {
    try{
      return double.parse((value).toStringAsFixed(toPoint));
    }catch(_){
      return 0.0;
    }
  }




  static double getDistanceByCoordinates({required LatLng fromCoordinate, required LatLng toCoordinate, }) {
    try{

      const double earthRadius = 6372.795477598;
      const double M_PI = 3.1415926;

      // перевести координаты в радианы
      double lat1 = fromCoordinate.latitude * M_PI / 180;
      double lat2 = toCoordinate.latitude * M_PI / 180;
      double long1 = fromCoordinate.longitude * M_PI / 180;
      double long2 = toCoordinate.longitude * M_PI / 180;

      // косинусы и синусы широт и разницы долгот
      double cl1 = math.cos(lat1);
      double cl2 = math.cos(lat2);
      double sl1 = math.sin(lat1);
      double sl2 = math.sin(lat2);
      double delta = long2 - long1;
      double cdelta = math.cos(delta);
      double sdelta = math.sin(delta);

      // вычисления длины большого круга
      double y = math.sqrt(math.pow(cl2 * sdelta, 2) + math.pow(cl1 * sl2 - sl1 * cl2 * cdelta, 2));
      double x = sl1 * sl2 + cl1 * cl2 * cdelta;

      double ad = math.atan2(y, x);
      double dist = ad * earthRadius;

      return dist;
    }catch(_){
      return 0.0;
    }
  }



  //
  // static DateTime? previous;
  // static void psPrint(String msg) {
  //   final DateTime now = DateTime.now();
  //   int min = 0;
  //   if (previous == null) {
  //     previous = now;
  //   } else {
  //     min = now.difference(previous!).inMilliseconds;
  //     previous = now;
  //   }
  //
  //   print('$now ($min)- $msg');
  // }


  static Future<bool> checkInternetConnectivity() async {
    final ConnectivityResult connectivityResult =
    await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // //////// print('Mobile');
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // //////// print('Wifi');
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      //////// print('No Connection');
      return false;
    } else {
      return false;
    }
  }


  static double calorieCalculator({step}) {
    return 0;

  }

  static Future<bool> checkGoogleFitExist() async {

    if(Platform.isAndroid)
      return await DeviceApps.isAppInstalled('com.google.android.apps.fitness');
    else
      return true;
  }

  static Future<bool> checkPermissions() async {

    bool activityRecognition = true;
    bool locationWhenInUse = false;
    bool healthWhenInUse = false;

    if(Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;
      if (!status.isGranted) {
        activityRecognition = false;
      }
    }
    var statusLocationWhenInUse = await Permission.locationWhenInUse.status;
    if(statusLocationWhenInUse.isGranted) {
      locationWhenInUse = true;
    }

    try {
      HealthFactory health = HealthFactory();
      final types = Platform.isIOS ? TypesIOS : TypesAndroid;
      final permissions = types.map((e) => HealthDataAccess.READ).toList();
      bool requested = await health.requestAuthorization(types, permissions: permissions);

      if (requested) {
        healthWhenInUse = true;
      }else{
        healthWhenInUse = false;
      }

    }catch(e){
      healthWhenInUse = false;
      //////// print(e);
    }

    bool isInstalled = await checkGoogleFitExist();
    //////// print("isInstalled__isInstalled__isInstalled__isInstalled");
    //////// print(isInstalled);


    return locationWhenInUse && activityRecognition && healthWhenInUse && isInstalled;
  }

  static Future<bool> checkHealthPermissions() async {

    bool healthWhenInUse = false;


    try {
      HealthFactory health = HealthFactory();
      final types = Platform.isIOS ? TypesIOS : TypesAndroid;
      final permissions = types.map((e) => HealthDataAccess.READ).toList();
      bool requested = await health.requestAuthorization(types, permissions: permissions);

      if (requested) {
        healthWhenInUse = true;
      }else{
        healthWhenInUse = false;
      }

    }catch(e){
      healthWhenInUse = false;
      ////// print(e);
    }

    // bool isInstalled = true;
    bool isInstalled = await checkGoogleFitExist();
    // print("isInstalled__isInstalled__isInstalled__isInstalled");
    // print(isInstalled);

    // print(healthWhenInUse );
    // print(isInstalled);
    return healthWhenInUse && isInstalled;
  }

  static Future<bool> checkStandardPermissions() async {

    bool activityRecognition = true;
    bool locationWhenInUse = false;

    if(Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;
      if (!status.isGranted) {
        activityRecognition = false;
      }
    }
    var statusLocationWhenInUse = await Permission.locationWhenInUse.status;
    if(statusLocationWhenInUse.isGranted) {
      locationWhenInUse = true;
    }




    return locationWhenInUse && activityRecognition ;
  }



  // static dynamic showSuccessModal(BuildContext context, Size size, {String? title, String? buttonText, Function? onTap}) {
  //
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius:
  //               BorderRadius.all(Radius.circular(12.0))),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               // border: Border.all(color: Colors.blueAccent,width: 2),
  //                 borderRadius:
  //                 BorderRadius.all(Radius.circular(10.0))),
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     "title",
  //                   ),
  //                   Text(
  //                     "title",
  //                   ),
  //                   Text(
  //                     "title",
  //                   ),
  //                   Text(
  //                     "title",
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ));
  //     },
  //   );
  // }
  //

  static dynamic showInfoModal(BuildContext context, Size size, {String? title, String? image, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent,width: 2),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                      child: SvgPicture.asset(image ?? "assets/svgs/dialog/success.svg"),
                  ),
                  if(title!=null)
                  Text(
                    title,
                    style: MainStyles.mediumTextStyle.copyWith(fontSize: 18),
                  ),
                  if(title!=null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(height: 24,),
                  ),
                  Divider(color: MainColors.middleGrey200,height: 0,),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    buttonColor: MainColors.middleGrey100,
                    textColor: MainColors.darkBlue500,
                    borderRadius: 0,
                    onTap: () => onTap ?? Navigator.pop(context) ,
                  )
                ],
              ),
            ));
      },
    );
  }


  static dynamic showStandardModal(BuildContext context, Size size, {String? title, String? text, String? image, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent,width: 2),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                      child: SvgPicture.asset(image ?? "assets/svgs/dialog/success.svg"),
                  ),
                  if(title!=null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      title,
                      style: MainStyles.mediumTextStyle.copyWith(fontSize: 18),
                    ),
                  ),
                  if(title!=null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(height: 24,),
                  ),
                  Divider(color: MainColors.middleGrey200,height: 0,),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    buttonColor: MainColors.middleGrey100,
                    textColor: MainColors.darkBlue500,
                    borderRadius: 0,
                    onTap: () => onTap ?? Navigator.pop(context) ,
                  )
                ],
              ),
            ));
      },
    );
  }


  static dynamic showSuccessModal(BuildContext context, Size size, {String? title, String? image, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent,width: 2),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                      child: SvgPicture.asset(image ?? "assets/svgs/dialog/success.svg"),
                  ),
                  if(title!=null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      title,
                      style: MainStyles.mediumTextStyle.copyWith(fontSize: 18),
                    ),
                  ),
                  if(title!=null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(height: 24,),
                  ),
                  Divider(color: MainColors.middleGrey200,height: 0,),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    buttonColor: MainColors.middleGrey100,
                    textColor: MainColors.darkBlue500,
                    borderRadius: 0,
                    onTap: () => onTap ?? Navigator.pop(context) ,
                  )
                ],
              ),
            ));
      },
    );
  }


  static dynamic showErrorModal(BuildContext context, Size size, {String? title, String? image, WEB_SERVICE_ENUM? errorCode, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                // border: Border.all(color: Colors.blueAccent,width: 2),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8,),
                  image != null ?
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      child: SvgPicture.asset(image),
                  ):
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: Image.asset(errorCode == null ? "assets/images/error/went-wrong.png" : errorCode == WEB_SERVICE_ENUM.INTERNET_ERROR ? "assets/images/error/internet.png" : errorCode == WEB_SERVICE_ENUM.UNEXCEPTED_ERROR ? "assets/images/error/server.png" : "assets/images/error/went-wrong.png"),
                  ),
                  if(title!=null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                    child: Text(
                      title,
                      style: MainStyles.mediumTextStyle.copyWith(fontSize: 18), textAlign: TextAlign.center,
                    ),
                  ),
                  if(title==null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(height: 24,),
                  ),
                  Divider(color: MainColors.middleGrey200,height: 0,),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    buttonColor: MainColors.middleGrey100,
                    textColor: MainColors.darkBlue500,
                    borderRadius: 0,
                    onTap: () => onTap ?? Navigator.pop(context) ,
                  )
                ],
              ),
            ));
      },
    );
  }

  static dynamic showInternetErrorModal(BuildContext context, Size size, {String? title, String? image, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent,width: 2),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                      child: SvgPicture.asset(image ?? "assets/svgs/dialog/error.svg"),
                  ),
                  if(title!=null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                    child: Text(
                      title,
                      style: MainStyles.mediumTextStyle.copyWith(fontSize: 18), textAlign: TextAlign.center,
                    ),
                  ),
                  if(title==null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(height: 24,),
                  ),
                  Divider(color: MainColors.middleGrey200,height: 0,),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    buttonColor: MainColors.middleGrey100,
                    textColor: MainColors.darkBlue500,
                    borderRadius: 0,
                    onTap: () => onTap ?? Navigator.pop(context) ,
                  )
                ],
              ),
            ));
      },
    );
  }


  static dynamic showAchievementModal(BuildContext context, Size size, ConfettiController controllerTopCenter, {String? title, String? image, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0))),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.blueAccent,width: 2),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                        child: image != null ? CachedNetworkImage(
                          placeholder: (context, key){
                            return SizedBox(
                              width: size.width * 2.2 / 6,
                              height: size.width * 2.2 / 6,
                              child: Shimmer.fromColors(
                                  highlightColor: MainColors.middleGrey150!.withOpacity(0.2),
                                  baseColor: MainColors.middleGrey150!,
                                  child: Image.asset("assets/images/achievements/prize.png", color: MainColors.middleGrey150, fit: BoxFit.contain)
                              ),
                            );
                          },
                          // key: Key("${"vvvvv"}${1}"),
                          // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                          fit: BoxFit.contain,
                          imageUrl: image,
                          width: size.width * 2.2 / 6,
                          height: size.width * 2.2 / 6,
                        ):SizedBox(
                            width: size.width * 2.2 / 6,
                            height: size.width * 2.2 / 6,
                            child: SvgPicture.asset("assets/svgs/dialog/success.svg")
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
                          child: Text(
                            Utils.getString(context, "general__achievement_dialog_title").toUpperCase(),
                            style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 25, color: MainColors.generalSubtitleColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if(title!=null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            title,
                            style: MainStyles.mediumTextStyle.copyWith(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if(title!=null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: SizedBox(height: 24,),
                        ),
                      Divider(color: MainColors.middleGrey200,height: 0,),
                      BigUnBorderedButton(
                        text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                        buttonColor: MainColors.middleGrey100,
                        textColor: MainColors.darkBlue500,
                        borderRadius: 0,
                        onTap: () => onTap ?? Navigator.pop(context) ,
                      )
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controllerTopCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStarPath,
              ),
            ),
          ],
        );
      },
    );
  }


  static dynamic showBalanceBlockedModal(BuildContext context, Size size, {String? title, String? text, String? image, String? buttonText, Function()? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0))),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.blueAccent,width: 2),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                            child: image != null ? CachedNetworkImage(
                              placeholder: (context, key){
                                return SizedBox(
                                  width: size.width * 3.6 / 6,
                                  height: size.width * 3.6 / 6,
                                  child: Shimmer.fromColors(
                                      highlightColor: MainColors.middleGrey150!.withOpacity(0.2),
                                      baseColor: MainColors.middleGrey150!,
                                      child: Image.asset("assets/images/general/step-blocked.png", color: MainColors.middleGrey150, fit: BoxFit.contain)
                                  ),
                                );
                              },
                              // key: Key("${"vvvvv"}${1}"),
                              // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                              fit: BoxFit.contain,
                              imageUrl: image,
                              width: size.width * 3.6 / 6,
                              height: size.width * 3.6 / 6,
                            ):SizedBox(
                                width: size.width * 3.6 / 6,
                                height: size.width * 3.6 / 6,
                                child: SvgPicture.asset("assets/svgs/dialog/step-blocked.svg")
                            ),
                          ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
                              child: Text(
                                Utils.getString(context, "general_balance_blocked_modal_title").toUpperCase(),
                                style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 24, color: MainColors.generalSubtitleColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                text ?? Utils.getString(context, "general_balance_blocked_modal_text"),
                                style: MainStyles.mediumTextStyle.copyWith(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(height: 12,),
                            ),
                          // Divider(color: MainColors.middleGrey200,height: 0,),
                          BigUnBorderedButton(
                            horizontal: 20,
                            vertical: 16,
                            text: buttonText ?? Utils.getString(context, "general_balance_blocked_modal_button_text"),
                            // buttonColor: MainColors.middleGrey100,
                            textColor: MainColors.white,
                            // borderRadius: 0,
                            onTap: (){
                              if(onTap != null){
                                onTap();
                              }
                              else
                                Navigator.pop(context);
                            } ,
                          )
                        ],
                      ),

                      Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset("assets/svgs/dialog/close.svg")
                          )
                      )

                    ],
                  ),
                )),
          ],
        );
      },
    );
  }


  static dynamic showChallengeResultModal(BuildContext context, Size size, {String? title, String? description, String? image, required int step, required int bonusStep, required double calStep, required int calMinute, String? buttonText, Function? onTap}) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent,width: 2),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8,),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                      child: SvgPicture.asset(image ?? "assets/svgs/dialog/error.svg"),
                  ),
                  if(title!=null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: Text(
                      title,
                      style: MainStyles.mediumTextStyle.copyWith(fontSize: 34, color: MainColors.middleBlue500), textAlign: TextAlign.center,
                    ),
                  ),
                  if(description !=null)
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0, bottom: 16),
                    child: Text(
                      description,
                      style: MainStyles.mediumTextStyle.copyWith(fontSize: 16, color: MainColors.middleBlue500), textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(child: Text("${calStep > 10 ? Utils.humanizeDouble(context, Utils.roundNumber(calStep, toPoint: 1)) : Utils.roundNumber(calStep, toPoint: 2)} ${Utils.getString(context, "challenges_details_view___distance_measure")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 14), overflow: TextOverflow.ellipsis))
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text("${step} ${Utils.getString(context, "general__steps__count")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 16), overflow: TextOverflow.ellipsis,)
                                  )
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(child: Text("${calMinute} ${Utils.getString(context, "challenges_details_view___distance_measure_minute")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 14), overflow: TextOverflow.ellipsis))
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Badge(
                              padding: EdgeInsets.all(0.0),
                              position: BadgePosition.topEnd(top: -10, end: 0),
                              badgeContent: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFDCE8),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(child: Text("${"B"}", style: MainStyles.boldTextStyle.copyWith(fontSize: 14, color: MainColors.darkPink500)))
                              ),
                              // borderSide: null,
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF8EEF1),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(child: Text("${bonusStep} ${Utils.getString(context, "general__steps__count")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 14), overflow: TextOverflow.ellipsis))
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Divider(color: MainColors.middleGrey200,height: 0,),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    buttonColor: MainColors.middleGrey100,
                    textColor: MainColors.darkBlue500,
                    borderRadius: 0,
                    onTap: () => onTap ?? Navigator.pop(context) ,
                  )
                ],
              ),
            ));
      },
    );
  }


  static dynamic showSuccessBottomModal(BuildContext context, Size size, {String? title, String? buttonText, Function? onTap}) {

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            // height: size.height / (812 / 664),
            padding: EdgeInsets.symmetric(
                vertical:
                12,
                horizontal:
                24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                        width: 64,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                  ),
                  SizedBox(height: size.height * 0.4 / 10,),
                  Image.asset("assets/gifs/Drooling-cat.gif", height: size.height * 2 / 10, fit: BoxFit.cover),
                  SizedBox(height: size.height * 0.4 / 10,),
                  AutoSizeText(title ?? '-', style: MainStyles.appbarStyle,),
                  MainAdvancedButton(
                    text: buttonText ?? ' -',
                    onTap: (){
                      onTap!(ctx);
                    },
                    horizontal: 0,
                    vertical: size.height * 0.4 / 10,
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.only(
                    topLeft: Radius
                        .circular(30),
                    topRight:
                    Radius.circular(
                        30))),
          );
        },
        isScrollControlled: true);
  }




  static dynamic showInfoByDateModal(BuildContext context, Size size, {String? title, String? text , String? dateText, String? buttonText, Function? onTap}) {

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            // height: size.height / (812 / 664),
            padding: EdgeInsets.symmetric(
                vertical:
                12,
                horizontal:
                16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                        width: 64,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            // borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                  SizedBox(height: size.height * 0.2 / 10,),
                  AutoSizeText(title ?? '', style: MainStyles.appbarStyle,),
                  SizedBox(height: size.height * 0.2 / 10,),
                  AutoSizeText(text ?? '', style: MainStyles.mediumTextStyle,),
                  SizedBox(height: size.height * 0.1 / 10,),
                  // Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(dateText ?? '', style: MainStyles.mediumTextStyle.copyWith(fontSize: 14),),
                    ],
                  ),
                  Divider(),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    onTap: (){
                      onTap!(ctx);
                    },
                    horizontal: 0,
                    vertical: size.height * 0.1 / 10,
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius:
                // BorderRadius.only(
                //     topLeft: Radius
                //         .circular(10),
                //     topRight:
                //     Radius.circular(
                //         30))
            ),
          );
        },
        isScrollControlled: true);
  }


  static dynamic showInfoByImageModal(BuildContext context, Size size, {String? title, String? text , String? imageText, String? buttonText, Function? onTap}) {

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            // height: size.height / (812 / 664),
            padding: EdgeInsets.symmetric(
                vertical:
                12,
                horizontal:
                16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                        width: 64,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            // borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                  SizedBox(height: size.height * 0.2 / 10,),
                  Center(child: Text(title ?? '', style: MainStyles.appbarStyle, textAlign: TextAlign.center,)),
                  if(imageText != null)
                  SizedBox(height: size.height * 0.1 / 10,),
                  if(imageText != null)
                  Divider(),
                  if(imageText != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, key){
                            return SizedBox(
                              height: size.width * 5 / 10,
                              // height: size.width * 0.95 / 6,
                              child: Shimmer.fromColors(
                                  highlightColor: MainColors.middleGrey150!.withOpacity(0.2),
                                  baseColor: MainColors.middleGrey150!,
                                  child: Image.asset("assets/images/api/ach1.png", color: MainColors.middleGrey150,)
                              ),
                            );
                          },
                          // key: Key("${"vvvvv"}${1}"),
                          // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                          fit: BoxFit.cover,
                          imageUrl: imageText,
                          height: size.width * 5 / 10,
                        )
                      ],
                    ),
                  // Divider(),
                  SizedBox(height: size.height * 0.2 / 10,),
                  Center(child: Text(text ?? '', style: MainStyles.mediumTextStyle, textAlign: TextAlign.center,)),
                  Divider(),
                  BigUnBorderedButton(
                    text: buttonText ?? Utils.getString(context, "general__close_button_text"),
                    onTap: (){
                      onTap!(ctx);
                    },
                    horizontal: 0,
                    vertical: size.height * 0.1 / 10,
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius:
                // BorderRadius.only(
                //     topLeft: Radius
                //         .circular(10),
                //     topRight:
                //     Radius.circular(
                //         30))
            ),
          );
        },
        isScrollControlled: true);
  }

  static int getTabIndex(Navigation navigation) {
    switch (navigation){
      case Navigation.HOME:{
        return 0;
      }
      case Navigation.DONATIONS:{
        return 1;
      }
      case Navigation.CHALLENGES:{
        return 2;
      }
      case Navigation.PROFILE:{
        return 3;
      }
      default: {
        return 0;
      }
    }
  }



}