import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/term_privacy/cubit.dart';
import 'package:lifestep/main/app-builder.dart';
import 'package:lifestep/main/theme.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/static.dart';
import 'package:lifestep/repositories/step.dart';
import 'logic/step/donation/all/cubit.dart';
import 'logic/step/donation/month/cubit.dart';
import 'logic/step/donation/week/cubit.dart';
import 'logic/step/step-calculation/cubit.dart';
import 'logic/step/step/all/cubit.dart';
import 'logic/step/step/month/cubit.dart';
import 'logic/step/step/week/cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lifestep/config/get_it.dart';
import 'package:lifestep/config/router.dart' as router;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'tools/common/language.dart';
import 'tools/common/utlis.dart';
import 'config/main_colors.dart';
import 'config/main_config.dart';
import 'config/styles.dart';
import 'tools/db/main_shared_preferences.dart';
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
AppMetricaConfig get _config => const AppMetricaConfig("72b95a64-bed7-4932-8b02-c9e9899bfc6d", logs: true);

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




class MainApp extends StatefulWidget {
  final Connectivity connectivity;

  const MainApp({Key? key, required this.connectivity}) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> {
  Completer<ThemeData>? themeDataCompleter;
  MainSharedPreferences? mainSharedPreferences;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
      }
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification android = message.notification.android;
      if (notification != null && message.notification != null && !kIsWeb) {


        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: IOSNotificationDetails(),
              android: AndroidNotificationDetails(

                  channel!.id,
                  channel!.name,
                  channelDescription: channel!.description,
                  icon: '@drawable/notification_icon',
                  // largeIcon: ,

                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  // icon: 'launch_background',
                  priority: Priority.high,
                  importance: Importance.high,
                  fullScreenIntent: true
              ),
            )).then((value){
          value;
        });
      }else{

      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
    getToken();

  }
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      FCM_TOKEN = token;
    });
  }

