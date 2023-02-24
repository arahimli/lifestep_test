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
    // final size = MediaQuery.of(context).size;
    // return ;
    return BlocBuilder<LeaderBoardDonationCubit, LeaderBoardDonationState>(
        builder: (context, leaderBoardDonationState) {

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
                          child: GeneralListItem(ratingList: leaderBoardDonationState.mainData.usersWeeklyRating!, refresh: () => context.read<LeaderBoardDonationCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.donationWeek,),
                        ),
                        GeneralListItem(ratingList: leaderBoardDonationState.mainData.usersMonthlyRating!, refresh: () => context.read<LeaderBoardDonationCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.donationMonth,),
                        GeneralListItem(ratingList: leaderBoardDonationState.mainData.usersAllRating!, refresh: () => context.read<LeaderBoardDonationCubit>().refresh(), widgetType: USER_ORDER_STEP_TYPE.donationAll,),
                      ],
                    ),
                  ),
                )
            );
          }
          else if(leaderBoardDonationState is LeaderBoardDonationLoading){
            return const Expanded(
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

