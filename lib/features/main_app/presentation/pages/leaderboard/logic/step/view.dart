import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/page_messages/list_message.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton_list.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/step/step_list_item.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/constants/enum.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/components/general_list.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/step/state.dart';

class LeaderBoardStepView extends StatefulWidget {
  final TabController tabController;
  const LeaderBoardStepView({Key? key, required this.tabController}) : super(key: key);

  @override
  LeaderBoardStepViewState createState() => LeaderBoardStepViewState();
}

class LeaderBoardStepViewState extends State<LeaderBoardStepView>  with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderBoardStepCubit, LeaderBoardStepState>(
        builder: (context, leaderBoardStepState) {

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
                        GeneralListItem(ratingList: leaderBoardStepState.mainData.usersWeeklyRating!, refresh: () => context.read<LeaderBoardStepCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.stepWeek,),
                        GeneralListItem(ratingList: leaderBoardStepState.mainData.usersMonthlyRating!, refresh: () => context.read<LeaderBoardStepCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.stepMonth,),
                        GeneralListItem(ratingList: leaderBoardStepState.mainData.usersAllRating!, refresh: () => context.read<LeaderBoardStepCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.stepAll,),
                      ],
                    ),
                  ),
                )
            );
          }
          else if(leaderBoardStepState is LeaderBoardStepLoading){
            return const Expanded(
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

