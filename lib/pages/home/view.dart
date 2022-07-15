import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/appbar/logo.dart';
import 'package:lifestep/tools/components/error/general-widget.dart';
import 'package:lifestep/tools/components/shimmers/home-charity/donation-grid-item.dart';
import 'package:lifestep/tools/components/shimmers/home-charity/home-charity-grid.dart';
import 'package:lifestep/tools/components/shimmers/home-daily.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/session/state.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/logic/step/donation/all/cubit.dart';
import 'package:lifestep/logic/step/donation/month/cubit.dart';
import 'package:lifestep/logic/step/donation/week/cubit.dart';
import 'package:lifestep/logic/step/step/all/cubit.dart';
import 'package:lifestep/logic/step/step/month/cubit.dart';
import 'package:lifestep/logic/step/step/week/cubit.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/pages/challenges/details/logic/deatil_cubit.dart';
import 'package:lifestep/pages/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/pages/challenges/details/view.dart';
import 'package:lifestep/pages/challenges/preview_map/logic/cubit.dart';
import 'package:lifestep/pages/donations/details/personal/logic/deatil_cubit.dart';
import 'package:lifestep/pages/donations/details/personal/logic/donors/cubit.dart';
import 'package:lifestep/pages/donations/details/personal/view.dart';
import 'package:lifestep/pages/index/logic/main/cubit.dart';
import 'package:lifestep/pages/index/logic/charity/cubit.dart';
import 'package:lifestep/pages/index/logic/charity/state.dart';
import 'package:lifestep/pages/index/logic/dailystep/cubit.dart';
import 'package:lifestep/pages/index/logic/dailystep/state.dart';
import 'package:lifestep/pages/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/pages/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/pages/index/logic/leaderboard/view.dart';
import 'package:lifestep/pages/index/logic/navigation_bloc.dart';
import 'package:lifestep/pages/index/logic/main/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sprintf/sprintf.dart';
import 'package:lifestep/tools/general/padding/page-padding.dart';

import 'components/carousel.dart';

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
              // SizedBox(height: 4,),
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
                          SizedBox(height: 40,),
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
                          SizedBox(height: 16,),
                          BlocBuilder<HomeDailyStepCubit, HomeDailyStepState>(
                            builder: (context, homeDailyStepState) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
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
                          SizedBox(height: 24,),
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
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16
                                    ),
                                    padding: EdgeInsets.symmetric(
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


                          SizedBox(height: 24,),
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
                                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        child: AutoSizeText(Utils.getString(context, "general__all"), style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),),
                                      )
                                  ),
                                ],
                              )
                          ),

                          SizedBox(height: 12,),

                          HomeLeaderBoardWidget(),

                          SizedBox(height: 16,),

                          BlocBuilder<HomeCharityListCubit, HomeCharityListState>(
                              builder: (BuildContext context, state){
                                if(state is HomeCharityListSuccess || state is CharityUpdateListSuccess) {
                                  List<CharityModel> charityList = [];
                                  if(state is HomeCharityListSuccess){
                                    charityList = state.dataList ?? [];
                                  }else if(state is CharityUpdateListSuccess){
                                    charityList = state.dataList ?? [];
                                  }
                                  return charityList.length > 0 ? Container(
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
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                          SizedBox(height: 12,),
                          BlocBuilder<HomeCharityListCubit, HomeCharityListState>(
                              builder: (BuildContext context, state){
                                if(state is HomeCharityListSuccess || state is CharityUpdateListSuccess) {
                                  List<CharityModel> charityList = [];
                                  if(state is HomeCharityListSuccess){
                                    charityList = state.dataList ?? [];
                                  }else if(state is CharityUpdateListSuccess){
                                    charityList = state.dataList ?? [];
                                  }
                                  return charityList.length > 0 ? GridView.builder(
                                    padding: PagePadding.leftRight16(),
                                    itemCount: charityList.length,
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
//                                        maxCrossAxisExtent: 220,
//                                        childAspectRatio: 0.6
                                      crossAxisCount: 2,
                                      // childAspectRatio: 0.601,
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                    ),
                                    itemBuilder: (BuildContext context, int index) {
                                      return _DonationWidget(
                                        dataList: charityList,
                                        index: index,
                                        dataItem: charityList[index],
                                      );
                                    },
                                  ):
                                  Container();
                                }
                                else if(state is HomeCharityListError){
                                  return Padding(
                                    padding: PagePadding.leftRight16(),
                                    child: GeneralErrorLoadAgainWidget(
                                      onTap: (){
                                        context.read<HomeCharityListCubit>().refresh();
                                      },
                                    ),
                                  );
                                }
                                else{
                                  return HomeSkeletonGridViewWidget(
                                    itemCount: 2,
                                    child: ChairtyListItemShimmerWidget(),
                                  );
                                }

                              }
                          ),
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
                          SizedBox(height: 24,),

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
                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      child: AutoSizeText(Utils.getString(context, "general__all"), style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),),
                                    )
                                  ),
                                ],
                              )
                          ),
                          SizedBox(height: 16,),
                          // BlocBuilder<IndexCubit,IndexState>(
                          //   builder: (context, state) {
                          //     return state is IndexLoaded ? ListView.separated(
                          //       separatorBuilder: (BuildContext context, int index) {
                          //         return SizedBox(height: 4,);
                          //       },
                          //       padding: PagePadding.leftRight16(),
                          //       itemCount: state.indexPageModel.fondList.length,
                          //       physics: ScrollPhysics(),
                          //       shrinkWrap: true,
                          //       itemBuilder: (BuildContext context, int index) {
                          //         return _FondWidget(
                          //           index: index,
                          //           dataItem: state.indexPageModel.fondList[index],
                          //         );
                          //       },
                          //     ): SizedBox();
                          //   }
                          // ),
                          BlocBuilder<IndexCubit,IndexState>(
                            builder: (context, state) {
                              return state is IndexLoaded ? ListView.separated(
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(height: 4,);
                                },
                                padding: PagePadding.leftRight16(),
                                itemCount: state.indexPageModel.challengeList.length,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return _ChallengeWidget(
                                    index: index,
                                    dataItem: state.indexPageModel.challengeList[index],
                                  );
                                },
                              ): SizedBox();
                            }
                          ),
                          SizedBox(height: 16,),
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

