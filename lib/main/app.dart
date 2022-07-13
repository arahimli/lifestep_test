
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/get_it.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/step/donation/all/cubit.dart';
import 'package:lifestep/logic/step/donation/month/cubit.dart';
import 'package:lifestep/logic/step/donation/week/cubit.dart';
import 'package:lifestep/logic/step/step-calculation/cubit.dart';
import 'package:lifestep/logic/step/step/all/cubit.dart';
import 'package:lifestep/logic/step/step/month/cubit.dart';
import 'package:lifestep/logic/step/step/week/cubit.dart';
import 'package:lifestep/logic/term_privacy/cubit.dart';
import 'package:lifestep/main.dart';
import 'package:lifestep/main/theme.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/static.dart';
import 'package:lifestep/repositories/step.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/db/main_shared_preferences.dart';
import 'package:lifestep/config/router.dart' as router;

import 'app-builder.dart';

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
      FCM_TOKEN = token;
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
                            staticRepository: GetIt.instance<StaticRepository>()
                        ),
                      ),
                      BlocProvider<SettingsCubit>(
                        create: (context) => SettingsCubit(
                            staticRepository: GetIt.instance<StaticRepository>()
                        ),
                      ),

                      BlocProvider<GeneralUserLeaderBoardWeekStepCubit>(
                        create: (context) => GeneralUserLeaderBoardWeekStepCubit(
                            stepRepository: GetIt.instance<StepRepository>()
                        ),
                      ),
                      BlocProvider<GeneralUserLeaderBoardMonthStepCubit>(
                        create: (context) => GeneralUserLeaderBoardMonthStepCubit(
                            stepRepository: GetIt.instance<StepRepository>()
                        ),
                      ),
                      BlocProvider<GeneralUserLeaderBoardAllStepCubit>(
                        create: (context) => GeneralUserLeaderBoardAllStepCubit(
                            stepRepository: GetIt.instance<StepRepository>()
                        ),
                      ),


                      BlocProvider<GeneralUserLeaderBoardWeekDonationCubit>(
                        create: (context) => GeneralUserLeaderBoardWeekDonationCubit(
                            stepRepository: GetIt.instance<StepRepository>()
                        ),
                      ),
                      BlocProvider<GeneralUserLeaderBoardMonthDonationCubit>(
                        create: (context) => GeneralUserLeaderBoardMonthDonationCubit(
                            stepRepository: GetIt.instance<StepRepository>()
                        ),
                      ),
                      BlocProvider<GeneralUserLeaderBoardAllDonationCubit>(
                        create: (context) => GeneralUserLeaderBoardAllDonationCubit(
                            stepRepository: GetIt.instance<StepRepository>()
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
                              authRepo: GetIt.instance<UserRepository>(),
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
                        navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
                        debugShowCheckedModeBanner: false,
                        title: MainConfig.app_name,
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
