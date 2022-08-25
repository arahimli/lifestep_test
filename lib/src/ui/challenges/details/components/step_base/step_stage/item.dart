
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/challenge/inner.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/packages/humanize/humanize_big_int_base.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';




class StepBaseItemWidget extends StatelessWidget {
  final ChallengeLevelModel dataItem;
  final ChallengeModel challengeModel;
  final int userSteps;
  final int index;
  final bool isLast;
  final double generalWidth;
  const StepBaseItemWidget({Key? key, required this.dataItem, required this.index, required this.generalWidth, required this.isLast, this.userSteps = 0, required this.challengeModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("[LOG] : userSteps $userSteps");
    log("[LOG] : userSteps ${userSteps != 0}");
    log("[LOG] : userSteps ${dataItem.goal! > userSteps}");

    return Container(
      width: generalWidth,
      margin: EdgeInsets.only(right: !isLast ? 6 : 4),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);

        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12, ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: completedStage() ? MainColors.successGreenColor : MainColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // height: 64,
                width: 64,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircularPercentIndicator(
                        radius: 64.0,
                        lineWidth: 4.0,
                        animation: true,
                        percent: challengeModel.isJoined! && userSteps != 0 ? dataItem.goal! > userSteps ? userSteps / dataItem.goal!  : 1 : 0,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: completedStage() ? MainColors.white : MainColors.darkPink500,
                        backgroundColor: MainColors.middleGrey150!,
                      ),
                    ),
                    if(completedStage())
                    Align(
                      alignment: Alignment.center,
                        child: Center(
                            child: AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.bounceIn,
                              child: SvgPicture.asset("assets/svgs/challenges/completed.svg"),
                            )
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16,),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: humanizeInt(context, dataItem.goal ?? 0),
                              // text: "${ dataItem.goal! != null && dataItem.goal!.toString().length > 6 ? Utils.humanizeInteger(context, dataItem.goal!) : dataItem.goal! }",
                              style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 30, color: completedStage() ? MainColors.white : null),
                            ),
                            if(challengeModel.isJoined!)
                            TextSpan(
                              text: "/",
                              // text: "${ dataItem.goal! != null && dataItem.goal!.toString().length > 6 ? Utils.humanizeInteger(context, dataItem.goal!) : dataItem.goal! }",
                              style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 30, color: completedStage() ? MainColors.white : null),
                            ),
                            TextSpan(
                                text: " ${challengeModel.isJoined! ? humanizeInt(context, userSteps) : ''} ${Utils.getString(context, "general__steps__count")}",
                                style: MainStyles.boldTextStyle.copyWith(fontSize: 14, color: completedStage() ? MainColors.white : null)
                            ),
                          ]
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          dataItem.prizeName ?? '',
                          // text: "${ settingsState is  SettingsStateLoaded ? dataItem.goal! != null ? Utils.humanizeDouble(context, Utils.stringToDouble(value: dataItem.goal!.toString()) * (settingsState.settingsModel!.step)) : 0 : 0 }",
                          style: MainStyles.boldTextStyle.copyWith(fontSize: 14, color: completedStage() ? MainColors.white : null)
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool completedStage(){
    return challengeModel.isJoined! ? userSteps != 0 ? dataItem.goal! > userSteps ? false  : true : false : false;
  }

}