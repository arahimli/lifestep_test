// import 'dart:io';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lifestep/tools/components/error/internet_error.dart';
// import 'package:lifestep/tools/components/error/standard_error.dart';
// import 'package:lifestep/config/endpoints.dart';
// import 'package:lifestep/model/auth/profile.dart';
// import 'package:lifestep/pages/apploading/splash-screen.dart';
// import 'package:lifestep/pages/index/index/cubit.dart';
// import 'package:lifestep/pages/index/index/logic/dailystep/cubit.dart';
// import 'package:lifestep/pages/index/index/view.dart';
// import 'package:lifestep/pages/onboard/view.dart';
// import 'package:lifestep/pages/user/cubit/cubit.dart';
// import 'package:lifestep/pages/user/cubit/navigator.dart';
// import 'package:lifestep/logic/session/cubit.dart';
// import 'package:lifestep/pages/user/repositories/auth.dart';
// import 'package:lifestep/repositories/home.dart';
// import 'package:lifestep/repositories/service/web_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sprintf/sprintf.dart';
//
//
// class AppLoadingModel {
//   final SharedPreferences pref;
//   final int isConnectedToWeb;
//   final String? language;
//   final String? errorText;
//   final bool isError;
//   final bool isLogin;
//   final bool isPermission;
//   final UserModel? userModel;
//
//   AppLoadingModel({required this.pref, required this.isConnectedToWeb, this.language, this.errorText, required this.isError, required this.isLogin, required this.isPermission, this.userModel});
// }
//
// class AppLoadingView extends StatefulWidget {
//   @override
//   _AppLoadingViewState createState() => _AppLoadingViewState();
// }
//
// class _AppLoadingViewState extends State<AppLoadingView> {
// //  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
// //  int isConnectedToWeb = -1;
//
//   Future<AppLoadingModel> builderData() async {
//     int isConnectedToWeb;
//     bool isLogin = false;
//     bool isError = false;
//     bool isPermission = false;
//     UserModel? userModel;
//     String? errorText = '';
//     String? playerId = '';
//     String language = 'az';
//     // await Future.delayed(const Duration(seconds: 1));
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     if (!pref.containsKey('language')) {
//       if(Platform.localeName.contains('ru')){
//         await pref.setString('language', 'ru');
//         LANGUAGE = 'ru';
//         // }else if(Platform.localeName.contains('en')){
//         //   await pref.setString('language', 'en');
//         //   LANGUAGE = 'en';
//       }else{
//         await pref.setString('language', 'az');
//         LANGUAGE = 'az';
//       }
//     }else {
//     }
//
//
//     if (pref.containsKey('token')) {
//       TOKEN = pref.getString('token');
//     }
//
//     if(!pref.containsKey('player_id')){
//       try {
//         String? fcm_token = await FirebaseMessaging.instance.getToken();
//         pref.setString('player_id', fcm_token!);
//         playerId = fcm_token;
//       }catch(e){
//       }
//     }else{
//       playerId = pref.getString('player_id');
//     }
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       isConnectedToWeb = 1;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       isConnectedToWeb = 1;
//     } else {
//       isConnectedToWeb = 0;
//     }
//
//     if (connectivityResult == ConnectivityResult.mobile) {
//       isConnectedToWeb = 1;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       isConnectedToWeb = 1;
//     } else {
//       isConnectedToWeb = 0;
//     }
//
//
//
//
//
//     //////// print("LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_LANGUAGE_121-v7");
//     UserRepository authRepo = GetIt.instance<UserRepository>();
//     if (isConnectedToWeb == 1 && TOKEN != null && TOKEN != '') {
//       try {
//
//         final data = await authRepo.getUser(extraUrl: sprintf("?player_id=%s", [playerId ?? '']));
//
//         //////// print(data);
//         //////// print(data[2]);
//         switch (data[2]) {
//           case WEB_SERVICE_ENUM.SUCCESS:
//             {
//
//               ProfileResponse loginResponse = ProfileResponse.fromJson(data[1]);
//               userModel = loginResponse.data;
//               isLogin = true;
//             }
//             break;
//           case WEB_SERVICE_ENUM.UN_AUTH:
//             {
//               isLogin = false;
//             }
//             break;
//           case WEB_SERVICE_ENUM.INTERNET_ERROR:
//             {
//               isConnectedToWeb = 0;
//             }
//             break;
//           default:
//             {
//               //////// print("ErrorHappenedState(errorText:");
//               //////// print("------------------ general e ------------------");
//               isError = true;
//               errorText = data[1];
//             }
//             break;
//         }
//       } on Exception catch (e) {
//         //////// print("------------------ general e ------------------");
//         isError = true;
//       }
//     }
//     // LOGIN_BOOL = isLogin;
//     //////// print("return_AppLoadingModel");
//     return AppLoadingModel(
//         pref: pref,
//         isConnectedToWeb: isConnectedToWeb,
//         isPermission: true,
//         // isPermission: await Utils.checkPermissions(),
//         isLogin: isLogin,
//         errorText: errorText,
//         language: language,
//         isError: isError,
//         userModel: userModel
//     );
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<AppLoadingModel>(
//           future: builderData(),
//           builder: (context, snapshot) {
// //          connectionCheck();
//             if (snapshot.hasData) {
//               // Locale myLocale = Localizations.localeOf(context);
//               // LANGUAGE = myLocale.languageCode;
//
//
//               //////// print("isConnectedToWeb = ${snapshot.data!.isConnectedToWeb}");
//               //////// print(
//               //     "snapshot.data.getBool('login') = ${snapshot.data!.pref.getBool('onboard')}");
//               //////// print(
//               //     "snapshot.data.getBool('login') = ${snapshot.data!.pref.containsKey('onboard')}");
//               //////// print("TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_");
//               //////// print(TOKEN);
//               //////// print("TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_");
//               if (snapshot.data!.isConnectedToWeb == -1) {
//                 //////// print('AppSplashScreen');
//                 return AppSplashScreen();
//               } else if (snapshot.data!.isConnectedToWeb == 1) {
//                 //////// print('DirectPage');
//                 if (snapshot.data!.isError) {
//                   //////// print('ErrorHappendView');
//                   return ErrorHappenedView(errorText: snapshot.data!.errorText ,onTap: () => Navigator.pushReplacementNamed(context, "/apploading"),);
//                 } else {
//                   // BlocProvider.of<TermsPrivacyCubit>(context).getTermsPrivacy();
//                   if (snapshot.data!.isLogin) {
//                     // if(snapshot.data.petCount == 0){
//                     //   return GeneralAddFormView();
//                     // }
//                     //////// print("snapshot.data!.pref.containsKey('onboard')");
//                     //////// print(snapshot.data!.pref.containsKey('onboard'));
//                     BlocProvider.of<SessionCubit>(context).setUser(snapshot.data!.userModel);
//                     // if(snapshot.data!.isPermission) {
//                     return MultiBlocProvider(
//                         providers: [
//                           BlocProvider<HomeDailyStepCubit>(
//                               create: (BuildContext context) =>
//                                   HomeDailyStepCubit(
//                                       authRepo: GetIt.instance<UserRepository>(),
//                                       sessionCubit: BlocProvider.of<
//                                           SessionCubit>(context))),

                              // BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: GetIt.instance<DonationRepository>())),
//                           BlocProvider<IndexCubit>(
//                               create: (BuildContext context) =>
//                                   IndexCubit(
//                                       homeRepository: GetIt.instance<HomeRepository>())),
//                         ],
//                         child: IndexView()
//                     );
//                     // }else{
//                     //   return PermissionsHandleView();
//                     // }
//                   }else if (snapshot.data!.pref.containsKey('onboard')) {
//                     return RepositoryProvider(
//                       create: (context) => GetIt.instance<UserRepository>(),
//                       child: BlocProvider(
//                         create: (context) =>
//                             AuthCubit(),
//                         child: AuthNavigator(),
//                       ),
//                     );
//                   } else if (!snapshot.data!.pref.containsKey('onboard')) {
//                     //////// print('OnboardPageView');
//                     return OnboardPageView();
//                   } else {
//                     //////// print('ErrorHappenedView');
//                     return ErrorHappenedView(errorText: snapshot.data!.errorText ,onTap: () => Navigator.pushReplacementNamed(context, "/apploading"),);
//                   }
//                 }
//               } else {
//                 //////// print('InternetConnectionErrorView');
//                 return InternetConnectionErrorView(
//                   onTap: () {
//
//                     Navigator.pushReplacementNamed(context, "/apploading");
//                   },
//                 );
//               }
//             } else
//               return AppSplashScreen();
//           }),
//     );
//   }
// }