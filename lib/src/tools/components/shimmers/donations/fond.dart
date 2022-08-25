import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton.dart';

class FondDonationListItemShimmerWidget extends StatelessWidget {
  const FondDonationListItemShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.symmetric(
                  // vertical: 12,
                  // horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                ),
                child: SkeltonWidget(
                  height: size.width * 0.95 / 6,
                  width: size.width * 0.95 / 6,
                )),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
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
                    SkeltonWidget(
                      height: 25,
                      width: size.width * 2.5 / 10,
                      borderRadius: 100,
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