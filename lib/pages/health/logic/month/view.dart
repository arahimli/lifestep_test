
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/page-messages/list-message.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/pages/health/components/health_info.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:lifestep/pages/health/logic/month/state.dart';
import 'package:lifestep/repositories/service/web_service.dart';

import 'cubit.dart';

class HealthMonthView extends StatefulWidget {
  final ScrollController scrollController;
  const HealthMonthView({Key? key, required this.scrollController}) : super(key: key);

  @override
  HealthMonthViewState createState() => HealthMonthViewState();
}

class HealthMonthViewState extends State<HealthMonthView> {


  final List<_MonthChartData> data = [
    _MonthChartData(
        month: 1,
        step: 10000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 2,
        step: 8000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.darkPink500!)
    ),
    _MonthChartData(
        month: 3,
        step: 9234,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 4,
        step: 2000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 5,
        step: 1543,
        barColor: charts.ColorUtil.fromDartColor(MainColors.darkBlue500!)
    ),
    _MonthChartData(
        month: 6,
        step: 20000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.darkPink500!)
    ),
    _MonthChartData(
        month: 7,
        step: 18900,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 8,
        step: 13000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.darkPink500!)
    ),
    _MonthChartData(
        month: 9,
        step: 17890,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 10,
        step: 5000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 11,
        step: 12000,
        barColor: charts.ColorUtil.fromDartColor(MainColors.middleGrey400!)
    ),
    _MonthChartData(
        month: 12,
        step: 6666,
        barColor: charts.ColorUtil.fromDartColor(MainColors.darkBlue500!)
    ),

  ];
  _getSeriesData() {
    List<charts.Series<_MonthChartData, String>> series = [
      charts.Series(
          id: "Population",
          data: data,
          domainFn: (_MonthChartData series, _) => series.month.toString(),
          measureFn: (_MonthChartData series, _) => series.step,
          colorFn: (_MonthChartData series, _) => series.barColor
      )
    ];
    return series;
  }

  void _scrollDown() {
    widget.scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<HealthMonthCubit, HealthMonthState>(
      listener: (context, healthMonthState)async{
        if(healthMonthState is HealthMonthSuccess || healthMonthState is HealthMonthSuccessLoading) {
          await Future.delayed(Duration(milliseconds: 11));
          // print("if(healthMon");
          // if (scrollController.hasClients)
          // scrollController.jumpTo(0);

          widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 10),
              curve: Curves.fastOutSlowIn);
        }
      },
      builder: (context, healthMonthState) {

        if(healthMonthState is HealthMonthSuccess || healthMonthState is HealthMonthSuccessLoading) {
          return ScrollConfiguration(
            behavior: MainScrollBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [

                    SizedBox(height: 8,),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      height: 50,
                      width: size.width,

                      child: Scrollbar(

                        isAlwaysShown: false,
                        showTrackOnHover: false,
                        controller: widget.scrollController,
                        thickness: 0,
                        child: ListView.separated(
                          // reverse: DateTime.now().month > 3 ? true : false,
                          controller: widget.scrollController,
                          itemCount: DateTime.now().month,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, ind){

                            int selectedMonth = DateTime.now().month;
                            if(healthMonthState is HealthMonthSuccess) {
                              selectedMonth = healthMonthState.selectedMonth;
                            }
                            if(healthMonthState is HealthMonthSuccessLoading){
                              selectedMonth = healthMonthState.selectedMonth;
                            }
                            return GestureDetector(
                              onTap: (){
                                //////// print(healthMonthState);
                                //////// print(healthMonthState);
                                if(healthMonthState is HealthMonthSuccess && selectedMonth != (ind + 1))
                                  context.read<HealthMonthCubit>().dateChanged(ind + 1);
                              },
                              child: Container(
                                height: 50,
                                width: size.width * 25 / 100,
                                decoration: BoxDecoration(
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${Utils.getString(context, "general_month__${(ind + 1).toString()}")}", style: MainStyles.extraBoldTextStyle.copyWith(color: selectedMonth == (ind + 1) ? null : MainColors.middleGrey200, fontSize: 32),
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
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: BoxDecoration(
                        color: MainColors.white,
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(color: MainColors.darkPink500!, width: 2)
                      ),
                      child: Column(
                        children: [

                          if(healthMonthState is HealthMonthSuccess)
                            Row(
                              children: [
                                Expanded(
                                    child: BlocBuilder<SettingsCubit, SettingsState>(
                                        builder: (context, settingsState) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(color: MainColors
                                                        .middleGrey200!)
                                                )
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  // color:Colors.red,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Text(
                                                        settingsState is  SettingsStateLoaded ? "${healthMonthState.stepCount != null ? Utils.humanizeDouble(context, Utils.stringToDouble(value: healthMonthState.stepCount.toString()) * (settingsState.settingsModel!.step)) : 0 }" : "",
                                                        style: MainStyles.boldTextStyle
                                                            .copyWith(fontSize: 24),
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: 4.0),
                                                        child: Text(
                                                          " ${Utils.getString(context,
                                                              "general__money_text")
                                                              .toUpperCase()}",
                                                          style: MainStyles
                                                              .boldTextStyle.copyWith(
                                                              fontSize: 12),
                                                          textAlign: TextAlign.left,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 8,),
                                                AutoSizeText(
                                                  Utils.getString(context,
                                                      "health_detail_view___tab_today__item1"),
                                                  style: MainStyles.semiBoldTextStyle
                                                      .copyWith(height: 1.1,
                                                      fontSize: 16,
                                                      color: MainColors.middleGrey400),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    )),
                                // Container(width: 1,height: double.infinity,color: MainColors.middleGrey300,),
                                Expanded(
                                    child: BlocBuilder<SettingsCubit, SettingsState>(
                                        builder: (context, settingsState) {
                                          return Column(
                                            children: [

                                              Text(
                                                "${healthMonthState.stepCount.toString().length > 6 ? Utils.humanizeInteger(context, healthMonthState.stepCount) : healthMonthState.stepCount}",
                                                style: MainStyles.boldTextStyle
                                                    .copyWith(
                                                    height: 1.1, fontSize: 24),
                                                textAlign: TextAlign.left,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8,),
                                              AutoSizeText(
                                                Utils.getString(context,
                                                    "health_detail_view___tab_today__item2"),
                                                style: MainStyles.semiBoldTextStyle
                                                    .copyWith(height: 1.1,
                                                    fontSize: 16,
                                                    color: MainColors.middleGrey400),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          );
                                        }
                                    )),
                              ],
                            ),

                          if(healthMonthState is HealthMonthSuccessLoading)
                            Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                )
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16,),

                    //Initialize the chart widget
                    // https://medium.com/syncfusion/data-visualization-widgets-for-flutter-be1338adbe94
                    // SizedBox(height: 8,),
                    // Container(
                    //   height: size.width * 7.0 / 10,
                    //   child: Container(
                    //     child: Column(
                    //       children: <Widget>[
                    //         Expanded(
                    //           child: charts.BarChart(
                    //             _getSeriesData(),
                    //             animate: true,
                    //             domainAxis: charts.OrdinalAxisSpec(
                    //                 renderSpec: charts.SmallTickRendererSpec(labelRotation: 60)
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 16,),

                    if(healthMonthState is HealthMonthSuccess)
                    GridView(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
  //                                        maxCrossAxisExtent: 220,
  //                                        childAspectRatio: 0.6
                        crossAxisCount: 2,
                        // childAspectRatio: 0.601,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                      ),
                      children: [
                        HealthInfoItemWidget(
                          iconAddress: "assets/svgs/health/money.svg",
                          backgroundColor: MainColors.transparent!,
                          title: AutoSizeText(
                            Utils.getString(context, "health_detail_view___tab_week__amount"),
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subTitle: BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, settingsState) {
                                return AutoSizeText(
                                  settingsState is  SettingsStateLoaded ? "${healthMonthState.stepCount != null ? Utils.humanizeDouble(context, Utils.stringToDouble(value: healthMonthState.stepCount.toString()) * (settingsState.settingsModel!.step)) : 0 }" : "",
                                  style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                          ),
                        ),
                        HealthInfoItemWidget(
                          iconAddress: "assets/svgs/health/step.svg",
                          backgroundColor: MainColors.transparent!,
                          title: AutoSizeText(
                            Utils.getString(context, "health_detail_view___tab_week__step"),
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subTitle: AutoSizeText(
                            "${healthMonthState.stepCount.toString().length > 6 ? Utils.humanizeInteger(context, healthMonthState.stepCount) : healthMonthState.stepCount}",
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        HealthInfoItemWidget(
                          iconAddress: "assets/svgs/health/pin.svg",
                          backgroundColor: MainColors.transparent!,
                          title: AutoSizeText(
                            Utils.getString(context,
                                "health_detail_view___tab_today__passed"),
                            style: MainStyles.boldTextStyle.copyWith(
                                height: 1.1,
                                fontSize: 16,
                                color: MainColors.middleGrey400),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subTitle: AutoSizeText(
                            "${Utils.humanizeDouble(context, double.parse((healthMonthState.distance / 1000).toString()))} ${Utils.getString(context, "challenges_details_view___distance_measure")}",
                            style: MainStyles.boldTextStyle.copyWith(
                                height: 1.1, fontSize: 24),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        HealthInfoItemWidget(
                          iconAddress: "assets/svgs/health/calories.svg",
                          backgroundColor: MainColors.transparent!,
                          title: AutoSizeText(
                            Utils.getString(context,
                                "health_detail_view___tab_today__calories"),
                            style: MainStyles.boldTextStyle.copyWith(
                                height: 1.1,
                                fontSize: 16,
                                color: MainColors.middleGrey400),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subTitle: AutoSizeText(
                            "${Utils.humanizeDouble(context, double.parse((healthMonthState.calories ).toString()))}",
                            style: MainStyles.boldTextStyle.copyWith(
                                height: 1.1, fontSize: 24),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // HealthInfoItemWidget(
                        //   iconAddress: "assets/svgs/health/time.svg",
                        //   backgroundColor: MainColors.transparent!,
                        //   title: AutoSizeText(
                        //     Utils.getString(context, "health_detail_view___tab_today__time"),
                        //     style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                        //     textAlign: TextAlign.left,
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        //   subTitle: AutoSizeText(
                        //     "4270",
                        //     style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24),
                        //     textAlign: TextAlign.left,
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        // HealthInfoItemWidget(
                        //   iconAddress: "assets/svgs/health/speed.svg",
                        //   backgroundColor: MainColors.transparent!,
                        //   title: AutoSizeText(
                        //     Utils.getString(context, "health_detail_view___tab_today__speed"),
                        //     style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16, color: MainColors.middleGrey400),
                        //     textAlign: TextAlign.left,
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        //   subTitle: AutoSizeText(
                        //     "4270",
                        //     style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24),
                        //     textAlign: TextAlign.left,
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 16,),
                  ],
                ),
              ),
            ),
          );
        }else if(healthMonthState is HealthMonthLoading){
          return Container(
              child: Center(
                child: CircularProgressIndicator(),
              )
          );
        }else if(healthMonthState is HealthMonthError){
          return Expanded(
            child: ListErrorMessageWidget(
              errorCode: WEB_SERVICE_ENUM.STANDARD_ERROR,
              refresh: () {
                context.read<HealthMonthCubit>().fetchData();
              },
              text: Utils.getString(context, "unexpected_error_try_again"),
            ),
          );
        }else{
          return Expanded(
            child: ListErrorMessageWidget(
              errorCode: WEB_SERVICE_ENUM.STANDARD_ERROR,
              refresh: () {
                context.read<HealthMonthCubit>().fetchData();
              },
              text: Utils.getString(context, "grant_error_try_again"),
            ),
          );
        }
      }
    );
  }
}



class _MonthChartData {
  int month;
  int step;
  charts.Color barColor;
  _MonthChartData({
    required this.month,
    required this.step,
    required this.barColor
  });
}