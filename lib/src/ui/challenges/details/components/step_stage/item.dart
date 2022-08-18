
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/models/challenge/inner.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';




class StepBaseItemWidget extends StatelessWidget {
  final ChallengeLevelModel dataItem;
  final int userSteps;
  final int index;
  final bool isLast;
  final double generalWidth;
  const StepBaseItemWidget({Key? key, required this.dataItem, required this.index, required this.generalWidth, required this.isLast, this.userSteps : 0 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: generalWidth,
      margin: EdgeInsets.only(right: !isLast ? 8 : 0),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);

        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12, ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: MainColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: CircularPercentIndicator(
                  radius: 64.0,
                  lineWidth: 8.0,
                  animation: true,
                  percent: userSteps != null && userSteps != 0 ? dataItem.goal! < userSteps ? dataItem.goal! / userSteps : 1 : 0,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: MainColors.darkPink500,
                  backgroundColor: MainColors.middleGrey150!,
                ),
              ),
              const SizedBox(width: 24,),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                              text: "${dataItem.goal}",
                              // text: "${ dataItem.goal! != null && dataItem.goal!.toString().length > 6 ? Utils.humanizeInteger(context, dataItem.goal!) : dataItem.goal! }",
                              style: MainStyles.extraBoldTextStyle.copyWith(fontSize: 32),
                            ),
                            TextSpan(
                                text: " ${Utils.getString(context, "general__steps__count")}",
                                style: MainStyles.boldTextStyle.copyWith(fontSize: 14)
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
                          style: MainStyles.boldTextStyle.copyWith(fontSize: 14)
                      )
                    ],
                  ),
                ],
              ),

              SvgPicture.asset("assets/svgs/general/navigate-right.svg")
            ],
          ),
        ),
      ),
    );
  }
}