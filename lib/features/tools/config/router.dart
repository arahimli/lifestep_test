import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/features/main_app/data/repositories/donation/repository.dart';
import 'package:lifestep/features/main_app/data/repositories/home/repository.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/main_app/data/models/arguments/challenge_detail_view.dart';
import 'package:lifestep/features/main_app/data/models/arguments/charity_detail_view.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/presentation/pages/apploading/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/apploading/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/deatil_cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants_step_base/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/step_base_stage/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/preview_map/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/personal/logic/deatil_cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/personal/logic/donors/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/personal/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/details.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/month/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/today/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/week/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/challenge/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/charity/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/dailystep/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/main/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/details.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/notifications/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/notifications/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/permission/health.dart';
import 'package:lifestep/features/main_app/presentation/pages/permission/standard.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/block/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/delete/by_admin_view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/delete/info/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/delete/otp/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/delete/otp/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/history/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/history/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/login/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/otp/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/static.dart';
import 'package:lifestep/features/main_app/resources/step.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/apploading':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<ApploadingCubit>(create: (BuildContext context) => ApploadingCubit(authRepo: GetIt.instance<UserRepository>(), staticRepository: GetIt.instance<StaticRepository>(), ))
                  ],
                  child: const AppLoadingView()
              ));
    case '/permission-list-health':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
          const HealthPermissionHandleView());
    case '/permission-list-standard':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              const StandardPermissionHandleView());
    case '/index':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<IndexCubit>(create: (BuildContext context) => IndexCubit(homeRepository: GetIt.instance<HomeRepository>())),
                    BlocProvider<HomeDailyStepCubit>(create: (BuildContext context) => HomeDailyStepCubit(authRepo: GetIt.instance<UserRepository>(), sessionCubit: BlocProvider.of<SessionCubit>(context))),
                    BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: GetIt.instance<DonationRepository>())),
                    BlocProvider<HomeChallengeListCubit>(create: (BuildContext context) => HomeChallengeListCubit(challengeRepository: GetIt.instance<ChallengeRepository>())),

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
              ));
    case '/':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeDailyStepCubit>(create: (BuildContext context) => HomeDailyStepCubit(authRepo: GetIt.instance<UserRepository>(), sessionCubit: BlocProvider.of<SessionCubit>(context))),
                    BlocProvider<IndexCubit>(create: (BuildContext context) => IndexCubit(homeRepository: GetIt.instance<HomeRepository>())),
                    BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: GetIt.instance<DonationRepository>())),
                    BlocProvider<HomeChallengeListCubit>(create: (BuildContext context) => HomeChallengeListCubit(challengeRepository: GetIt.instance<ChallengeRepository>())),

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
              ));
    case DonationHistoryView.routeName:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<DonationHistoryListBloc>(create: (BuildContext context) => DonationHistoryListBloc(
                      donationRepository: GetIt.instance<DonationRepository>(),
                    )),
                  ],
                  child: const DonationHistoryView()
              )
      );
    case NotificationListView.routeName:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<NotificationListCubit>(create: (BuildContext context) => NotificationListCubit(
                      userRepository: GetIt.instance<UserRepository>(),
                    )),
                  ],
                  child: const NotificationListView())
      );
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
                  child: const HealthDetailView()));
    case '/leaderboard':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<LeaderBoardDonationCubit>(create: (context) => LeaderBoardDonationCubit(
                      stepRepository: GetIt.instance<StepRepository>()
                    )),
                    BlocProvider<LeaderBoardStepCubit>(create: (context) => LeaderBoardStepCubit(
                      stepRepository: GetIt.instance<StepRepository>()
                    )),
                    BlocProvider<LeaderBoardDetailCubit>(create: (context) => LeaderBoardDetailCubit(
                    )),

                  ],
                  child: const LeaderBoardDetailView()));
    case '/auth':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
          const AuthView());

    case '/user-blocked':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
          const UserBlockedView());


    case '/user-removed-by-admin':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
          const UserRemovedByAdminView());

    case '/otp-remove':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<OtpRemoveCubit>(create: (BuildContext context) => OtpRemoveCubit(authRepo: GetIt.instance<UserRepository>())),
                    BlocProvider(
                      create: (context) => OtpNumpadCubit(
                      ),
                    ),
                  ],
                  child: const OtpRemoveView()
              )
      );

    case '/info-remove':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
          const InfoRemoveView());
    case ChallengeDetailView.routeName:{

        final args = settings.arguments as ChallengeDetailViewArguments;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
                MultiBlocProvider(
                    providers: [
                      BlocProvider<ChallengeDetailBloc>(create: (context) => ChallengeDetailBloc(
                          challengeModel: args.dataItem,
                          challengeRepository: GetIt.instance<ChallengeRepository>()
                      )),
                      BlocProvider<ParticipantListCubit>(create: (context) => ParticipantListCubit(
                          challengeModel: args.dataItem,
                          challengeRepository: GetIt.instance<ChallengeRepository>()
                      )),
                      BlocProvider<StepBaseParticipantListCubit>(create: (context) => StepBaseParticipantListCubit(
                          challengeModel: args.dataItem,
                          challengeRepository: GetIt.instance<ChallengeRepository>()
                      )),
                      BlocProvider<StepBaseStageCubit>(create: (context) => StepBaseStageCubit(
                          challengeModel: args.dataItem,
                          challengeRepository: GetIt.instance<ChallengeRepository>()
                      )),

                      BlocProvider<PreviewPolylineMapCubit>(
                          create: (
                              BuildContext context) =>
                              PreviewPolylineMapCubit(
                                challengeRepository: GetIt.instance<ChallengeRepository>(),
                                challengeModel: args.dataItem,
                              )),
                    ],
                    child: const ChallengeDetailView()
                )
        );
    }
    case CharityDetailView.routeName:{

        final args = settings.arguments as CharityDetailViewArguments;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
                MultiBlocProvider(
                    providers: [
                      BlocProvider<CharityDetailsBloc>(create: (context) => CharityDetailsBloc(
                          charityModel: args.dataItem,
                          donationRepository: GetIt.instance<DonationRepository>()
                      )),
                      BlocProvider<DonorListCubit>(create: (context) => DonorListCubit(
                          charityModel: args.dataItem,
                          donationRepository: GetIt.instance<DonationRepository>()
                      )),
                    ],
                    child: const CharityDetailView()
                )
        );
    }

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeDailyStepCubit>(create: (BuildContext context) => HomeDailyStepCubit(authRepo: GetIt.instance<UserRepository>(), sessionCubit: BlocProvider.of<SessionCubit>(context))),
                    BlocProvider<IndexCubit>(create: (BuildContext context) => IndexCubit(homeRepository: GetIt.instance<HomeRepository>())),
                    BlocProvider<HomeCharityListCubit>(create: (BuildContext context) => HomeCharityListCubit(donationRepository: GetIt.instance<DonationRepository>())),
                    BlocProvider<HomeChallengeListCubit>(create: (BuildContext context) => HomeChallengeListCubit(challengeRepository: GetIt.instance<ChallengeRepository>())),

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
              ));
  }
}