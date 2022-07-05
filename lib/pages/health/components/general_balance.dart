

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/session/state.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GeneralBalanceOverView extends StatefulWidget {
  const GeneralBalanceOverView({Key? key}) : super(key: key);

  @override
  _GeneralBalanceOverViewState createState() => _GeneralBalanceOverViewState();
}

class _GeneralBalanceOverViewState extends State<GeneralBalanceOverView> {

  PageController pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          return sessionState.currentUser != null ? Column(
            children: [
              GridView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
//                                        maxCrossAxisExtent: 220,
//                                        childAspectRatio: 0.6
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                children: [
                  _InformationItemWidget(
                    backgroundColor: MainColors.generalColor!,
                    title: Text(
                      Utils.getString(context, "profile_view___balance"),
                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 15, color: MainColors.white),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subTitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            Text(
                              "${sessionState.currentUser!.balanceSteps.toString().length > 6 ? Utils.humanizeInteger(sessionState.currentUser!.balanceSteps ?? 0) : sessionState.currentUser!.balanceSteps ?? 0}",
                              style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AutoSizeText(
                              " ${Utils.getString(context, "general__steps__count")}",
                              style: MainStyles.boldTextStyle.copyWith(fontSize: 12, color: MainColors.white),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [

                              BlocBuilder<SettingsCubit, SettingsState>(
                                  builder: (context, settingsState) {
                                    return settingsState is  SettingsStateLoaded ?
                                    AutoSizeText(
                                      "${sessionState.currentUser!.balanceSteps != null ? (Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step)) > 1 ? Utils.humanizeDouble(Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step)) : Utils.roundNumber(Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step), toPoint: 3) : 0 }",
                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white!.withOpacity(0.6)),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ):AutoSizeText(
                                      "0",
                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white!.withOpacity(0.6)),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                              ),
                              AutoSizeText(
                                " ${Utils.getString(context, "general__money_text").toUpperCase()}",
                                style: MainStyles.boldTextStyle.copyWith(fontSize: 10, color: MainColors.white!.withOpacity(0.6)),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _InformationItemWidget(
                    backgroundColor: MainColors.darkPink500!,
                    title: Text(
                      Utils.getString(context, "profile_view___donated"),
                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 15, color: MainColors.white),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subTitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            Text(
                              "${sessionState.currentUser!.totalDonateSteps.toString().length > 6 ? Utils.humanizeInteger((sessionState.currentUser!.totalDonateSteps ?? 0)) : sessionState.currentUser!.totalDonateSteps ?? 0}",
                              style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 24, color: MainColors.white),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AutoSizeText(
                              " ${Utils.getString(context, "general__steps__count")}",
                              style: MainStyles.boldTextStyle.copyWith(fontSize: 12, color: MainColors.white),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              BlocBuilder<SettingsCubit, SettingsState>(
                                  builder: (context, settingsState) {
                                    return settingsState is  SettingsStateLoaded ?
                                    AutoSizeText(
                                      "${sessionState.currentUser!.totalDonations != null ? sessionState.currentUser!.totalDonations! > 1 ? Utils.humanizeDouble(Utils.stringToDouble(value: sessionState.currentUser!.totalDonations!.toString())) : Utils.roundNumber(Utils.stringToDouble(value: sessionState.currentUser!.totalDonations!.toString()), toPoint: 3) : 0 }",
                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white!.withOpacity(0.6)),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ):AutoSizeText(
                                      "0",
                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white!.withOpacity(0.6)),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                              ),
                              AutoSizeText(
                                " ${Utils.getString(context, "general__money_text").toUpperCase()}",
                                style: MainStyles.boldTextStyle.copyWith(height: 1, fontSize: 10, color: MainColors.white!.withOpacity(0.6)),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              SizedBox(height: 12,),
            ],
          ):Container();
        }
    );
  }
}



class _InformationItemWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;
  final Widget subTitle;
  const _InformationItemWidget({Key? key, required this.backgroundColor,  required this.title,  required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            // color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                subTitle
              ],
            ),
          ),
        ),
      ),
    );
  }
}


