

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/pages/health/components/health_info.dart';
import 'package:lifestep/pages/health/logic/today/cubit.dart';
import 'package:lifestep/pages/health/logic/today/state.dart';
import 'package:lifestep/pages/index/logic/dailystep/cubit.dart';
import 'package:lifestep/pages/index/logic/dailystep/state.dart';

class HomeDailyStepView extends StatefulWidget {
  const HomeDailyStepView({Key? key}) : super(key: key);

  @override
  HomeDailyStepViewState createState() => HomeDailyStepViewState();
}

class HomeDailyStepViewState extends State<HomeDailyStepView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                        "${Utils.getString(context, "general__money_text")}",
                        style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.white, fontSize: 14)
                    ),
                  ],
                ),
              ],
            );
          }else if(homeDailyStepState is HomeDailyStepLoading){
            return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          }else if(homeDailyStepState is HomeDailyStepNotGranted){
            return Container(
                child: Center(
                  child: Text("grant again"),
                )
            );
          }else{
            return Container(
                child: Center(
                  child: Text("error"),
                )
            );
          }
        }
    );
  }
}
