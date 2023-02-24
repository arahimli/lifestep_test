import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:lifestep/features/main_app/presentation/pages/health/logic/today/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/health/logic/today/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/general/padding/page_padding.dart';

class HealthTodayView extends StatefulWidget {
  const HealthTodayView({Key? key}) : super(key: key);

  @override
  HealthTodayViewState createState() => HealthTodayViewState();
}

class HealthTodayViewState extends State<HealthTodayView> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return BlocBuilder<HealthTodayCubit, HealthTodayState>(
        builder: (context, healthTodayState) {

          if(healthTodayState is HealthTodaySuccess) {
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        decoration: BoxDecoration(
                          color: MainColors.white,
                          borderRadius: BorderRadius.circular(16),
                          // border: Border.all(color: MainColors.darkPink500!, width: 2)
                        ),
                        child: Column(
                          children: [
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
                                                      settingsState is  SettingsStateLoaded ? Utils.humanizeDouble(context, Utils.stringToDouble(value: healthTodayState.stepCount.toString()) * (settingsState.settingsModel!.step)) : "",
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
                                                "${healthTodayState.stepCount.toString().length > 6 ? Utils.humanizeInteger(context, healthTodayState.stepCount) : healthTodayState.stepCount}",
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
                      // BigUnBorderedButton(text: Utils.getString(context, "health_detail_view___tab_today__donate_button")),

                      // SizedBox(height: 16,),
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
                              "${Utils.humanizeDouble(context, double.parse((healthTodayState.distance / 1000).toString()))} ${Utils.getString(context, "challenges_details_view___distance_measure")}",
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
                              Utils.humanizeDouble(context, double.parse((healthTodayState.calories).toString())),
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
                          //     Utils.getString(context,
                          //         "health_detail_view___tab_today__time"),
                          //     style: MainStyles.boldTextStyle.copyWith(
                          //         height: 1.1,
                          //         fontSize: 16,
                          //         color: MainColors.middleGrey400),
                          //     textAlign: TextAlign.left,
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          //   subTitle: AutoSizeText(
                          //     "4270",
                          //     style: MainStyles.boldTextStyle.copyWith(
                          //         height: 1.1, fontSize: 24),
                          //     textAlign: TextAlign.left,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                          // HealthInfoItemWidget(
                          //   iconAddress: "assets/svgs/health/speed.svg",
                          //   backgroundColor: MainColors.transparent!,
                          //   title: AutoSizeText(
                          //     Utils.getString(context,
                          //         "health_detail_view___tab_today__speed"),
                          //     style: MainStyles.boldTextStyle.copyWith(
                          //         height: 1.1,
                          //         fontSize: 16,
                          //         color: MainColors.middleGrey400),
                          //     textAlign: TextAlign.left,
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          //   subTitle: AutoSizeText(
                          //     "4270",
                          //     style: MainStyles.boldTextStyle.copyWith(
                          //         height: 1.1, fontSize: 24),
                          //     textAlign: TextAlign.left,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16,),
                    ],
                  ),
                ),
              ),
            );
          }else if(healthTodayState is HealthTodayLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(healthTodayState is HealthTodayError){
            return Expanded(
              child: ListErrorMessageWidget(
                errorCode: WEB_SERVICE_ENUM.standardError,
                refresh: () {
                  context.read<HealthTodayCubit>().fetchData();
                },
                text: Utils.getString(context, "unexpected_error_try_again"),
              ),
            );
          }else{
            return Expanded(
              child: ListErrorMessageWidget(
                errorCode: WEB_SERVICE_ENUM.standardError,
                refresh: () {
                  context.read<HealthTodayCubit>().fetchData();
                },
                text: Utils.getString(context, "grant_error_try_again"),
              ),
            );
          }
        }
    );
  }
}

