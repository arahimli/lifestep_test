import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/logo.dart';
import 'package:lifestep/src/tools/components/error/general-widget.dart';
import 'package:lifestep/src/tools/components/shimmers/home-daily.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/cubits/global/session/state.dart';
import 'package:lifestep/src/cubits/global/settings/cubit.dart';
import 'package:lifestep/src/cubits/global/settings/state.dart';
import 'package:lifestep/src/cubits/global/step/donation/all/cubit.dart';
import 'package:lifestep/src/cubits/global/step/donation/month/cubit.dart';
import 'package:lifestep/src/cubits/global/step/donation/week/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step/all/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step/month/cubit.dart';
import 'package:lifestep/src/cubits/global/step/step/week/cubit.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/ui/home/components/charities.dart';
import 'package:lifestep/src/ui/index/logic/main/cubit.dart';
import 'package:lifestep/src/ui/index/logic/charity/cubit.dart';
import 'package:lifestep/src/ui/index/logic/charity/state.dart';
import 'package:lifestep/src/ui/index/logic/dailystep/cubit.dart';
import 'package:lifestep/src/ui/index/logic/dailystep/state.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/view.dart';
import 'package:lifestep/src/ui/index/logic/navigation_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

import 'components/carousel.dart';
import 'components/challenges.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {



  @override
  void initState() {

    BlocProvider.of<HomeLeaderBoardDonationCubit>(context).refresh();
    BlocProvider.of<HomeLeaderBoardStepCubit>(context).refresh();
    //////// print(responseData.data!.length);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    final formatterMain = DateFormat("d MMMM y", EasyLocalization.of(context)!.locale.languageCode);

    return WillPopScope(
      onWillPop: ()async{
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: MainColors.white,
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, state) {
                  return LogoAppBar(
                    textStyle: MainStyles.boldTextStyle.copyWith(fontSize: 24),
                  );
                }
              ),
              // const SizedBox(height: 4,),
              Flexible(
                flex: 1,
                child: RefreshIndicator(
                  onRefresh: ()async{
                    await BlocProvider.of<HomeLeaderBoardDonationCubit>(context).refresh();
                    await BlocProvider.of<HomeLeaderBoardStepCubit>(context).refresh();
                    await BlocProvider.of<IndexCubit>(context).refresh();
                    context.read<HomeCharityListCubit>().refresh();
                    context.read<HomeDailyStepCubit>().refresh();

                    context.read<GeneralUserLeaderBoardWeekDonationCubit>().refresh();
                    context.read<GeneralUserLeaderBoardMonthDonationCubit>().refresh();
                    context.read<GeneralUserLeaderBoardAllDonationCubit>().refresh();

                    context.read<GeneralUserLeaderBoardWeekStepCubit>().refresh();
                    context.read<GeneralUserLeaderBoardMonthStepCubit>().refresh();
                    context.read<GeneralUserLeaderBoardAllStepCubit>().refresh();

                    await BlocProvider.of<IndexCubit>(context).refresh();

                  },
                  child: ScrollConfiguration(
                    behavior: MainScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          Container(
                              // padding: PagePadding.leftRight16(),
                              child: CarouselWidget()
                          ),
                          const SizedBox(height: 40,),
                          Container(
                            padding: PagePadding.leftRight16(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                              text: Utils.getString(context, "home__today_text"),
                                              style: MainStyles.boldTextStyle.copyWith(color: MainColors.darkPink500,)
                                          ),
                                          TextSpan(
                                              text: " ${formatterMain.format(now)} ",
                                              style: MainStyles.boldTextStyle.copyWith()
                                          ),
                                        ]
                                    )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16,),
                          BlocBuilder<HomeDailyStepCubit, HomeDailyStepState>(
                            builder: (context, homeDailyStepState) {
                              return Container(
                                height: size.height * 10 / 100,
                                width: size.width,

                                child: ListView.separated(
                                  reverse: true,
                                  itemCount: 14,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, ind){

                                    final currentDate = DateTime.now().add(Duration(days: -(ind)));
                                    final formatter = DateFormat(DateFormat.ABBR_WEEKDAY, EasyLocalization.of(context)!.locale.languageCode);

                                    DateTime selectedDate = DateTime.now();
                                    int stepCount = 0;
                                    if(homeDailyStepState is HomeDailyStepSuccess){
                                      selectedDate = homeDailyStepState.selectedDate;
                                      stepCount = homeDailyStepState.stepCountDay;
                                    }
                                    else if(homeDailyStepState is HomeDailyStepSuccessLoading) {
                                      selectedDate = homeDailyStepState.selectedDate;
                                      stepCount = homeDailyStepState.stepCountDay;
                                    }
                                    return GestureDetector(
                                      onTap: (){
                                        if(!(homeDailyStepState is HomeDailyStepLoading || homeDailyStepState is HomeDailyStepSuccessLoading)){
                                          if (homeDailyStepState is HomeDailyStepSuccess && selectedDate.day != currentDate.day)
                                            context.read<HomeDailyStepCubit>().dateChanged( currentDate, stepCount);
                                        }
                                      },
                                      child: Container(
                                        height: size.height * 10 / 100,
                                        width: size.width * 20 / 100,
                                        margin: EdgeInsets.only(
                                          left: ind == 13 ? 16 : 0,
                                          right: ind == 0 ? 16 : 0,
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: DateTime.now().day == currentDate.day ? MainColors.darkPink500! : MainColors.middleGrey150!),
                                            borderRadius: BorderRadius.circular(8),
                                            color: selectedDate.day == currentDate.day ? MainColors.darkPink500 : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("${formatter.format(currentDate)}", style: MainStyles.boldTextStyle.copyWith(color: selectedDate.day == currentDate.day ? MainColors.white :MainColors.middleGrey400),
                                            ),
                                            Text(
                                              "${currentDate.day}", style: MainStyles.boldTextStyle.copyWith(color: selectedDate.day == currentDate.day ? MainColors.white : MainColors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, ind){
                                    return SizedBox(width: 8,);
                                  },
                                ),
                              );
                            }
                          ),
                          const SizedBox(height: 24,),
                          BlocBuilder<HomeDailyStepCubit, HomeDailyStepState>(
                            builder: (context, homeDailyStepState) {


                            DateTime selectedDate = DateTime.now();
                            int stepCount = 0;
                            if(homeDailyStepState is HomeDailyStepSuccess){
                              selectedDate = homeDailyStepState.selectedDate;
                              stepCount = homeDailyStepState.stepCountDay;
                            }
                            else if(homeDailyStepState is HomeDailyStepSuccessLoading) {
                              selectedDate = homeDailyStepState.selectedDate;
                              stepCount = homeDailyStepState.stepCountDay;
                            }

                            if(homeDailyStepState is HomeDailyStepSuccess) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/health');

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => SlidingUpPanelExample(
                                  //         )));
                                  // Navigator.pushNamed(context, "/health");
                                },

                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16
                                    ),
                                    decoration: BoxDecoration(
                                        color: MainColors.generalColor,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: BlocBuilder<SessionCubit, SessionState>(
                                            builder: (context, sessionState) {
                                              return CircularPercentIndicator(
                                                radius: 64.0,
                                                lineWidth: 8.0,
                                                animation: true,
                                                percent: sessionState.currentUser!.targetSteps != null && sessionState.currentUser!.targetSteps != 0 ? homeDailyStepState.stepCountDay < sessionState.currentUser!.targetSteps! ? homeDailyStepState.stepCountDay / sessionState.currentUser!.targetSteps! : 1 : 1,
                                                circularStrokeCap: CircularStrokeCap.round,
                                                progressColor: MainColors.darkPink500,
                                                backgroundColor: MainColors.white!,
                                              );
                                            }
                                          ),
                                        ),

                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        // text: "${homeDailyStepState.stepCountDay}",
                                                          text: "${ homeDailyStepState.stepCountDay != null && homeDailyStepState.stepCountDay.toString().length > 6 ? Utils.humanizeInteger(context, homeDailyStepState.stepCountDay) : homeDailyStepState.stepCountDay }",
                                                          style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 40),
                                                      ),
                                                      TextSpan(
                                                          text: " ${Utils.getString(context, "general__steps__count")}",
                                                          style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 14)
                                                      ),
                                                    ]
                                                )
                                            ),
                                            BlocBuilder<SettingsCubit, SettingsState>(
                                              builder: (context, settingsState) {
                                                return Container(
                                                  child: Text.rich(
                                                      TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                // text: "${homeDailyStepState.stepCountDay}",
                                                                text: "${ settingsState is  SettingsStateLoaded ? homeDailyStepState.stepCountDay != null ? Utils.humanizeDouble(context, Utils.stringToDouble(value: homeDailyStepState.stepCountDay.toString()) * (settingsState.settingsModel!.step)) : 0 : 0 }",
                                                                style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 14)
                                                            ),
                                                            TextSpan(
                                                                text: " ${Utils.getString(context, "general__money_text")}",
                                                                style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 14),
                                                            ),
                                                          ]
                                                      ),

                                                    textAlign: TextAlign.start,
                                                  ),
                                                );
                                              }
                                            ),
                                          ],
                                        ),

                                        SvgPicture.asset("assets/svgs/general/navigate-right.svg")
                                      ],
                                    )
                                ),
                              );
                            }else if(homeDailyStepState is HomeDailyStepLoading || homeDailyStepState is HomeDailyStepSuccessLoading){
                              return HomeDailyShimmerWidget();
                            }else if(homeDailyStepState is HomeDailyStepNotGranted){
                              return GeneralErrorLoadAgainWidget(
                                onTap: (){

                                    context.read<HomeDailyStepCubit>().dateChanged( selectedDate, stepCount);
                                },
                              );
                            }else{
                              return Container();
                            }
                          }
                          ),

                          const SizedBox(height: 24,),

                          Container(
                              padding: PagePadding.leftRight16(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText(Utils.getString(context, "home__challenges_title"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                                  InkWell(
                                      onTap: (){
                                        navigationBloc.changeNavigationIndex(Navigation.CHALLENGES);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        child: AutoSizeText(Utils.getString(context, "general__all"), style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),),
                                      )
                                  ),
                                ],
                              )
                          ),
                          const SizedBox(height: 16,),
                          HomeChallengeWidget(),
                          const SizedBox(height: 16,),

                          Container(
                              padding: PagePadding.leftRight16(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText(Utils.getString(context, "home__leaderboard_title"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                                  InkWell(
                                      onTap: (){
                                        Navigator.pushNamed(context, "/leaderboard");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        child: AutoSizeText(Utils.getString(context, "general__all"), style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),),
                                      )
                                  ),
                                ],
                              )
                          ),

                          const SizedBox(height: 12,),

                          const HomeLeaderBoardWidget(),

                          const SizedBox(height: 16,),

                          BlocBuilder<HomeCharityListCubit, HomeCharityListState>(
                              builder: (BuildContext context, state){
                                if(state is HomeCharityListSuccess || state is CharityUpdateListSuccess) {
                                  List<CharityModel> charityList = [];
                                  if(state is HomeCharityListSuccess){
                                    charityList = state.dataList ?? [];
                                  }else if(state is CharityUpdateListSuccess){
                                    charityList = state.dataList ?? [];
                                  }
                                  return charityList.isNotEmpty ? Container(
                                      padding: PagePadding.leftRight16(),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          AutoSizeText(Utils.getString(context, "home__charities_title"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                                          InkWell(
                                              onTap: (){
                                                navigationBloc.changeNavigationIndex(Navigation.DONATIONS);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                                child: AutoSizeText(Utils.getString(context, "general__all"), style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),),
                                              )),
                                        ],
                                      )
                                  ):
                                  Container();
                                }
                                else{
                                  return Container();
                                }

                              }
                          ),
                          const SizedBox(height: 12,),
                          HomeCharityListWidget(),
//
//                           BlocBuilder<IndexCubit,IndexState>(
//                             builder: (context, state) {
//                               return state is IndexLoaded ? GridView.builder(
//                                 padding: PagePadding.leftRight16(),
//                                 itemCount: state.indexPageModel.charityList.length,
//                                 physics: ScrollPhysics(),
//                                 shrinkWrap: true,
//                                 gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
// //                                        maxCrossAxisExtent: 220,
// //                                        childAspectRatio: 0.6
//                                   crossAxisCount: 2,
//                                   // childAspectRatio: 0.601,
//                                   mainAxisSpacing: 4.0,
//                                   crossAxisSpacing: 4.0,
//                                 ),
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return _DonationWidget(
//                                     index: index,
//                                     dataItem: state.indexPageModel.charityList[index],
//                                   );
//                                 },
//                               ):SizedBox();
//                             }
//                           ),
                          const SizedBox(height: 24,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

