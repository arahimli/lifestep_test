
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/appbar/auth-notification.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/pages/leaderboard/logic/donation/state.dart';
import 'package:lifestep/pages/leaderboard/logic/donation/view.dart';
import 'package:lifestep/pages/leaderboard/logic/step/view.dart';
import 'package:lifestep/pages/leaderboard/tools/enum.dart';
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

class _LeaderBoardDetailViewState extends State<LeaderBoardDetailView> with TickerProviderStateMixin {

  late TabController stepTabController;
  late TabController donationTabController;

  @override
  void initState() {
    // addData();

    stepTabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);
    donationTabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                SizedBox(height: 4,),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    padding: EdgeInsets.symmetric(
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
                                onTap: () => context.read<LeaderBoardDetailCubit>().onChangeValue(LeaderBoardTypeEnum.LeaderBoardTypeStep),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.LeaderBoardTypeStep ? MainColors.white : null,
                                        borderRadius: BorderRadius.circular(64)
                                    ),
                                    padding: EdgeInsets.symmetric(
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
                          SizedBox(width: 8,),
                          Expanded(
                              child: GestureDetector(
                                onTap: () => context.read<LeaderBoardDetailCubit>().onChangeValue(LeaderBoardTypeEnum.LeaderBoardTypeDonation),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.LeaderBoardTypeDonation ? MainColors.white : null,
                                        borderRadius: BorderRadius.circular(64)
                                    ),
                                    padding: EdgeInsets.symmetric(
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
                SizedBox(height: 4,),

                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.LeaderBoardTypeStep)
                  BlocBuilder<LeaderBoardStepCubit, LeaderBoardStepState>(
                      builder: (context, leaderBoardStepState) {
                        if(leaderBoardStepState is LeaderBoardStepSuccess) {
                          return TabBar(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            indicatorWeight: 4,
                            indicatorPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                            labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 9),
                            indicatorColor: MainColors.darkPink500,
                            unselectedLabelColor: MainColors.middleGrey400,
                            labelColor: MainColors.middleGrey900,
                            labelStyle: MainStyles.boldTextStyle,
                            controller: stepTabController,
                            tabs: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_week").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_month").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
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
                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.LeaderBoardTypeStep)
                  LeaderBoardStepView(tabController: stepTabController,),


                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.LeaderBoardTypeDonation)
                  BlocBuilder<LeaderBoardDonationCubit, LeaderBoardDonationState>(
                      builder: (context, leaderBoardDonationState) {

                        if(leaderBoardDonationState is LeaderBoardDonationSuccess) {
                          return TabBar(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            indicatorWeight: 4,
                            indicatorPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                            labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 9),
                            indicatorColor: MainColors.darkPink500,
                            unselectedLabelColor: MainColors.middleGrey400,
                            labelColor: MainColors.middleGrey900,
                            labelStyle: MainStyles.boldTextStyle,
                            controller: donationTabController,
                            tabs: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_week").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(Utils.getString(context, "leader_board_view___tab_month").toUpperCase(), style: MainStyles.tabTextStyle),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
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
                if(leaderBoardDetailState.leaderBoardTypeEnum == LeaderBoardTypeEnum.LeaderBoardTypeDonation)
                  LeaderBoardDonationView(tabController: donationTabController, ),
              ],
            );
          }
        ),
      ),
    );
  }
}



class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}


