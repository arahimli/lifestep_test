import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton.dart';

class PersonalDonationListItemShimmerWidget extends StatelessWidget {
  const PersonalDonationListItemShimmerWidget({Key? key}) : super(key: key);

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
                      padding: EdgeInsets.only(right: size.width * 2.5 / 10),
                    ),
                    const SizedBox(height: 12),
                    SkeltonWidget(
                      height: 8,
                      padding: EdgeInsets.only(right: size.width * 0.3 / 10),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: SkeltonWidget(
                            height: 8,
                            padding: EdgeInsets.only(right: size.width * 0.3 / 10),
                          ),
                        ),
                        const SizedBox(width: 4,),
                        SkeltonWidget(
                          height: 10,
                          width: 16,
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
