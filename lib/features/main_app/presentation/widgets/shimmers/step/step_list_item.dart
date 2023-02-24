
import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';

class LeadderDataItemShimmerWidget extends StatelessWidget {
  final bool owner;
  final double? borderRadius;
  final int index;
  const LeadderDataItemShimmerWidget({Key? key, this.owner = false, this.borderRadius, this.index = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: owner ? MainColors.liderboardBackgroundColor : MainColors.backgroundColor,
          // border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
          borderRadius: BorderRadius.circular(borderRadius ?? 1)
      ),
      margin: const EdgeInsets.only(bottom:0),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
//          focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.only(left: owner ? 2 : 12 , right: 6),
          child: Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
              // borderRadius: BorderRadius.circular(borderRadius ?? 1)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.only(
                    // vertical: 12,
                    left: owner ? 16 : 6,
                    right: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: index < 0 ? SizedBox(
                    child: Center(
                      child: SkeltonWidget(
                        height: 16,
                        width: 10,
                        padding: EdgeInsets.only(right: size.width * 0.3 / 10),
                      ),
                    ),
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ): index > 2 ? SkeltonWidget(
                    borderRadius: 500,
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ) :
                  SkeltonWidget(
                    borderRadius: 500,
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ),
                ),
                //
                // Container(
                //   clipBehavior: Clip.antiAlias,
                //   margin: EdgeInsets.symmetric(
                //     // vertical: 12,
                //     horizontal: 6,
                //   ),
                //   decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.circular(500),
                //   ),
                //   child: Image.asset(MainConfig.defaultWoman,
                //     width: size.width * 0.6 / 6,
                //     height: size.width * 0.6 / 6,
                //   ),
                // ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeltonWidget(
                                height: 16,
                                width: 130,
                                padding: EdgeInsets.only(right: size.width * 0.3 / 10),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        SkeltonWidget(
                          height: 16,
                          width: 80,
                          color: MainColors.darkPink150,
                          padding: EdgeInsets.only(right: size.width * 0.3 / 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
