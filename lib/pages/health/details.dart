
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health/health.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/appbar/auth-notification.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/session/state.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:lifestep/pages/health/logic/month/view.dart';
import 'package:lifestep/pages/health/logic/today/view.dart';
import 'package:lifestep/pages/health/logic/week/view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/general_balance.dart';
import 'components/general_balance_blocked.dart';


class HealthDetailView extends StatefulWidget {
  const HealthDetailView({Key? key}) : super(key: key);

  @override
  _HealthDetailViewState createState() => _HealthDetailViewState();
}

class _HealthDetailViewState extends State<HealthDetailView> with TickerProviderStateMixin {
  late TabController tabController;
  ScrollController monthScrollController = ScrollController();


  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  @override
  void initState() {
    // addData();

    tabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);
    tabController.addListener(() async{
      if(tabController.index == 2) {
        if (monthScrollController.hasClients) {
          monthScrollController.animateTo(
              monthScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 10),
              curve: Curves.fastOutSlowIn);
        }
      }
    });
    super.initState();

  }

  PageController pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MainColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AuthNotificationAppbar(
              title: Utils.getString(context, "health_detail_view___title"),
              // textStyle: MainStyles.boldTextStyle.copyWith(fontSize: 24),
            ),
            SizedBox(height: 4,),
            GeneralBalanceOverView(),
            SizedBox(height: 4,),
            GeneralBalanceBlockedView(),
            SizedBox(height: 4,),
            TabBar(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              indicatorWeight: 4,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 9),
              indicatorColor: MainColors.darkPink500,
              unselectedLabelColor: MainColors.middleGrey400,
              labelColor: MainColors.middleGrey900,
              labelStyle: MainStyles.boldTextStyle,
              controller: tabController,
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(Utils.getString(context, "health_detail_view___tab_today").toUpperCase(), style: MainStyles.tabTextStyle),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(Utils.getString(context, "health_detail_view___tab_week").toUpperCase(), style: MainStyles.tabTextStyle),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(Utils.getString(context, "health_detail_view___tab_month").toUpperCase(), style: MainStyles.tabTextStyle),
                ),
              ],
            ),
            Flexible(
                flex: 1,
                child:
                ScrollConfiguration(
                  behavior: MainScrollBehavior(),
                  child: Container(
                    color: MainColors.backgroundColor,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        HealthTodayView(),
                        HealthWeekView(),
                        HealthMonthView(scrollController: monthScrollController,),
                      ],
                    ),
                  ),
                )
            ),
          ],
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


