import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';

class GeneralAppBar extends StatelessWidget {
  final Function()? onTap;
  final bool showBack;
  final String title;

  const GeneralAppBar({Key? key, this.onTap, this.showBack = true, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: showBack ? onTap ?? () => Navigator.pop(context) : (){},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    8,
                    8,
                    8,
                  ),
                  //                  padding: EdgeInsets.all(4),
                  // child: Text("d"),
                  child: SvgPicture.asset("assets/svgs/menu/back.svg", height: 24, color: !showBack ? MainColors.transparent : null,),
                ),
              ),
              Expanded(
                  child:
                  Container(
                      padding: const EdgeInsets.only(
                      top: 4,
                      left: 8,
                      right: 8,
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: MainStyles.boldTextStyle.copyWith(fontSize: 24), textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      )
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  8,
                  // 0,
                ),
                //                  padding: EdgeInsets.all(4),
                child: SvgPicture.asset("assets/svgs/menu/back.svg", color: MainColors.transparent,),
              ),

            ],
          ),
        ],
      ),
    );
  }
}