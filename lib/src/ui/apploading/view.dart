import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/tools/components/error/internet_error.dart';
import 'package:lifestep/src/tools/components/error/maintenance.dart';
import 'package:lifestep/src/tools/components/error/server_error.dart';
import 'package:lifestep/src/tools/components/error/standard_error.dart';
import 'package:lifestep/src/tools/components/error/update_warning.dart';
import 'package:lifestep/src/ui/apploading/logic/cubit.dart';
import 'package:lifestep/src/ui/apploading/logic/state.dart';
import 'package:lifestep/src/ui/index/logic/challenge/cubit.dart';
import 'package:lifestep/src/ui/splash/view.dart';
import 'package:lifestep/src/ui/index/logic/main/cubit.dart';
import 'package:lifestep/src/ui/index/logic/charity/cubit.dart';
import 'package:lifestep/src/ui/index/logic/dailystep/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/src/ui/index/view.dart';
import 'package:lifestep/src/ui/onboard/view.dart';
import 'package:lifestep/src/ui/user/logic/cubit.dart';
import 'package:lifestep/src/ui/user/logic/navigator.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/resources/home.dart';
import 'package:lifestep/src/resources/step.dart';

class AppLoadingView extends StatefulWidget {
  const AppLoadingView({Key? key}) : super(key: key);
  @override
  _AppLoadingViewState createState() => _AppLoadingViewState();
}

class _AppLoadingViewState extends State<AppLoadingView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ApploadingCubit, ApploadingState>(
          builder: (context, apploadingState) {

            // Locale myLocale = Localizations.localeOf(context);
            // LANGUAGE = myLocale.languageCode;
            if(apploadingState is ApploadingResult) {
              if (apploadingState.result.isConnectedToWeb == -1) {
                return InternetConnectionErrorView(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/apploading");
                  },
                );
              } else if (apploadingState.result.isConnectedToWeb == 1) {
             ////// print(apploadingState.result.hasUpdate);
             ////// print(apploadingState.result.isRequiredUpdate);
;                if (apploadingState.result.inMaintenance ) {
                  return const MaintenanceWarningView();
                } else if (apploadingState.result.hasUpdate && apploadingState.result.isRequiredUpdate ) {
                  return UpdateWarningView();
                } else if (apploadingState.result.isError) {
                  return ServerErrorView(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/apploading");
                    },
                  );
                } else {
                  if (apploadingState.result.isLogin) {
                    BlocProvider.of<SessionCubit>(context).setUser(
                        apploadingState.result.userModel);
                    return MultiBlocProvider(
                        providers: [
                          BlocProvider<HomeDailyStepCubit>(
                              create: (BuildContext context) =>
                                  HomeDailyStepCubit(
                                      authRepo: GetIt.instance<UserRepository>(),
                                      sessionCubit: BlocProvider.of<
                                          SessionCubit>(context))),
                          BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: GetIt.instance<DonationRepository>())),
                          BlocProvider<HomeChallengeListCubit>(create: (BuildContext context) => HomeChallengeListCubit(challengeRepository: GetIt.instance<ChallengeRepository>())),

                          BlocProvider<IndexCubit>(
                              create: (BuildContext context) =>
                                  IndexCubit(
                                      homeRepository: GetIt.instance<HomeRepository>())),
                          BlocProvider<LeaderBoardHomeCubit>(
                              create: (BuildContext context) =>
                                  LeaderBoardHomeCubit()),
                          BlocProvider<HomeLeaderBoardDonationCubit>(
                              create: (BuildContext context) =>
                                  HomeLeaderBoardDonationCubit(
                                      stepRepository: GetIt.instance<StepRepository>())),
                          BlocProvider<HomeLeaderBoardStepCubit>(
                              create: (BuildContext context) =>
                                  HomeLeaderBoardStepCubit(
                                      stepRepository: GetIt.instance<StepRepository>())),
                        ],
                        child: IndexView()
                    );
                  } else if (apploadingState.result.pref.containsKey('onboard')) {
                    return RepositoryProvider(
                      create: (context) => GetIt.instance<UserRepository>(),
                      child: BlocProvider(
                        create: (context) =>
                            AuthCubit(),
                        child: AuthNavigator(),
                      ),
                    );
                  } else if (!apploadingState.result.pref.containsKey('onboard')) {
                    return OnboardPageView();
                  } else {
                    return ErrorHappenedView(errorText: apploadingState.result.errorText,
                      onTap: () =>
                          Navigator.pushReplacementNamed(
                              context, "/apploading"),);
                  }
                }
              } else {
                return InternetConnectionErrorView(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/apploading");
                  },
                );
              }
            }
            else{
              return AppSplashScreen();
            }
          }
      ),
    );
  }
}