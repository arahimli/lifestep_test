import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/error/general_widget.dart';
import 'package:lifestep/src/tools/components/shimmers/step/step-list-item.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/cubits/global/step/donation/month/view.dart';
import 'package:lifestep/src/cubits/global/step/step/month/view.dart';
import 'package:lifestep/src/models/step/user_item.dart';
import 'package:lifestep/src/ui/home/components/liderboard_item.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/state.dart';
import 'package:lifestep/src/ui/leaderboard/tools/enum.dart';

import 'logic/donation/cubit.dart';
import 'logic/donation/state.dart';
import 'logic/step/cubit.dart';
import 'logic/step/state.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

class HomeLeaderBoardWidget extends StatefulWidget {
  const HomeLeaderBoardWidget({Key? key}) : super(key: key);

  @override
  _HomeLeaderBoardWidgetState createState() => _HomeLeaderBoardWidgetState();
}

class _HomeLeaderBoardWidgetState extends State<HomeLeaderBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderBoardHomeCubit, LeaderBoardHomeState>(
      builder: (context, leaderBoardHomeState) {
        return Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                    color: MainColors.backgroundColor,
                    borderRadius: BorderRadius.circular(64)
                ),
                child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<LeaderBoardHomeCubit>().onChangeValue(LeaderBoardTypeEnum.leaderBoardTypeStep),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: leaderBoardHomeState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeStep ? MainColors.white : null,
                                    borderRadius: BorderRadius.circular(64)
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    Utils.getString(context, "general__leaderboard_tab_step"),
                                    style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 12),
                                  ),
                                )
                            ),
                          )
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<LeaderBoardHomeCubit>().onChangeValue(LeaderBoardTypeEnum.leaderBoardTypeDonation),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: leaderBoardHomeState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeDonation ? MainColors.white : null,
                                    borderRadius: BorderRadius.circular(64)
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    Utils.getString(context, "general__leaderboard_tab_donation"),
                                    style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 12),
                                  ),
                                )
                            ),
                          )
                      ),
                    ]
                )
            ),

            const SizedBox(height: 12,),
            Container(
              margin: PagePadding.leftRight16(),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: MainColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  leaderBoardHomeState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeStep?
                  BlocBuilder<HomeLeaderBoardStepCubit, HomeLeaderBoardStepState>(
                      builder: (context, state) {
                       ///////// print("BlocBuilder<HomeLeaderBoardStepCubit = ${state.toString()}");
                        if(state is HomeLeaderBoardStepSuccess ) {
                          return Column(
                              children: state.mainData
                                  .asMap()
                                  .entries
                                  .map((entry) =>
                                  HomeLiderDataItem(
                                    owner: BlocProvider
                                        .of<SessionCubit>(context)
                                        .currentUser != null ? BlocProvider
                                        .of<SessionCubit>(context)
                                        .currentUser!
                                        .id == entry.value.userId : false,
                                    index: entry.key,
                                    userStepOrderModel: UserStepOrderModel(
                                        id: entry.value.userId,
                                        fullName: entry.value.name ?? '',
                                        genderType: entry.value.genderType,
                                        step: entry.value.steps ?? 0
                                    ),
                                  )).toList()
                          );
                        }
                        else if(state is HomeLeaderBoardStepLoading ) {
                          return Column(
                            children: List.generate(5, (index) =>
                                const LeadderDataItemShimmerWidget(
                                  owner: false,
                                )).toList(),
                          );
                        }
                        else if(state is HomeLeaderBoardStepError ) {
                          return GeneralErrorLoadAgainWidget(
                            onTap: () {
                              context.read<HomeLeaderBoardStepCubit>()
                                  .refresh();
                            },
                          );
                        }
                        else {
                          return const SizedBox();
                        }
                      }
                  ):
                  BlocBuilder<HomeLeaderBoardDonationCubit, HomeLeaderBoardDonationState>(
                      builder: (context, state) {
                       ///////// print("BlocBuilder<HomeLeaderBoardDonationCubit = ${state.toString()}");
                        if(state is HomeLeaderBoardDonationSuccess ) {
                          return Column(
                              children: state.mainData.asMap().entries.map((entry) =>
                                  HomeLiderDataItem(
                                    owner: BlocProvider
                                        .of<SessionCubit>(context)
                                        .currentUser != null ? BlocProvider
                                        .of<SessionCubit>(context)
                                        .currentUser!
                                        .id == entry.value.userId : false,
                                    index: entry.key,
                                    userStepOrderModel: UserStepOrderModel(
                                        id: entry.value.userId,
                                        fullName: entry.value.name ?? '',
                                        genderType: entry.value.genderType,
                                        step: entry.value.steps ?? 0
                                    ),
                                  )).toList()
                          );
                        }
                        else if(state is HomeLeaderBoardDonationLoading ){
                          return  const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else if(state is HomeLeaderBoardDonationError ){
                          return GeneralErrorLoadAgainWidget(
                            onTap: (){
                              context.read<HomeLeaderBoardDonationCubit>().refresh();
                            },
                          );}
                        else{
                          return const SizedBox();
                        }

                      }
                  ),

                  leaderBoardHomeState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeStep?
                  BlocBuilder<HomeLeaderBoardStepCubit, HomeLeaderBoardStepState>(
                      builder: (context, state) {
                       ///////// print("BlocBuilder<HomeLeaderBoardStepCubit = ${state.toString()}");
                        if(state is HomeLeaderBoardStepSuccess ) {
                          return MonthStepUserOrderView(
                            display: BlocProvider
                                .of<SessionCubit>(context)
                                .currentUser != null &&
                                !state.mainData.map((element) => element.userId)
                                    .contains(BlocProvider
                                    .of<SessionCubit>(context)
                                    .currentUser!
                                    .id),
                          );
                        } else if(state is HomeLeaderBoardStepLoading ){
                          return const LeadderDataItemShimmerWidget(
                            owner: true,
                          );
                        }
                        else if(state is HomeLeaderBoardStepError ) {
                          return GeneralErrorLoadAgainWidget(
                            onTap: () {
                              context.read<HomeLeaderBoardStepCubit>()
                                  .refresh();
                            },
                          );
                        }
                        else {
                          return const SizedBox();
                        }
                      }
                  ):
                  BlocBuilder<HomeLeaderBoardDonationCubit, HomeLeaderBoardDonationState>(
                      builder: (context, state) {
                       ///////// print("BlocBuilder<HomeLeaderBoardDonationCubit = ${state.toString()}");
                        if(state is HomeLeaderBoardDonationSuccess ) {
                          return MonthDonationUserOrderView(
                            display: BlocProvider.of<SessionCubit>(context).currentUser != null && !state.mainData.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id),
                          );
                        }
                        else if(state is HomeLeaderBoardDonationLoading ) {
                          return const LeadderDataItemShimmerWidget(
                            owner: true,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }
                  ),

                ],
              ),
            ),

          ],
        );
      }
    );
  }
}
