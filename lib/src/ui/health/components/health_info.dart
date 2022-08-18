
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';

class HealthInfoItemWidget extends StatelessWidget {
  final String iconAddress;
  final Color backgroundColor;
  final Widget title;
  final Widget subTitle;
  const HealthInfoItemWidget({Key? key, required this.iconAddress, required this.backgroundColor,  required this.title,  required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      decoration: BoxDecoration(
          color: MainColors.white,
          borderRadius: BorderRadius.circular(24)
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  child: SvgPicture.asset(iconAddress, color: MainColors.darkPink500)
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    title,
                    const SizedBox(height: 8),
                    subTitle
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
