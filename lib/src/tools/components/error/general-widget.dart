
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';

class GeneralErrorLoadAgainWidget extends StatelessWidget {
  final String? title;
  final Function() onTap;
  const GeneralErrorLoadAgainWidget({Key? key, this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MainColors.middleGrey150!, width: 2)
          ),
          child: Row(
              children: [
                SvgPicture.asset("assets/svgs/general/refresh.svg", color: MainColors.middleGrey300!, height: size.width * 0.55 / 6,),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(title ?? Utils.getString(context, "general__load_again_widget_title"), style: MainStyles.boldTextStyle,)
                )
              ]
          )
      ),
    );
  }
}
