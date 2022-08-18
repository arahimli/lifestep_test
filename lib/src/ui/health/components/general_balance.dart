

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/cubits/global/session/state.dart';
import 'package:lifestep/src/cubits/global/settings/cubit.dart';
import 'package:lifestep/src/cubits/global/settings/state.dart';

import 'general_balance_blocked.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

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
          return sessionState.currentUser != null ?
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {

              return settingsState is  SettingsStateLoaded ?
                sessionState.currentUser!.balanceSteps! < settingsState.settingsModel!.balanceLimit ?
                  Column(
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
                                      "${sessionState.currentUser!.balanceSteps.toString().length > 6 ? Utils.humanizeInteger(context, sessionState.currentUser!.balanceSteps ?? 0) : sessionState.currentUser!.balanceSteps ?? 0}",
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
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [

                                      AutoSizeText(
                                        "${sessionState.currentUser!.balanceSteps != null ? (Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step)) > 1 ? Utils.humanizeDouble(context, Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step)) : Utils.roundNumber(Utils.stringToDouble(value: sessionState.currentUser!.balanceSteps.toString()) * (settingsState.settingsModel!.step), toPoint: 3) : 0 }",
                                        style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white!.withOpacity(0.6)),
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                      "${sessionState.currentUser!.totalDonateSteps.toString().length > 6 ? Utils.humanizeInteger(context, (sessionState.currentUser!.totalDonateSteps ?? 0)) : sessionState.currentUser!.totalDonateSteps ?? 0}",
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
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      AutoSizeText(
                                        "${sessionState.currentUser!.totalDonations != null ? sessionState.currentUser!.totalDonations! > 1 ? Utils.humanizeDouble(context, Utils.stringToDouble(value: sessionState.currentUser!.totalDonations!.toString())) : Utils.roundNumber(Utils.stringToDouble(value: sessionState.currentUser!.totalDonations!.toString()), toPoint: 3) : 0 }",
                                        style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.white!.withOpacity(0.6)),
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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


                      const SizedBox(height: 12,),
                    ],
                  ) : GeneralBalanceBlockedView():
                  Container();
            }
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
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(
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



