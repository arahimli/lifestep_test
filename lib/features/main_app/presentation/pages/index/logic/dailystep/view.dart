

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/dailystep/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/dailystep/state.dart';

class HomeDailyStepView extends StatefulWidget {
  const HomeDailyStepView({Key? key}) : super(key: key);

  @override
  HomeDailyStepViewState createState() => HomeDailyStepViewState();
}

class HomeDailyStepViewState extends State<HomeDailyStepView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDailyStepCubit, HomeDailyStepState>(
        builder: (context, homeDailyStepState) {

          if(homeDailyStepState is HomeDailyStepSuccess) {
            return Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                  text: "${homeDailyStepState.stepCountDay}",
                                  style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 40)
                              ),
                              TextSpan(
                                  text: " ${Utils.getString(context, "general__steps__count")}",
                                  style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 14)
                              ),
                            ]
                        )
                    ),
                    Text(
                        Utils.getString(context, "general__money_text"),
                        style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 14)
                    ),
                  ],
                ),
              ],
            );
          }else if(homeDailyStepState is HomeDailyStepLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(homeDailyStepState is HomeDailyStepNotGranted){
            return const Center(
              child: Text("grant again"),
            );
          }else{
            return const Center(
              child: Text("error"),
            );
          }
        }
    );
  }
}

