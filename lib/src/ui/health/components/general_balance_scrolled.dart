

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/cubits/global/session/state.dart';
import 'package:lifestep/src/cubits/global/settings/cubit.dart';
import 'package:lifestep/src/cubits/global/settings/state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

class GeneralBalanceOverViewScrolled extends StatefulWidget {
  const GeneralBalanceOverViewScrolled({Key? key}) : super(key: key);

  @override
  _GeneralBalanceOverViewScrolledState createState() => _GeneralBalanceOverViewScrolledState();
}

class _GeneralBalanceOverViewScrolledState extends State<GeneralBalanceOverViewScrolled> {

  PageController pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          return sessionState.currentUser != null ? Column(
            children: [
              SizedBox(
                height: (size.width - 32) / 2,
                child: PageView(
                  controller: pageController,
                  children: [
                    GridView(
                      padding: PagePadding.leftRight16(),
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
                      children: [
                        _InformationItemWidget(
                          iconAddress: "assets/svgs/profile/item1.svg",
                          backgroundColor: MainColors.generalColor!,
                          title: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              BlocBuilder<SettingsCubit, SettingsState>(
                                  builder: (context, settingsState) {
                                    return settingsState is  SettingsStateLoaded ?
                                    AutoSizeText(
                                      "${sessionState.currentUser!.balanceSteps != null ? (Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step)) > 10 ? Utils.humanizeDouble(context, Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step)) : Utils.roundNumber(Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step), toPoint: 3) : 0 }",
                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ):AutoSizeText(
                                      "0",
                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                              ),
                              AutoSizeText(
                                " ${Utils.getString(context, "general__money_text").toUpperCase()}",
                                style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          subTitle: AutoSizeText(
                            Utils.getString(context, "profile_view___balance"),
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _InformationItemWidget(
                          iconAddress: "assets/svgs/profile/step2.svg",
                          backgroundColor: MainColors.darkPink500!,
                          title: Text(
                            "${sessionState.currentUser!.balanceSteps.toString().length > 6 ? Utils.humanizeInteger(context, sessionState.currentUser!.balanceSteps ?? 0) : sessionState.currentUser!.balanceSteps ?? 0}",
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subTitle: AutoSizeText(
                            Utils.getString(context, "profile_view__steps_balance"),
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    GridView(
                      padding: PagePadding.leftRight16(),
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
                      children: [
                        _InformationItemWidget(
                          iconAddress: "assets/svgs/profile/item1.svg",
                          backgroundColor: MainColors.generalColor!,
                          title: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              BlocBuilder<SettingsCubit, SettingsState>(
                                  builder: (context, settingsState) {
                                    return settingsState is  SettingsStateLoaded ?
                                    AutoSizeText(
                                      "${sessionState.currentUser!.totalDonations != null ? sessionState.currentUser!.totalDonations! > 10 ? Utils.humanizeDouble(context, Utils.stringToDouble(value: sessionState.currentUser!.totalDonations!.toString())) : Utils.roundNumber(Utils.stringToDouble(value: sessionState.currentUser!.totalDonations!.toString()), toPoint: 3) : 0 }",
                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ):AutoSizeText(
                                      "0",
                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                              ),
                              AutoSizeText(
                                " ${Utils.getString(context, "general__money_text").toUpperCase()}",
                                style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          subTitle: AutoSizeText(
                            Utils.getString(context, "profile_view___donated"),
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _InformationItemWidget(
                          iconAddress: "assets/svgs/profile/step2.svg",
                          backgroundColor: MainColors.darkPink500!,
                          title: Text(
                            "${sessionState.currentUser!.totalDonateSteps.toString().length > 6 ? Utils.humanizeInteger(context, (sessionState.currentUser!.totalDonateSteps ?? 0)) : sessionState.currentUser!.totalDonateSteps ?? 0}",
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subTitle: AutoSizeText(
                            Utils.getString(context, "profile_view__steps__donated"),
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
//                         GridView(
//                           padding: PagePadding.leftRight16(),
//                           physics: ScrollPhysics(),
//                           shrinkWrap: true,
//                           gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
// //                                        maxCrossAxisExtent: 220,
// //                                        childAspectRatio: 0.6
//                             crossAxisCount: 2,
//                             // childAspectRatio: 0.601,
//                             mainAxisSpacing: 4.0,
//                             crossAxisSpacing: 4.0,
//                           ),
//                           children: [
//                             _InformationItemWidget(
//                               iconAddress: "assets/svgs/profile/item1.svg",
//                               backgroundColor: MainColors.darkBlue500!,
//                               title: Wrap(
//                                 crossAxisAlignment: WrapCrossAlignment.end,
//                                 children: [
//                                   BlocBuilder<SettingsCubit, SettingsState>(
//                                       builder: (context, settingsState) {
//                                         return settingsState is  SettingsStateLoaded ?
//                                         AutoSizeText(
//                                           "${Utils.humanizeDouble(context, Utils.stringToDouble(value: ((sessionState.currentUser!.totalDonateSteps ?? 0) + (sessionState.currentUser!.balanceSteps ?? 0)).toString()) * (settingsState.settingsModel!.step))}",
//                                           style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
//                                           textAlign: TextAlign.left,
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ):AutoSizeText(
//                                           "0",
//                                           style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
//                                           textAlign: TextAlign.left,
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         );
//                                       }
//                                   ),
//                                   AutoSizeText(
//                                     " ${Utils.getString(context, "general__money_text").toUpperCase()}",
//                                     style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
//                                     textAlign: TextAlign.left,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                               subTitle: AutoSizeText(
//                                 Utils.getString(context, "profile_view___total"),
//                                 style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
//                                 textAlign: TextAlign.left,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             _InformationItemWidget(
//                               iconAddress: "assets/svgs/profile/step2.svg",
//                               backgroundColor: MainColors.darkPink500!,
//                               title: Text(
//                                 "${Utils.humanizeInteger(context, (sessionState.currentUser!.totalDonateSteps ?? 0) + (sessionState.currentUser!.balanceSteps ?? 0)) }",
//                                 style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
//                                 textAlign: TextAlign.left,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               subTitle: AutoSizeText(
//                                 Utils.getString(context, "profile_view__steps_total"),
//                                 style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white),
//                                 textAlign: TextAlign.left,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
                  ],
                ),
              ),

              const SizedBox(height: 12,),
              SmoothPageIndicator(
                controller: pageController,  // PageController
                count:  2,
                onDotClicked: (int index) async{
                  await pageController.nextPage(
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 300));
                },
                // forcing the indicator to use a specific direction
                // textDirection: TextDirection.RTL,
                effect:  WormEffect(

                  dotColor: MainColors.middleBlue150!,
                  activeDotColor: MainColors.middleBlue500!,
                  dotHeight: 8,
                  dotWidth: 8,
                  strokeWidth: 24,
                ),
              ),
            ],
          ):Container();
        }
    );
  }
}



class _InformationItemWidget extends StatelessWidget {
  final String iconAddress;
  final Color backgroundColor;
  final Widget title;
  final Widget subTitle;
  const _InformationItemWidget({Key? key, required this.iconAddress, required this.backgroundColor,  required this.title,  required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  child: SvgPicture.asset(iconAddress, color: MainColors.white)
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    title,
                    const SizedBox(height: 8),
                    subTitle
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



