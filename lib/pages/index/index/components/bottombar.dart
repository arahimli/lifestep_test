import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/pages/index/index/navigation_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int index;

  const MainBottomNavigationBar({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      backgroundColor: MainColors.white,
      unselectedItemColor: MainColors.bottomBarUnselectedColor,
      selectedItemColor: MainColors.darkPink500,
      unselectedLabelStyle: MainStyles.semiBoldTextStyle.copyWith(
          fontSize: 13,
          color: MainColors.bottomBarUnselectedColor),
      selectedLabelStyle: MainStyles.boldTextStyle.copyWith(fontSize: 13, color: MainColors.darkPink500),
      showUnselectedLabels: true,

      elevation: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (i){
        //////// print("navigationBloc.changeNavigationIndex");
        //////// print(i);
        //////// print(Navigation.values[i]);
        //////// print("navigationBloc.changeNavigationIndex");
        navigationBloc.changeNavigationIndex(Navigation.values[i]);
      },
      items: [
        /// Home
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/home.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/home.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__home"),
        ),

        /// Likes
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/donations.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/donations.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__donations")
        ),

        /// Search
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/challenges.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/challenges.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__challenges"),
        ),

        // / Profile
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/profile.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/profile.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__profile"),
        ),
      ],
    );
  }
}



class MainStandartBottomNavigationBar extends StatelessWidget {
  final int index;

  const MainStandartBottomNavigationBar({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BottomNavigationBar(
        //...
        // it
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map),
            label: Utils.getString(
                context, "home__drawer_menu_home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map),
            label: Utils.getString(
                context, "home__drawer_menu_call_us"),
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.map),
            icon: Icon(Icons.map),
            // icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map),
            label: 'Barcode',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        selectedItemColor: MainColors.mainColor /*.shade900*/,
        // selectedItemColor: Color(0xFF4769ab) /*.shade900*/,
        currentIndex: index,
        onTap: (index) {

    }
        // onTap: (index) => index != 3
        //     ? navigationBloc.changeNavigationIndex(
        //     Navigation.values[index])
        //     : Navigator.push(
        //     context,
        //     SlideRightRoute(
        //         page: LoginContainerView())),
      );
  }
}
