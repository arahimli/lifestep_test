import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';

class DonorListItemShimmerWidget extends StatelessWidget {
  const DonorListItemShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
//          focusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: MainColors.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: SkeltonWidget(
                    height: size.width * 0.6 / 6,
                    width: size.width * 0.6 / 6,
                  )),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      SkeltonWidget(
                        height: 12,
                        padding: EdgeInsets.only(right: size.width * 2.5 / 10),
                      ),
                      const SizedBox(height: 8),

                      SkeltonWidget(
                        color: MainColors.darkPink100,
                        height: 12,
                        padding: EdgeInsets.only(right: size.width * 4.5 / 10),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SkeltonWidget(
                height: 12,
                width: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
