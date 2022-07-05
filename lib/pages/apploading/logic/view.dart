// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lifestep/tools/components/error/internet_error.dart';
// import 'package:lifestep/tools/components/error/standard_error.dart';
// import 'package:lifestep/pages/apploading/logic/cubit.dart';
// import 'package:lifestep/pages/apploading/logic/state.dart';
// import 'package:lifestep/pages/apploading/splash-screen.dart';
// import 'package:lifestep/pages/index/index/cubit.dart';
// import 'package:lifestep/pages/index/index/logic/charity/cubit.dart';
// import 'package:lifestep/pages/index/index/logic/dailystep/cubit.dart';
// import 'package:lifestep/pages/index/index/logic/leaderboard/logic/cubit.dart';
// import 'package:lifestep/pages/index/index/logic/leaderboard/logic/donation/cubit.dart';
// import 'package:lifestep/pages/index/index/logic/leaderboard/logic/step/cubit.dart';
// import 'package:lifestep/pages/index/index/view.dart';
// import 'package:lifestep/pages/onboard/view.dart';
// import 'package:lifestep/pages/user/cubit/cubit.dart';
// import 'package:lifestep/pages/user/cubit/navigator.dart';
// import 'package:lifestep/logic/session/cubit.dart';
// import 'package:lifestep/pages/user/repositories/auth.dart';
// import 'package:lifestep/repositories/donation.dart';
// import 'package:lifestep/repositories/home.dart';
// import 'package:lifestep/repositories/step.dart';
//
// class AppLoadingView extends StatefulWidget {
//   @override
//   _AppLoadingViewState createState() => _AppLoadingViewState();
// }
//
// class _AppLoadingViewState extends State<AppLoadingView> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<ApploadingCubit, ApploadingState>(
//         builder: (context, apploadingState) {
//
//           // Locale myLocale = Localizations.localeOf(context);
//           // LANGUAGE = myLocale.languageCode;
//           if(apploadingState is ApploadingResult) {
//             //////// print("TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_");
//             //////// print(TOKEN);
//             //////// print("TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_TOKEN_");
//             if (apploadingState.result.isConnectedToWeb == -1) {
//               //////// print('AppSplashScreen');
//               return AppSplashScreen();
//             } else if (apploadingState.result.isConnectedToWeb == 1) {
//               //////// print('DirectPage');
//               if (apploadingState.result.isError) {
//                 //////// print('ErrorHappendView');
//                 return ErrorHappenedView(errorText: apploadingState.result.errorText,
//                   onTap: () =>
//                       Navigator.pushReplacementNamed(context, "/apploading"),);
//               } else {
//                 // BlocProvider.of<TermsPrivacyCubit>(context).getTermsPrivacy();
//                 if (apploadingState.result.isLogin) {
//                   BlocProvider.of<SessionCubit>(context).setUser(
//                       apploadingState.result.userModel);
//                   return MultiBlocProvider(
//                       providers: [
//                         BlocProvider<HomeDailyStepCubit>(
//                             create: (BuildContext context) =>
//                                 HomeDailyStepCubit(
//                                     authRepo: UserRepository(),
//                                     sessionCubit: BlocProvider.of<
//                                         SessionCubit>(context))),
//                         BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: DonationRepository())),
//                         BlocProvider<IndexCubit>(
//                             create: (BuildContext context) =>
//                                 IndexCubit(
//                                     homeRepository: HomeRepository())),
//                         BlocProvider<LeaderBoardHomeCubit>(
//                             create: (BuildContext context) =>
//                                 LeaderBoardHomeCubit()),
//                         BlocProvider<HomeLeaderBoardDonationCubit>(
//                             create: (BuildContext context) =>
//                                 HomeLeaderBoardDonationCubit(
//                                     stepRepository: StepRepository())),
//                         BlocProvider<HomeLeaderBoardStepCubit>(
//                             create: (BuildContext context) =>
//                                 HomeLeaderBoardStepCubit(
//                                     stepRepository: StepRepository())),
//                       ],
//                       child: IndexView()
//                   );
//                 } else if (apploadingState.result.pref.containsKey('onboard')) {
//                   return RepositoryProvider(
//                     create: (context) => UserRepository(),
//                     child: BlocProvider(
//                       create: (context) =>
//                           AuthCubit(),
//                       child: AuthNavigator(),
//                     ),
//                   );
//                 } else if (!apploadingState.result.pref.containsKey('onboard')) {
//                   //////// print('OnboardPageView');
//                   return OnboardPageView();
//                 } else {
//                   //////// print('ErrorHappenedView');
//                   return ErrorHappenedView(errorText: apploadingState.result.errorText,
//                     onTap: () =>
//                         Navigator.pushReplacementNamed(
//                             context, "/apploading"),);
//                 }
//               }
//             } else {
//               //////// print('InternetConnectionErrorView');
//               return InternetConnectionErrorView(
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, "/apploading");
//                 },
//               );
//             }
//           }
//           else{
//             return AppSplashScreen();
//           }
//         }
//       ),
//     );
//   }
// }