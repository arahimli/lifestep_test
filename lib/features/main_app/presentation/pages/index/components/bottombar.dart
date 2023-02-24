import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/navigation_bloc.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int index;
  final Function() onAction;

  const MainBottomNavigationBar({Key? key, required this.index, required this.onAction}) : super(key: key);
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
      // mouseCursor: MouseCursor.defer,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (i){
        //////// print("navigationBloc.changeNavigationIndex");
        //////// print(i);
        //////// print(Navigation.values[i]);
        //////// print("navigationBloc.changeNavigationIndex");
        if([0,2,3].contains(i)){
          onAction();
        }
        navigationBloc.changeNavigationIndex(Navigation.values[i]);
      },
      items: [
        /// Home
        BottomNavigationBarItem(
          tooltip: '',
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/home.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/home.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__home"),
        ),

        /// Likes
        BottomNavigationBarItem(
          tooltip: '',
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/donations.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/donations.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__donations")
        ),

        /// Search
        BottomNavigationBarItem(
          tooltip: '',
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/challenges.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/challenges.svg", color: MainColors.darkPink500,),
          ),
          label: Utils.getString(context, "bottom_navigation_bar__challenges"),
        ),

        // / Profile
        BottomNavigationBarItem(
          tooltip: '',
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: SvgPicture.asset("assets/svgs/bottom/profile.svg", color: MainColors.bottomBarUnselectedColor,),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
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
            icon: const Icon(Icons.map),
            activeIcon: const Icon(Icons.map),
            label: Utils.getString(
                context, "home__drawer_menu_home"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            activeIcon: const Icon(Icons.map),
            label: Utils.getString(
                context, "home__drawer_menu_call_us"),
          ),
          const BottomNavigationBarItem(
            // icon: const Icon(Icons.map),
            icon: Icon(Icons.map),
            // icon: const Icon(Icons.map),
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
