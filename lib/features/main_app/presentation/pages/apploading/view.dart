import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/features/main_app/data/repositories/donation/repository.dart';
import 'package:lifestep/features/main_app/data/repositories/home/repository.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/internet_error.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/maintenance.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/server_error.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/standard_error.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/update_warning.dart';
import 'package:lifestep/features/main_app/presentation/pages/apploading/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/apploading/logic/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/challenge/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/splash/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/main/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/charity/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/dailystep/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/onboard/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/logic/navigator.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/step.dart';

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
            // languageGlobal = myLocale.languageCode;
            if(apploadingState is ApploadingResult) {
              if (apploadingState.result.isConnectedToWeb == -1) {
                return InternetConnectionErrorView(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/apploading");
                  },
                );
              } else if (apploadingState.result.isConnectedToWeb == 1) {
                if (apploadingState.result.inMaintenance ) {
                  return const MaintenanceWarningView();
                } else if (apploadingState.result.hasUpdate && apploadingState.result.isRequiredUpdate ) {
                  return const UpdateWarningView();
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
                        child: const IndexView()
                    );
                  } else if (apploadingState.result.pref.containsKey('onboard')) {
                    return RepositoryProvider(
                      create: (context) => GetIt.instance<UserRepository>(),
                      child: BlocProvider(
                        create: (context) =>
                            AuthCubit(),
                        child: const AuthNavigator(),
                      ),
                    );
                  } else if (!apploadingState.result.pref.containsKey('onboard')) {
                    return const OnboardPageView();
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
              return const AppSplashScreen();
            }
          }
      ),
    );
  }
}