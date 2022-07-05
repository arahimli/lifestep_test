import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/page-messages/list-message.dart';
import 'package:lifestep/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/tools/components/shimmers/step/step-list-item.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/tools/constants/enum.dart';
import 'package:lifestep/pages/leaderboard/components/general_list.dart';
import 'package:lifestep/pages/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/pages/leaderboard/logic/step/state.dart';

class LeaderBoardStepView extends StatefulWidget {
  final TabController tabController;
  const LeaderBoardStepView({Key? key, required this.tabController}) : super(key: key);

  @override
  LeaderBoardStepViewState createState() => LeaderBoardStepViewState();
}

class LeaderBoardStepViewState extends State<LeaderBoardStepView>  with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // return ;
    return BlocBuilder<LeaderBoardStepCubit, LeaderBoardStepState>(
        builder: (context, leaderBoardStepState) {
          //////// print("LeaderBoardStepCubit_LeaderBoardStepCubit_");
          //////// print(leaderBoardStepState);

          if(leaderBoardStepState is LeaderBoardStepSuccess) {
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
                        GeneralListItem(ratingList: leaderBoardStepState.mainData.usersWeeklyRating!, refresh: () => context.read<LeaderBoardStepCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.STEP_WEEK,),
                        GeneralListItem(ratingList: leaderBoardStepState.mainData.usersMonthlyRating!, refresh: () => context.read<LeaderBoardStepCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.STEP_MONTH,),
                        GeneralListItem(ratingList: leaderBoardStepState.mainData.usersAllRating!, refresh: () => context.read<LeaderBoardStepCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.STEP_ALL,),
                      ],
                    ),
                  ),
                )
            );
          }
          else if(leaderBoardStepState is LeaderBoardStepLoading){
            return Expanded(
              child: SkeletonListWidget(
                  itemCount: 10,
                  child: LeadderDataItemShimmerWidget(
                    owner: false,
                  )
              ),
            );
          }
          else if(leaderBoardStepState is LeaderBoardStepError){
            return Expanded(
              child: ListErrorMessageWidget(
                errorCode: leaderBoardStepState.errorCode,
                refresh: () {
                  context.read<LeaderBoardStepCubit>().refresh();
                },
                text: Utils.getString(context, leaderBoardStepState.errorText),
              ),
            );
          }else{
            return Container();
          }
        }
    );
  }
}

