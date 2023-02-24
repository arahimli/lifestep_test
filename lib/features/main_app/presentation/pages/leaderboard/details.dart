
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/usecases/logger/logger_mixin.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/appbar/auth_notification.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/tools/constants/page_key.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/donation/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/donation/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/step/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/tools/enum.dart';
import 'logic/cubit.dart';
import 'logic/donation/cubit.dart';
import 'logic/state.dart';
import 'logic/step/cubit.dart';
import 'logic/step/state.dart';



class LeaderBoardDetailView extends StatefulWidget {
  const LeaderBoardDetailView({Key? key}) : super(key: key);

  @override
  _LeaderBoardDetailViewState createState() => _LeaderBoardDetailViewState();
}

class _LeaderBoardDetailViewState extends State<LeaderBoardDetailView> with TickerProviderStateMixin, LoggerMixin {

  late TabController stepTabController;
  late TabController donationTabController;

  @override
  void init() {
    // addData();

    stepTabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);
    donationTabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MainColors.white,
      body: SafeArea(
        child: BlocBuilder<LeaderBoardDetailCubit, LeaderBoardDetailState>(
          builder: (context, leaderBoardDetailState) {
            return Column(
              children: [
                AuthNotificationAppbar(
                  title: Utils.getString(context, "leader_board_view___title"),
                  // textStyle: MainStyles.boldTextStyle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4,),
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
                                onTap: () => context.read<LeaderBoardDetailCubit>().onChangeValue(LeaderBoardTypeEnum.leaderBoardTypeStep),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeStep ? MainColors.white : null,
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
                                onTap: () => context.read<LeaderBoardDetailCubit>().onChangeValue(LeaderBoardTypeEnum.leaderBoardTypeDonation),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeDonation ? MainColors.white : null,
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
                const SizedBox(height: 4,),

                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeStep)
                  BlocBuilder<LeaderBoardStepCubit, LeaderBoardStepState>(
                      builder: (context, leaderBoardStepState) {
                        if(leaderBoardStepState is LeaderBoardStepSuccess) {
                          return TabBar(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            indicatorWeight: 4,
                            indicatorPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 9),
                            indicatorColor: MainColors.darkPink500,
                            unselectedLabelColor: MainColors.middleGrey400,
                            labelColor: MainColors.middleGrey900,
                            labelStyle: MainStyles.boldTextStyle,
                            controller: stepTabController,
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_week").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_month").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_all_time").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                            ],
                          );
                        }else{
                          return Container(

                          );
                        }
                      }
                  ),
                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeStep)
                  LeaderBoardStepView(tabController: stepTabController,),


                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeDonation)
                  BlocBuilder<LeaderBoardDonationCubit, LeaderBoardDonationState>(
                      builder: (context, leaderBoardDonationState) {

                        if(leaderBoardDonationState is LeaderBoardDonationSuccess) {
                          return TabBar(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            indicatorWeight: 4,
                            indicatorPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 9),
                            indicatorColor: MainColors.darkPink500,
                            unselectedLabelColor: MainColors.middleGrey400,
                            labelColor: MainColors.middleGrey900,
                            labelStyle: MainStyles.boldTextStyle,
                            controller: donationTabController,
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_week").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_month").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_all_time").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                            ],
                          );
                        }else{
                          return Container(

                          );
                        }
                      }
                  ),
                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.leaderBoardTypeDonation)
                  LeaderBoardDonationView(tabController: donationTabController, ),
              ],
            );
          }
        ),
      ),
    );
  }


  @override
  // TODO: implement pageKey
  PageKeyModel get pageKey => PageKeyConstant.allRanking;
}




