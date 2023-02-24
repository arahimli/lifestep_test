import 'package:flutter/material.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';

class HistoryListItemShimmerWidget extends StatelessWidget {
  const HistoryListItemShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                ),
                child: SkeltonWidget(
                  height: size.width * 0.8 / 6,
                  width: size.width * 0.8 / 6,
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
                      padding: EdgeInsets.only(right: size.width * 1.0 / 10),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeltonWidget(
                          height: 12,
                          width: 100,
                          borderRadius: 100,
                          color: MainColors.darkPink150,
                        ),
                        const SkeltonWidget(
                          height: 12,
                          width: 100,
                          borderRadius: 100,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.black,)
          ],
        ),
      ),
    );
  }
}
