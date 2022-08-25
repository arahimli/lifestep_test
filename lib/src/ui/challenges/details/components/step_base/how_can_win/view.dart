
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';

class HowCanWin extends StatelessWidget {
  final ChallengeModel challengeModel;
  const HowCanWin({Key? key, required this.challengeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return challengeModel.bulletedListArray != null && challengeModel.bulletedListArray!.isNotEmpty ?
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: AutoSizeText(Utils.getString(context, "challenge_detail_view__step_base_how_can_i_win"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),)
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16, ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: MainColors.softBorderColor!,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                children: challengeModel.bulletedListArray!.asMap().entries.map((e,) => _DataItem(index: e.key, text: e.value,)).toList(),
              ),
            )
          )
        ],
      ):
      Container();
  }
}

class _DataItem extends StatelessWidget {
  final int index;
  final String? text;
  const _DataItem({Key? key, required this.index, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if(index != 0)
          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                height: 24,
                width: 32,
                child: Center(
                    child: SvgPicture.asset("assets/svgs/challenges/how_win_divider.svg", height: 20,)
                ),
              ),

            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: MainColors.howCanWinOrderColor,
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Center(child: Text((index+1).toString(), style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.mainGrayColor, fontSize: 14),)),
              ),
              Expanded(
                child: Text(text ?? '-', style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 15), maxLines: 1,),
              )
            ],
          ),
        ],
      )
    );
  }
}
