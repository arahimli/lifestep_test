import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/error/internet_error.dart';
import 'package:lifestep/src/tools/components/error/standard_error.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/cubits/global/settings/cubit.dart';
import 'package:lifestep/src/cubits/global/settings/state.dart';
import 'package:lifestep/src/cubits/global/step/donation/all/cubit.dart';
import 'package:lifestep/src/cubits/global/step/donation/month/cubit.dart';
import 'package:lifestep/src/cubits/global/step/donation/week/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step-calculation/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step-calculation/state.dart';
import 'package:lifestep/src/cubits/global/step/step/all/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step/month/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step/week/cubit.dart';
import 'package:lifestep/src/models/general/achievement_list.dart';
import 'package:lifestep/src/ui/splash/view.dart';
import 'package:lifestep/src/ui/challenges/list/logic/cubit.dart';
import 'package:lifestep/src/ui/challenges/list/view.dart';
import 'package:lifestep/src/ui/donations/list/logic/charity_list_cubit.dart';
import 'package:lifestep/src/ui/donations/list/logic/fond_list_cubit.dart';
import 'package:lifestep/src/ui/donations/list/view.dart';
import 'package:lifestep/src/ui/home/view.dart';
import 'package:lifestep/src/ui/index/components/bottombar.dart';
import 'package:lifestep/src/ui/index/logic/main/cubit.dart';
import 'package:lifestep/src/ui/index/logic/navigation_bloc.dart';
import 'package:lifestep/src/ui/index/logic/main/state.dart';
import 'package:lifestep/src/ui/user/profile/achievement/cubit.dart';
import 'package:lifestep/src/ui/user/profile/information/cubit.dart';
import 'package:lifestep/src/ui/user/profile/theme/cubit.dart';
import 'package:lifestep/src/ui/user/profile/view.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/resources/donation.dart';

import 'logic/leaderboard/logic/donation/cubit.dart';
import 'logic/leaderboard/logic/step/cubit.dart';


