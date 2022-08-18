
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health/health.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/auth-notification.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/constants/page_key.dart';
import 'package:lifestep/src/tools/use_cases/logger/logger_mixin.dart';
import 'package:lifestep/src/ui/health/logic/month/view.dart';
import 'package:lifestep/src/ui/health/logic/today/view.dart';
import 'package:lifestep/src/ui/health/logic/week/view.dart';

import 'components/general_balance.dart';


class HealthDetailView extends StatefulWidget {
  const HealthDetailView({Key? key}) : super(key: key);

  @override
  _HealthDetailViewState createState() => _HealthDetailViewState();
}

class _HealthDetailViewState extends State<HealthDetailView> with TickerProviderStateMixin, LoggerMixin {
  late TabController tabController;
  ScrollController monthScrollController = ScrollController();


  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  @override
  void init() {
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
            const SizedBox(height: 4,),
            GeneralBalanceOverView(),
            const SizedBox(height: 4,),
            TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              indicatorWeight: 4,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              labelPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 9),
              indicatorColor: MainColors.darkPink500,
              unselectedLabelColor: MainColors.middleGrey400,
              labelColor: MainColors.middleGrey900,
              labelStyle: MainStyles.boldTextStyle,
              controller: tabController,
              tabs: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(Utils.getString(context, "health_detail_view___tab_today").toUpperCase(), style: MainStyles.tabTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(Utils.getString(context, "health_detail_view___tab_week").toUpperCase(), style: MainStyles.tabTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
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

  @override
  // TODO: implement pageKey
  PageKeyModel get pageKey => PageKeyConstant.fitnessData;
}




