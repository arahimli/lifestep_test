import 'package:flutter/material.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton.dart';

class ChallengeListItemShimmerWidget extends StatelessWidget {
  const ChallengeListItemShimmerWidget({Key? key}) : super(key: key);

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
                  height: size.width * 0.95 / 6,
                  width: size.width * 0.95 / 6,
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
                      padding: EdgeInsets.only(right: size.width * 1.2 / 10),
                    ),
                    const SizedBox(height: 8),
                    SkeltonWidget(
                      height: 10,
                      padding: EdgeInsets.only(right: size.width * 0.6 / 10),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [

                        Expanded(
                          child: SkeltonWidget(
                            height: 25,
                            borderRadius: 100,
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: SkeltonWidget(
                            height: 25,
                            borderRadius: 100,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
