import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';

class NotificationListItemShimmerWidget extends StatelessWidget {
  const NotificationListItemShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
        },
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: MainColors.middleGrey150!
                  )
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeltonWidget(
                height: 12,
                width: (size.width - 32 ) * 3 / 10,
              ),
              const SizedBox(height: 8),
              SkeltonWidget(
                height: 12,
                padding: EdgeInsets.only(right: size.width * 1 / 10),
              ),
              const SizedBox(height: 8),
              SkeltonWidget(
                height: 12,
                padding: EdgeInsets.only(right: size.width * 0.3 / 10),
              ),
              const SizedBox(height: 8),
              SkeltonWidget(
                height: 12,
                padding: EdgeInsets.only(right: size.width * 1.3 / 10),
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }
}
