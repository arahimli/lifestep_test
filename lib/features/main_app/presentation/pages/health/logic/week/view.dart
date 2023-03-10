
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/page_messages/list_message.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/settings/cubit.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/settings/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/components/health_info.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/week/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/week/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/general/padding/page_padding.dart';

class HealthWeekView extends StatefulWidget {
  const HealthWeekView({Key? key}) : super(key: key);

  @override
  HealthWeekViewState createState() => HealthWeekViewState();
}

class HealthWeekViewState extends State<HealthWeekView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HealthWeekCubit, HealthWeekState>(
      builder: (context, healthWeekState) {

      if(healthWeekState is HealthWeekSuccess || healthWeekState is HealthWeekSuccessLoading) {
        return ScrollConfiguration(
          behavior: MainScrollBehavior(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const PagePadding.all16(),
              child: Column(
                children: [

                  const SizedBox(height: 8,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: MainColors.white,
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: MainColors.darkPink500!, width: 2)
                    ),
                    child: Column(
                      children: [

                        if(healthWeekState is HealthWeekSuccess)
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .end,
                                              children: [
                                                Text(
                                                  settingsState is  SettingsStateLoaded ? Utils.humanizeDouble(context, Utils.stringToDouble(value: healthWeekState.stepCount.toString()) * (settingsState.settingsModel!.step)) : "",
                                                  style: MainStyles.boldTextStyle
                                                      .copyWith(fontSize: 24),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
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
                                            const SizedBox(height: 8,),
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
                                            "${healthWeekState.stepCount.toString().length > 6 ? Utils.humanizeInteger(context, healthWeekState.stepCount) : healthWeekState.stepCount}",
                                            style: MainStyles.boldTextStyle
                                                .copyWith(
                                                height: 1.1, fontSize: 24),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8,),
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
                        if(healthWeekState is HealthWeekSuccessLoading)
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .end,
                                              children: [
                                                Text(
                                                  settingsState is  SettingsStateLoaded ? Utils.humanizeDouble(context, Utils.stringToDouble(value: healthWeekState.stepCount.toString()) * (settingsState.settingsModel!.step)) : "",
                                                  style: MainStyles.boldTextStyle
                                                      .copyWith(fontSize: 24),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
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
                                            const SizedBox(height: 8,),
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
                                            "${healthWeekState.stepCount.toString().length > 6 ? Utils.humanizeInteger(context, healthWeekState.stepCount) : healthWeekState.stepCount}",
                                            style: MainStyles.boldTextStyle
                                                .copyWith(
                                                height: 1.1, fontSize: 24),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8,),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  // if(healthWeekState is HealthWeekSuccessLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    height: size.height * 10 / 100,
                    width: size.width,

                    child: ListView.separated(
                      reverse: DateTime.now().weekday > 4 ? true : false,
                      itemCount: DateTime.now().weekday,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, ind){

                        final currentDate = DateTime.now().add(Duration(days: -(ind)));
                        final formatter = DateFormat(DateFormat.ABBR_WEEKDAY, EasyLocalization.of(context)!.locale.languageCode);

                        DateTime selectedDate = DateTime.now();
                        int stepCount = 0;
                        if(healthWeekState is HealthWeekSuccess){
                          selectedDate = healthWeekState.selectedDate;
                          stepCount = healthWeekState.stepCount;
                        }
                        else if(healthWeekState is HealthWeekSuccessLoading) {
                          selectedDate = healthWeekState.selectedDate;
                          stepCount = healthWeekState.stepCount;
                        }
                        return GestureDetector(
                          onTap: (){
                            if(healthWeekState is HealthWeekSuccess && selectedDate.day != currentDate.day){
                              context.read<HealthWeekCubit>().dateChanged(currentDate, stepCount);
                            }
                          },
                          child: Container(
                            height: size.height * 10 / 100,
                            width: size.width * 20 / 100,
                            decoration: BoxDecoration(
                                border: Border.all(color: MainColors.middleGrey150!),
                                borderRadius: BorderRadius.circular(8),
                                color: selectedDate.day == currentDate.day ? MainColors.darkPink500 : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  formatter.format(currentDate), style: MainStyles.boldTextStyle.copyWith(color: selectedDate.day == currentDate.day ? MainColors.white : null),
                                ),
                                Text(
                                  "${currentDate.day}", style: MainStyles.boldTextStyle.copyWith(color: selectedDate.day == currentDate.day ? MainColors.white : null),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, ind){
                        return const SizedBox(width: 8,);
                      },
                    ),
                  ),

                  const SizedBox(height: 16,),
                  if(healthWeekState is HealthWeekSuccess)
                    GridView(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      physics: const ScrollPhysics(),
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
                                settingsState is  SettingsStateLoaded ? Utils.humanizeDouble(context, Utils.stringToDouble(value: healthWeekState.stepCountDay.toString()) * (settingsState.settingsModel!.step)) : "",
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
                            "${healthWeekState.stepCountDay.toString().length > 6 ? Utils.humanizeInteger(context, healthWeekState.stepCountDay) : healthWeekState.stepCountDay}",
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
                            "${Utils.humanizeDouble(context, double.parse((healthWeekState.distance / 1000).toString()))} ${Utils.getString(context, "challenges_details_view___distance_measure")}",
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
                            // "${healthWeekState.calories * 1000}",
                            Utils.humanizeDouble(context, double.parse((healthWeekState.calories).toString())),
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
                  if(healthWeekState is HealthWeekSuccessLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  const SizedBox(height: 16,),
                ],
              ),
            ),
          ),
        );
      }else if(healthWeekState is HealthWeekLoading){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else if(healthWeekState is HealthWeekError){
        return Expanded(
          child: ListErrorMessageWidget(
            errorCode: WEB_SERVICE_ENUM.standardError,
            refresh: () {
              context.read<HealthWeekCubit>().fetchData();
            },
            text: Utils.getString(context, "unexpected_error_try_again"),
          ),
        );
      }else{
        return Expanded(
          child: ListErrorMessageWidget(
            errorCode: WEB_SERVICE_ENUM.standardError,
            refresh: () {
              context.read<HealthWeekCubit>().fetchData();
            },
            text: Utils.getString(context, "grant_error_try_again"),
          ),
        );
      }
    }
    );
  }
}

