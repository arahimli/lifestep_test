import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/common/confetti.dart';
import 'package:lifestep/tools/components/error/internet_error.dart';
import 'package:lifestep/tools/components/error/standard_error.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/logic/step/donation/all/cubit.dart';
import 'package:lifestep/logic/step/donation/month/cubit.dart';
import 'package:lifestep/logic/step/donation/week/cubit.dart';
import 'package:lifestep/logic/step/step-calculation/cubit.dart';
import 'package:lifestep/logic/step/step-calculation/state.dart';
import 'package:lifestep/logic/step/step/all/cubit.dart';
import 'package:lifestep/logic/step/step/month/cubit.dart';
import 'package:lifestep/logic/step/step/week/cubit.dart';
import 'package:lifestep/model/general/achievement-list.dart';
import 'package:lifestep/pages/apploading/splash-screen.dart';
import 'package:lifestep/pages/challenges/list/logic/cubit.dart';
import 'package:lifestep/pages/challenges/list/view.dart';
import 'package:lifestep/pages/donations/list/logic/charity_list_cubit.dart';
import 'package:lifestep/pages/donations/list/logic/fond_list_cubit.dart';
import 'package:lifestep/pages/donations/list/view.dart';
import 'package:lifestep/pages/home/view.dart';
import 'package:lifestep/pages/index/index/components/bottombar.dart';
import 'package:lifestep/pages/index/index/cubit.dart';
import 'package:lifestep/pages/index/index/navigation_bloc.dart';
import 'package:lifestep/pages/index/index/state.dart';
import 'package:lifestep/pages/user/profile/achievement/cubit.dart';
import 'package:lifestep/pages/user/profile/information/cubit.dart';
import 'package:lifestep/pages/user/profile/theme/cubit.dart';
import 'package:lifestep/pages/user/profile/view.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/donation.dart';

import 'logic/leaderboard/logic/donation/cubit.dart';
import 'logic/leaderboard/logic/step/cubit.dart';


class IndexView extends StatefulWidget {
  @override
  _IndexViewState createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {

  int _selectedIndex = 0;
  bool isConnectedToInternet = false;

  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    navigationBloc.changeNavigationIndex(Navigation.HOME);
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
                AppSplashScreen() :
                state is IndexError ?
                ErrorHappenedView() :
                state is AuthError ?
                ErrorHappenedView() :
                state is InternetError ?
                InternetConnectionErrorView() :
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
                        return AppSplashScreen();
                      }else if(settingsState is SettingsError){
                        return AppSplashScreen();
                      }else{

                        return Container(
                          child: BlocListener<GeneralStepCalculationCubit, GeneralStepCalculationState>(
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
                                }else if(state.balanceResult && state.userAchievementModels != null && state.userAchievementModels!.length > 0){
                                  for(UserAchievementModel item in state.userAchievementModels!){
                                    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 5));
                                    _controllerTopCenter.play();
                                    await Utils.showAchievementModal(context, size, _controllerTopCenter, title: item.description, image: item.imageUnlocked);
                                    _controllerTopCenter.stop();
                                  }
                                  // if(state.userAchievementModels != null && state.userAchievementModels!.length > 0){
                                  //
                                  // }
                                }
                              }
                            },
                            child: Stack(
                              children: [
                                StreamBuilder<Navigation>(
                                  initialData: Navigation.HOME,
                                  stream: navigationBloc.currentNavigationIndex,
                                  builder: (context, snapshot) {
                                    switch (snapshot.data!) {
                                      case Navigation.HOME:
                                      // return WhatsappPageView(/* ... */);
                                        return HomeView();
                                      case Navigation.DONATIONS:
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
                                            child: DonationListView()
                                        );
                                    // case Navigation.WHATSAPP:
                                    //   return WhatsappPageView(/* ... */);
                                      case Navigation.CHALLENGES:
                                        return MultiBlocProvider(
                                            providers: [

                                              BlocProvider<ChallengeListCubit>(
                                                create: (BuildContext context) => ChallengeListCubit(
                                                    challengeRepository: ChallengeRepository()
                                                ),
                                              ),
                                            ],
                                            child: ChallengeListView()
                                        );
                                      case Navigation.PROFILE:
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
                                            child: ProfileView(backPermit: false,)
                                        );
                                    // case Navigation.PROFILE:
                                    //   return MapsDemo();
                                    // return SampleNavigationApp();
                                    }
                                  },
                                ),
                              ],
                            ),
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
                    initialData: Navigation.HOME,
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
                                navigationBloc.changeNavigationIndex(Navigation.DONATIONS);
                              });
                            }
                          }
                        },
                      );
                    }): SizedBox();
              }
            ) : SizedBox();
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
        final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
      }

      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    }
  }

}



