import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifestep/config/get_it.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main/app.dart';
import 'tools/common/language.dart';
import 'config/main_config.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void requestIOSPermissions() {
  flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}

GetIt getIt = GetIt.instance;
// AppMetricaConfig get _config => const AppMetricaConfig(dotenv.env['YANDEX_KEY']!.toString(), logs: true);
AppMetricaConfig get _config => const AppMetricaConfig(MainConfig.app_metrica_config, logs: true);

void main() async{
  AppMetrica.runZoneGuarded(() async{
  // getIt.registerSingleton<AppModel>(AppModelImplementation(), signalsReady: true);
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // await Permission.appTrackingTransparency.request();
  final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load(fileName: "assets/config/.env");
  setupLocator();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(),
  );
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    requestIOSPermissions();
  }

   FirebaseMessaging.onMessageOpenedApp.listen((message) {
   });

    AppMetrica.activate(_config);

    runApp(EasyLocalization(
        path: 'assets/langs',
        startLocale: await MainConfig.defaultLanguage.startLocale(),
        supportedLocales: getSupportedLanguages(),
        child: MainApp(
            connectivity: Connectivity()
        )
    ));

  });
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in MainConfig.mainSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  return localeList;
}



