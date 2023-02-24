import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:shimmer/shimmer.dart';

class AchievementListItemShimmerWidget extends StatelessWidget {
  const AchievementListItemShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: MainColors.white,
          borderRadius: BorderRadius.circular(24)
      ),
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                // padding: EdgeInsets.symmetric(
                //   horizontal: size.width * 1 / 12,
                // ),
                  child: Shimmer.fromColors(
                      highlightColor: MainColors.middleGrey150!.withOpacity(0.2),
                      baseColor: MainColors.middleGrey150!,
                      child: Image.asset("assets/images/achievements/prize.png", color: MainColors.middleGrey150,)
                  )
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    // SizedBox(height: 8),
                    // SkeltonWidget(
                    //   height: 12,
                    //   padding: EdgeInsets.only(right: size.width * 0.6 / 10, left: size.width * 0.6 / 10, ),
                    // ),
                    SizedBox(height: 8),
                    SkeltonWidget(
                      height: 10,
                      // padding: EdgeInsets.only(right: size.width * 0.6 / 10),
                    ),
                    SizedBox(height: 4),
                    // SkeltonWidget(
                    //   height: 10,
                    //   // padding: EdgeInsets.only(right: size.width * 0.6 / 10),
                    // ),
                    // SizedBox(height: 8),
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
