
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class HomeDailyShimmerWidget extends StatelessWidget {
  const HomeDailyShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Shimmer.fromColors(
                highlightColor: MainColors.generalColor!.withOpacity(0.5),
                baseColor: MainColors.middleGrey50!,
                child: CircularPercentIndicator(
                  radius: 64.0,
                  lineWidth: 8.0,
                  animation: true,
                  percent: 0.6,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: MainColors.darkPink500,
                  backgroundColor: MainColors.white!,
                ),
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  highlightColor: MainColors.generalColor!.withOpacity(0.5),
                  baseColor: MainColors.middleGrey50!,
                  child: Row(
                    children: [
                      SkeltonWidget(
                          borderRadius: 5,
                        height: 30,
                        width: 100
                      ),
                      const SizedBox(width: 4,),
                      SkeltonWidget(
                        borderRadius: 5,
                        height: 14,
                        width: 30
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
                Shimmer.fromColors(
                  highlightColor: MainColors.generalColor!.withOpacity(0.5),
                  baseColor: MainColors.middleGrey150!,
                  child: Row(
                    children: [
                      SkeltonWidget(
                          borderRadius: 5,
                          height: 20,
                          width: 80
                      ),
                      const SizedBox(width: 4,),
                      SkeltonWidget(
                          borderRadius: 5,
                          height: 20,
                          width: 30
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SvgPicture.asset("assets/svgs/general/navigate-right.svg")
          ],
        )
    );
  }
}
