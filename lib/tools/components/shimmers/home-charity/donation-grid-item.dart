import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/config/main_colors.dart';

import '../skeleton.dart';

class ChairtyListItemShimmerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.all(2),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: MainColors.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                child: Container(
                  width: size.width * 0.8 / 6,
                  height: size.width * 0.8 / 6,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius:
                    BorderRadius.all(
                      Radius.circular(500.0),
                    ),
                  ),
                )),
//          Container(
//            height: MediaQuery.of(context).size.height * 0.2,
//            width: double.infinity,
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage('$assetName'), fit: BoxFit.cover)),
//          ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8),

                  Center(
                    child: SkeltonWidget(
                      height: 12,
                      padding: EdgeInsets.only(left: size.width * 0.7 / 10, right: size.width * 0.7 / 10),
                    ),
                  ),
                  SizedBox(height: 8),

                  SkeltonWidget(
                    height: 10,
                    padding: EdgeInsets.only(left: size.width * 0.35 / 10, right: size.width * 0.35 / 10),
                  ),

                  SizedBox(height: 8),

                  SkeltonWidget(
                    height: 10,
                    padding: EdgeInsets.only(left: size.width * 0.45 / 10, right: size.width * 0.45 / 10),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}