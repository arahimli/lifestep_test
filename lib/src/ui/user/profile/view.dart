import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/auth_notification.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/constants/page_key.dart';
import 'package:lifestep/src/tools/use_cases/logger/logger_mixin.dart';
import 'package:lifestep/src/ui/health/components/general_balance.dart';
import 'package:lifestep/src/ui/index/logic/navigation_bloc.dart';
import 'package:lifestep/src/ui/user/profile/achievement/view.dart';
import 'package:lifestep/src/ui/user/profile/information/view.dart';
import 'package:lifestep/src/ui/user/profile/settings/view.dart';

class ProfileView extends StatefulWidget {
  final bool backPermit;
  const ProfileView({Key? key, this.backPermit= true}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin, LoggerMixin{
  late TabController tabController;
  PageController pageController = PageController(viewportFraction: 1.0);


  @override
  void init() {

    tabController = TabController(length: 3,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(!widget.backPermit) {
          navigationBloc.changeNavigationIndex(Navigation.home);
        }
        return Future.value(widget.backPermit);
      },
      child: Scaffold(
        backgroundColor: MainColors.white,
        body: SafeArea(
          child: Column(
            children: [
              AuthNotificationAppbar(
                title: Utils.getString(context, "profile_view___title"),
                backPermit: widget.backPermit,
                // textStyle: MainStyles.boldTextStyle.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 4,),

              const GeneralBalanceOverView(),

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
                    child: Text(Utils.getString(context, "profile_view___tab_information").toUpperCase(), style: MainStyles.tabTextStyle,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(Utils.getString(context, "profile_view___tab_achievements").toUpperCase(), style: MainStyles.tabTextStyle,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(Utils.getString(context, "profile_view___tab_settings").toUpperCase(), style: MainStyles.tabTextStyle,),
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
                        children: const [
                          InformationWidget(),
                          AchievementListWidget(),
                          SettingsWidget(),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PageKeyModel get pageKey => PageKeyConstant.userProfile;

  // @override
  // void disp() {
  // }
}