class _DonationWidget extends StatelessWidget {
  final List<CharityModel> dataList;
  final CharityModel dataItem;
  final int index;
  const _DonationWidget({Key? key, required this.dataItem, required this.index, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> MultiBlocProvider(
              providers: [
                BlocProvider<CharityDetailsBloc>(create: (context) => CharityDetailsBloc(
                    charityModel: dataItem,
                    donationRepository: GetIt.instance<DonationRepository>()
                )),
                BlocProvider<DonorListCubit>(create: (context) => DonorListCubit(
                    charityModel: dataItem,
                    donationRepository: GetIt.instance<DonationRepository>()
                )),
              ],
              child: DonationPersonalDetailView()))).then((value){
            if(value != null ){
              BlocProvider.of<HomeLeaderBoardDonationCubit>(context).refresh();
              BlocProvider.of<HomeLeaderBoardStepCubit>(context).refresh();
              BlocProvider.of<HomeCharityListCubit>(context).changeCharity(listValue: dataList, value: value, index: index);
            }
          });
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: MainColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(
                        width: size.width * 0.8 / 6,
                        height: size.width * 0.8 / 6,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          image: DecorationImage(
                            image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                          BorderRadius.all(
                            Radius.circular(500.0),
                          ),
                        ),
                      );
                    },
                    // key: Key("${"vvvvv"}${1}"),
                    // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                    fit: BoxFit.cover,
                    imageUrl: dataItem.image ?? MainConfig.defaultImage,
                    width: size.width * 0.8 / 6,
                    height: size.width * 0.8 / 6,
                  )
              ),


              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8),
                    AutoSizeText(
                      dataItem.name ?? '-',
                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    AutoSizeText(
                      "${dataItem.requiredSteps <= dataItem.presentSteps ? 0 : Utils.humanizeInteger(context, dataItem.requiredSteps - dataItem.presentSteps)} ${Utils.getString(context, "general__steps__count")}",
                      style: MainStyles.boldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 14, height: 1.1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AutoSizeText(
                      Utils.getString(context, "home__charity_list_subtitle"),
                      style: MainStyles.boldTextStyle.copyWith(color: MainColors.mainGrayColor, fontSize: 14, height: 1.1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeWidget extends StatelessWidget {
  final ChallengeModel dataItem;
  final int index;
  const _ChallengeWidget({Key? key, required this.dataItem, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MultiBlocProvider(
              providers: [
                BlocProvider<ChallengeDetailBloc>(create: (context) => ChallengeDetailBloc(
                    challengeModel: dataItem,
                    challengeRepository: ChallengeRepository()
                )),
                BlocProvider<ParticipantListCubit>(create: (context) => ParticipantListCubit(
                    challengeModel: dataItem,
                    challengeRepository: ChallengeRepository()
                )),

                BlocProvider<PreviewPolylineMapCubit>(
                    create: (
                        BuildContext context) =>
                        PreviewPolylineMapCubit(
                          challengeRepository: ChallengeRepository(),
                          challengeModel: dataItem,
                        )),
              ],
              child: ChallengeDetailView())));

        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: MainColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(

                        // child:
                        // CircularProgressIndicator(
                        //   valueColor:
                        //   AlwaysStoppedAnimation<Color>(
                        //       Colors.orange),
                        // ),
                        width: size.width * 0.6 / 6,
                        height: size.width * 0.6 / 6,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          image: DecorationImage(
                            image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                          BorderRadius.all(
                            Radius.circular(500.0),
                          ),
                        ),
                      );
                    },
                    // key: Key("${"vvvvv"}${1}"),
                    // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                    fit: BoxFit.cover,
                    imageUrl: dataItem.image ?? MainConfig.defaultImage,
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  )),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      AutoSizeText(
                        dataItem.name ?? '',
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      AutoSizeText(
                        "${sprintf(Utils.getString(context, "challenges_view___date_pattern"), [dataItem.endDate != null ? Utils.stringToDatetoString(value: dataItem.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-'])}",
                        style: MainStyles.boldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 14, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.black,)
            ],
          ),
        ),
      ),
    );
  }
}
