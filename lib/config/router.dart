import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/pages/apploading/logic/cubit.dart';
import 'package:lifestep/pages/apploading/view.dart';
import 'package:lifestep/pages/health/details.dart';
import 'package:lifestep/pages/health/logic/month/cubit.dart';
import 'package:lifestep/pages/health/logic/today/cubit.dart';
import 'package:lifestep/pages/health/logic/week/cubit.dart';
import 'package:lifestep/pages/index/index/logic/charity/cubit.dart';
import 'package:lifestep/pages/index/index/logic/dailystep/cubit.dart';
import 'package:lifestep/pages/index/index/logic/leaderboard/logic/cubit.dart';
import 'package:lifestep/pages/index/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/pages/index/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/pages/index/index/view.dart';
import 'package:lifestep/pages/leaderboard/details.dart';
import 'package:lifestep/pages/leaderboard/logic/cubit.dart';
import 'package:lifestep/pages/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/pages/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/pages/notifications/logic/cubit.dart';
import 'package:lifestep/pages/notifications/view.dart';
import 'package:lifestep/pages/permission/health.dart';
import 'package:lifestep/pages/permission/standard.dart';
import 'package:lifestep/pages/user/login/view.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/home.dart';
import 'package:lifestep/repositories/static.dart';
import 'package:lifestep/repositories/step.dart';

import '../pages/index/index/cubit.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/apploading':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<ApploadingCubit>(create: (BuildContext context) => ApploadingCubit(authRepo: UserRepository(), staticRepository: StaticRepository(), ))
                  ],
                  child: AppLoadingView()
              ));
    case '/permission-list-health':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              HealthPermissionHandleView());
    case '/permission-list-standard':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              StandardPermissionHandleView());
    case '/index':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<IndexCubit>(create: (BuildContext context) => IndexCubit(homeRepository: HomeRepository())),
                    BlocProvider<HomeDailyStepCubit>(create: (BuildContext context) => HomeDailyStepCubit(authRepo: UserRepository(), sessionCubit: BlocProvider.of<SessionCubit>(context))),
                    BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: DonationRepository())),

                    BlocProvider<LeaderBoardHomeCubit>(
                        create: (BuildContext context) =>
                            LeaderBoardHomeCubit()),
                    BlocProvider<HomeLeaderBoardDonationCubit>(
                        create: (BuildContext context) =>
                            HomeLeaderBoardDonationCubit(
                                stepRepository: StepRepository())),
                    BlocProvider<HomeLeaderBoardStepCubit>(
                        create: (BuildContext context) =>
                            HomeLeaderBoardStepCubit(
                                stepRepository: StepRepository())),
                  ],
                  child: IndexView()
              ));
    case '/notification-list':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<NotificationListCubit>(create: (BuildContext context) => NotificationListCubit(
                      userRepository: UserRepository(),
                    )),
                  ],
                  child: NotificationListView()));
    case '/':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeDailyStepCubit>(create: (BuildContext context) => HomeDailyStepCubit(authRepo: UserRepository(), sessionCubit: BlocProvider.of<SessionCubit>(context))),
                    BlocProvider<IndexCubit>(create: (BuildContext context) => IndexCubit(homeRepository: HomeRepository())),
                    BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: DonationRepository())),
                    BlocProvider<LeaderBoardHomeCubit>(
                        create: (BuildContext context) =>
                            LeaderBoardHomeCubit()),
                    BlocProvider<HomeLeaderBoardDonationCubit>(
                        create: (BuildContext context) =>
                            HomeLeaderBoardDonationCubit(
                                stepRepository: StepRepository())),
                    BlocProvider<HomeLeaderBoardStepCubit>(
                        create: (BuildContext context) =>
                            HomeLeaderBoardStepCubit(
                                stepRepository: StepRepository())),
                  ],
                  child: IndexView()
              ));
    case '/health':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<HealthTodayCubit>(create: (context) => HealthTodayCubit(

                    )),
                    BlocProvider<HealthWeekCubit>(create: (context) => HealthWeekCubit(

                    )),
                    BlocProvider<HealthMonthCubit>(create: (context) => HealthMonthCubit(

                    )),
                  ],
                  child: HealthDetailView()));
    case '/leaderboard':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<LeaderBoardDonationCubit>(create: (context) => LeaderBoardDonationCubit(
                      stepRepository: StepRepository()
                    )),
                    BlocProvider<LeaderBoardStepCubit>(create: (context) => LeaderBoardStepCubit(
                      stepRepository: StepRepository()
                    )),
                    BlocProvider<LeaderBoardDetailCubit>(create: (context) => LeaderBoardDetailCubit(
                    )),

                  ],
                  child: LeaderBoardDetailView()));
    case '/auth':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AuthView());


    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeDailyStepCubit>(create: (BuildContext context) => HomeDailyStepCubit(authRepo: UserRepository(), sessionCubit: BlocProvider.of<SessionCubit>(context))),
                    BlocProvider<IndexCubit>(create: (BuildContext context) => IndexCubit(homeRepository: HomeRepository())),

                    BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: DonationRepository())),
                    BlocProvider<LeaderBoardHomeCubit>(
                        create: (BuildContext context) =>
                            LeaderBoardHomeCubit()),
                    BlocProvider<HomeLeaderBoardDonationCubit>(
                        create: (BuildContext context) =>
                            HomeLeaderBoardDonationCubit(
                                stepRepository: StepRepository())),
                    BlocProvider<HomeLeaderBoardStepCubit>(
                        create: (BuildContext context) =>
                            HomeLeaderBoardStepCubit(
                                stepRepository: StepRepository())),
                  ],
                  child: IndexView()
              ));
  }
}