// --------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------



  // Future<ThemeData> getSharePerference(
  //     EasyLocalization provider, dynamic data) {
  //   Utils.psPrint('>> get share perference');
  //   if (themeDataCompleter == null) {
  //     Utils.psPrint('init completer');
  //     themeDataCompleter = Completer<ThemeData>();
  //   }
  //
  //   if (mainSharedPreferences == null) {
  //     Utils.psPrint('init ps shareperferences');
  //     mainSharedPreferences = MainSharedPreferences.instance;
  //     Utils.psPrint('get shared');
  //     mainSharedPreferences!.futureShared!.then((SharedPreferences sh) {
  //       mainSharedPreferences!.shared = sh;
  //
  //       Utils.psPrint('init theme provider');
  //       final MainThemeProvider psThemeProvider = MainThemeProvider(
  //           repo: MainThemeRepository(mainSharedPreferences: mainSharedPreferences!));
  //
  //       Utils.psPrint('get theme');
  //       final ThemeData themeData = psThemeProvider.getTheme();
  //       themeDataCompleter!.complete(themeData);
  //       Utils.psPrint('themedata loading completed');
  //     });
  //   }
  //
  //   return themeDataCompleter!.future;
  // }



  @override
  Widget build(BuildContext context) {

    // init Color
    MainColors.loadColor(context);
    MainStyles.loadStyle(context);

    final dark = ThemeData.dark();
    final darkButtonTheme = dark.buttonTheme.copyWith(buttonColor: Colors.grey[700]);
    final darkFABTheme = dark.floatingActionButtonTheme;

    final themeCollection = ThemeCollection(
        themes: {
          AppThemes.LightBlue: ThemeData(primarySwatch: Colors.blue),
          AppThemes.DarkBlue: dark.copyWith(
              accentColor: Colors.blue,
              buttonTheme: darkButtonTheme,
              floatingActionButtonTheme: darkFABTheme.copyWith(backgroundColor: Colors.blue)),
        }
    );

    return DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: AppThemes.LightBlue,
        // defaultBrightness: Brightness.light,
        // data: (Brightness brightness) {
        //   if (brightness == Brightness.light) {
        //     return themeData(ThemeData.light());
        //   } else {
        //     return themeData(ThemeData.dark());
        //   }
        // },
        builder: (BuildContext context, ThemeData theme) {
          return GestureDetector(
            onTap: () {
              Utils.focusClose(context);
            },
            child: AppBuilder(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [

                    BlocProvider<SessionCubit>(
                      create: (BuildContext context) => SessionCubit(
                        authRepo: UserRepository()
                      ),
                    ),

                    // BlocProvider<InternetCubit>(
                    //   create: (context) => InternetCubit(
                    //       connectivity: widget.connectivity
                    //   ),
                    // ),

                    BlocProvider<TermsPrivacyCubit>(
                      create: (context) => TermsPrivacyCubit(
                          staticRepository: StaticRepository()
                      ),
                    ),
                    BlocProvider<SettingsCubit>(
                      create: (context) => SettingsCubit(
                          staticRepository: StaticRepository()
                      ),
                    ),

                    BlocProvider<GeneralUserLeaderBoardWeekStepCubit>(
                      create: (context) => GeneralUserLeaderBoardWeekStepCubit(
                          stepRepository: StepRepository()
                      ),
                    ),
                    BlocProvider<GeneralUserLeaderBoardMonthStepCubit>(
                      create: (context) => GeneralUserLeaderBoardMonthStepCubit(
                          stepRepository: StepRepository()
                      ),
                    ),
                    BlocProvider<GeneralUserLeaderBoardAllStepCubit>(
                      create: (context) => GeneralUserLeaderBoardAllStepCubit(
                          stepRepository: StepRepository()
                      ),
                    ),


                    BlocProvider<GeneralUserLeaderBoardWeekDonationCubit>(
                      create: (context) => GeneralUserLeaderBoardWeekDonationCubit(
                          stepRepository: StepRepository()
                      ),
                    ),
                    BlocProvider<GeneralUserLeaderBoardMonthDonationCubit>(
                      create: (context) => GeneralUserLeaderBoardMonthDonationCubit(
                          stepRepository: StepRepository()
                      ),
                    ),
                    BlocProvider<GeneralUserLeaderBoardAllDonationCubit>(
                      create: (context) => GeneralUserLeaderBoardAllDonationCubit(
                          stepRepository: StepRepository()
                      ),
                    ),

                      // BlocProvider<SettingsCubit>(
                      //   create: (counterCubitContext) => SettingsCubit(),
                      //   // lazy as 'false', will create SettingsCubit
                      //   // right after the app is launched
                      //   // lazy as 'true' (default), will create SettingsCubit
                      //   // when it is used / called
                      //   lazy: false,
                      // ),
                  ],
                  child: MultiBlocProvider(
                    providers: [

                      BlocProvider<GeneralStepCalculationCubit>(
                        create: (BuildContext context) => GeneralStepCalculationCubit(
                            authRepo: UserRepository(),
                            sessionCubit: BlocProvider.of<SessionCubit>(context)
                        ),
                      ),
                    ],
                    child: MaterialApp(
                      builder: (context, child){
                        return MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                            child: child!);
                      },
                      navigatorKey: getIt<NavigationService>().navigatorKey,
                      debugShowCheckedModeBanner: false,
                      title: 'Lifestep test',
                      theme: theme,
                      initialRoute: '/apploading',
                      onGenerateRoute: router.generateRoute,
                      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        EasyLocalization.of(context)!.delegate,
                        DefaultCupertinoLocalizations.delegate
                      ],
                      supportedLocales: EasyLocalization.of(context)!.supportedLocales,
                      locale: EasyLocalization.of(context)!.locale,
                    ),
                  ),
                );
              }
            ),
          );
        });
  }
}