class IndexView extends StatefulWidget {
  const IndexView({Key? key}) : super(key: key);
  @override
  _IndexViewState createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {

  bool isConnectedToInternet = false;

  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    navigationBloc.changeNavigationIndex(Navigation.home);
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 5));
    super.initState();
  }
  // @override
  // void didChangeDependencies(){
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    _controllerTopCenter.dispose();
  }

  // Future<bool> _onWillPop() async{
  //   return await showDialog<bool>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ConfirmDialogView(
  //             description:
  //             Utils.getString(context, 'home__quit_dialog_description'),
  //             leftButtonText:
  //             Utils.getString(context, 'app_info__cancel_button_name'),
  //             rightButtonText: Utils.getString(context, 'dialog__ok'),
  //             onAgreeTap: () {
  //               SystemNavigator.pop();
  //             });
  //       }) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Scaffold(
        // drawer: DrawerWidget(),
        body: Stack(
          children: [
            BlocBuilder<IndexCubit, IndexState>(
              builder: (context, state) {
                return
                state is IndexLoading ?
                const AppSplashScreen() :
                state is IndexError ?
                const ErrorHappenedView() :
                state is AuthError ?
                const ErrorHappenedView() :
                state is InternetError ?
                const InternetConnectionErrorView() :
                BlocConsumer<SettingsCubit, SettingsState>(
                  listener: (context, settingsState){
                      if(settingsState is SettingsStateLoaded) {
                        SessionCubit sessionCubit = BlocProvider.of<
                            SessionCubit>(context);
                        if (sessionCubit.currentUser != null &&
                            settingsState.settingsModel != null) {
                          if (sessionCubit.currentUser!.balanceSteps! >=
                              settingsState.settingsModel!.balanceLimit) {
                            Utils.showBalanceBlockedModal(context, size);
                          }
                        }
                      }
                    },
                    builder: (context, settingsState) {
                      if(settingsState is SettingsLoading){
                        return const AppSplashScreen();
                      }else if(settingsState is SettingsError){
                        return const AppSplashScreen();
                      }else{

                        return BlocListener<GeneralStepCalculationCubit, GeneralStepCalculationState>(
                          listener: (context, state) async{
                            if (state is GeneralStepCalculationSuccess){
                              // print("state_userAchievementModels");
                              // print(state.userAchievementModels);
                              // print(state.dailyResult);
                              // print(state.balanceResult);
                              if(state.dailyResult){
                                BlocProvider.of<HomeLeaderBoardDonationCubit>(context).refresh();
                                BlocProvider.of<HomeLeaderBoardStepCubit>(context).refresh();
                                context.read<GeneralUserLeaderBoardWeekDonationCubit>().refresh();
                                context.read<GeneralUserLeaderBoardMonthDonationCubit>().refresh();
                                context.read<GeneralUserLeaderBoardAllDonationCubit>().refresh();

                                context.read<GeneralUserLeaderBoardWeekStepCubit>().refresh();
                                context.read<GeneralUserLeaderBoardMonthStepCubit>().refresh();
                                context.read<GeneralUserLeaderBoardAllStepCubit>().refresh();
                              }else if(state.balanceResult && state.userAchievementModels != null && state.userAchievementModels!.isNotEmpty){
                                for(UserAchievementModel item in state.userAchievementModels!){
                                  _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 5));
                                  _controllerTopCenter.play();
                                  await Utils.showAchievementModal(context, size, _controllerTopCenter, title: item.description, image: item.imageUnlocked);
                                  _controllerTopCenter.stop();
                                }
                                // if(state.userAchievementModels != null && state.userAchievementModels!.isNotEmpty){
                                //
                                // }
                              }
                            }else if(state is GeneralStepCalculationError){

                              switch (state.errorCode) {
                                case WEB_SERVICE_ENUM.DELETED:
                                  {
                                    Navigator.pushReplacementNamed(context, "/user-removed-by-admin");
                                  }
                                  break;
                                case WEB_SERVICE_ENUM.BLOCK:
                                  {
                                    Navigator.pushReplacementNamed(context, "/user-blocked");
                                  }
                                  break;
                                case WEB_SERVICE_ENUM.INTERNET_ERROR:
                                  {
                                    Utils.showErrorModal(context, size,
                                        errorCode: WEB_SERVICE_ENUM.INTERNET_ERROR,
                                        title: Utils.getString(
                                            context, "internet_connection_error"));
                                    //////// print("internet error");
                                  }
                                  break;
                                default:
                                  {
                                    Utils.showErrorModal(context, size,
                                        errorCode: state.errorCode,
                                        title: Utils.getString(
                                            context, "error_went_wrong"));
                                  }
                                  break;
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              StreamBuilder<Navigation>(
                                initialData: Navigation.home,
                                stream: navigationBloc.currentNavigationIndex,
                                builder: (context, snapshot) {
                                  switch (snapshot.data!) {
                                    case Navigation.home:
                                    // return WhatsappPageView(/* ... */);
                                      return const HomeView();
                                    case Navigation.donations:
                                    // Here a thing... as you wanna change the page in another widget
                                    // you pass the bloc to this new widget for it's capable to change
                                    // navigation values as you desire.
                                      return MultiBlocProvider(
                                          providers: [

                                            BlocProvider<CharityListCubit>(
                                              create: (BuildContext context) => CharityListCubit(
                                                  donationRepository: GetIt.instance<DonationRepository>()
                                              ),
                                            ),
                                            BlocProvider<FondListCubit>(
                                              create: (BuildContext context) => FondListCubit(
                                                  donationRepository: GetIt.instance<DonationRepository>()
                                              ),
                                            ),
                                          ],
                                          child: const DonationListView()
                                      );
                                  // case Navigation.WHATSAPP:
                                  //   return WhatsappPageView(/* ... */);
                                    case Navigation.challenges:
                                      return MultiBlocProvider(
                                          providers: [

                                            BlocProvider<ChallengeListCubit>(
                                              create: (BuildContext context) => ChallengeListCubit(
                                                  challengeRepository: GetIt.instance<ChallengeRepository>()
                                              ),
                                            ),
                                          ],
                                          child: const ChallengeListView()
                                      );
                                    case Navigation.profile:
                                      return MultiBlocProvider(
                                          providers: [

                                            BlocProvider<ProfileInformationCubit>(
                                              create: (BuildContext context) => ProfileInformationCubit(
                                                  sessionCubit: BlocProvider.of<SessionCubit>(context),
                                                  authRepo: GetIt.instance<UserRepository>()
                                              ),
                                            ),

                                            BlocProvider<AchievementListCubit>(
                                              create: (BuildContext context) => AchievementListCubit(
                                                  authRepo: GetIt.instance<UserRepository>()
                                              ),
                                            ),

                                            BlocProvider<ThemeCubit>(
                                              create: (BuildContext context) => ThemeCubit(
                                              ),
                                            ),
                                          ],
                                          child: const ProfileView(backPermit: false,)
                                      );
                                  // case Navigation.challenges:
                                  //   return MapsDemo();
                                  // return SampleNavigationApp();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  );
              }
            ),

          ],
        ),
        bottomNavigationBar: BlocBuilder<IndexCubit, IndexState>(
          builder: (context, indexState) {
            return indexState is IndexLoaded  ? BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                return settingsState is SettingsStateLoaded ? StreamBuilder<Navigation>(
                    initialData: Navigation.home,
                    stream: navigationBloc.currentNavigationIndex,
                    builder: (context, snapshotIndex) {

                      return MainBottomNavigationBar(
                        index: Utils.getTabIndex(snapshotIndex.data!),
                        onAction: (){
                          SessionCubit sessionCubit = BlocProvider.of<SessionCubit>(context);
                          if( sessionCubit.currentUser != null && settingsState.settingsModel != null){
                            if (sessionCubit.currentUser!.balanceSteps! >= settingsState.settingsModel!.balanceLimit){
                              Utils.showBalanceBlockedModal(context, size, onTap: (){
                                Navigator.pop(context);
                                navigationBloc.changeNavigationIndex(Navigation.donations);
                              });
                            }
                          }
                        },
                      );
                    }): const SizedBox();
              }
            ) : const SizedBox();
          }
        ),
      );
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initTrackingPlugin() async {
    if(Platform.isIOS){
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
        // Wait for dialog popping animation
        await Future.delayed(const Duration(milliseconds: 200));
        // Request system's tracking authorization dialog
        // final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
      }

      // final uuid =
      await AppTrackingTransparency.getAdvertisingIdentifier();
    }
  }

}



