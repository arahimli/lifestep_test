import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/page-messages/list-message.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/src/tools/components/shimmers/step/step-list-item.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/constants/enum.dart';
import 'package:lifestep/src/ui/leaderboard/components/general_list.dart';
import 'package:lifestep/src/ui/leaderboard/logic/step/cubit.dart';

import 'cubit.dart';
import 'state.dart';

class LeaderBoardDonationView extends StatefulWidget {
  final TabController tabController;
  const LeaderBoardDonationView({Key? key, required this.tabController}) : super(key: key);

  @override
  LeaderBoardDonationViewState createState() => LeaderBoardDonationViewState();
}

class LeaderBoardDonationViewState extends State<LeaderBoardDonationView>  with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // return ;
    return BlocBuilder<LeaderBoardDonationCubit, LeaderBoardDonationState>(
        builder: (context, leaderBoardDonationState) {
          //////// print("LeaderBoardDonationCubit_LeaderBoardDonationCubit_");
          //////// print(leaderBoardDonationState);

          if(leaderBoardDonationState is LeaderBoardDonationSuccess) {
            return Flexible(
                flex: 1,
                child:
                ScrollConfiguration(
                  behavior: MainScrollBehavior(),
                  child: Container(
                    color: MainColors.backgroundColor,
                    child: TabBarView(
                      controller: widget.tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: GeneralListItem(ratingList: leaderBoardDonationState.mainData.usersWeeklyRating!, refresh: () => context.read<LeaderBoardDonationCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.DONATION_WEEK,),
                        ),
                        GeneralListItem(ratingList: leaderBoardDonationState.mainData.usersMonthlyRating!, refresh: () => context.read<LeaderBoardDonationCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.DONATION_MONTH,),
                        GeneralListItem(ratingList: leaderBoardDonationState.mainData.usersAllRating!, refresh: () => context.read<LeaderBoardDonationCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.DONATION_ALL,),
                      ],
                    ),
                  ),
                )
            );
          }
          else if(leaderBoardDonationState is LeaderBoardDonationLoading){
            return Expanded(
              child: SkeletonListWidget(
                itemCount: 10,
                child: LeadderDataItemShimmerWidget(
                  owner: false,
                )
              ),
            );
          }
          else if(leaderBoardDonationState is LeaderBoardDonationError){
            return Expanded(
              child: ListErrorMessageWidget(
                errorCode: leaderBoardDonationState.errorCode,
                refresh: () {
                  context.read<LeaderBoardStepCubit>().refresh();
                },
                text: Utils.getString(context, leaderBoardDonationState.errorText),
              ),
            );
          }else{
            return Container();
          }
        }
    );
  }
}

