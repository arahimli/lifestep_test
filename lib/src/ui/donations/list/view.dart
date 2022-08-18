import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/appbar/auth-left.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/ui/donations/list/logic/charity_list_cubit.dart';
import 'package:lifestep/src/ui/donations/list/logic/fond_list_cubit.dart';
import 'package:lifestep/src/ui/donations/list/tabs/personal.dart';
import 'package:lifestep/src/ui/index/logic/navigation_bloc.dart';

class DonationListView extends StatefulWidget {
  const DonationListView({Key? key}) : super(key: key);

  @override
  _DonationListViewState createState() => _DonationListViewState();
}

class _DonationListViewState extends State<DonationListView> with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {

    tabController = TabController(length: 1,
        // animationDuration: Duration(milliseconds: 300),
        initialIndex: 0, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        navigationBloc.changeNavigationIndex(Navigation.HOME);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: MainColors.white,
        body: SafeArea(
          child: Column(
            children: [
              AuthLeftAppBar(
                title: Utils.getString(context, "page_donation_list___title"),
              ),
              const SizedBox(height: 4,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoSearchTextField(
                        controller: searchTextController,
                        // backgroundColor: MainColors.backgroundColor,
                        decoration: BoxDecoration(
                          color: MainColors.backgroundColor,
                          // border: Border.all(
                          //   color: Color(0xFFE2E6EE),
                          //   width: 1,
                          // ),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        onChanged: (value){},
                        onSubmitted: (value){
                          Utils.focusClose(context);
                          if(tabController.index == 0){
                            context.read<CharityListCubit>().search(value, reset: true);
                          }else{
                            context.read<FondListCubit>().search(value, reset: true);
                          }

                        },
                        onSuffixTap: (){
                          //////// print("4545");
                          Utils.focusClose(context);
                          searchTextController.text = '';
                          // if(tabController.index == 0){
                            context.read<CharityListCubit>().search('', reset: true);
                          // }else{
                            context.read<FondListCubit>().search('', reset: true);
                          // }
                        },
                        // style: MainStyles.normalTextStyle,
                        // placeholderStyle: MainStyles.grayTextStyle,
                        itemSize: size.height / (836 / 24),
                        itemColor: Color(0xFFC3C5D4),
                        placeholder: Utils.getString(context, "page_donation_list___search_hint"),
                        placeholderStyle: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.generalCupertinoSearchPlaceholder),
                        padding: EdgeInsets.symmetric(vertical: size.height / (836 / 16), horizontal: size.width / (375 / 16)),
                        prefixInsets: EdgeInsets.only(left: size.width / (375 / 16)),
                        suffixInsets: EdgeInsets.only(right: size.width / (375 / 16)),
                        suffixMode: OverlayVisibilityMode.editing,
                        prefixIcon: SvgPicture.asset("assets/svgs/general/search.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              // TabBar(
              //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              //   indicatorWeight: 4,
              //   // indicator: UnderlineTabIndicator(
              //   //   borderSide: BorderSide(
              //   //     color: Colors.yellow,
              //   //     width: 2.0,
              //   //   ),
              //   // ),
              //   indicatorColor: MainColors.darkPink500,
              //   unselectedLabelColor: MainColors.middleGrey400,
              //   labelColor: MainColors.middleGrey900,
              //   labelStyle: MainStyles.boldTextStyle,
              //   controller: tabController,
              //   tabs: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 12.0),
              //       child: Text(Utils.getString(context, "page_donation_list___tab_personal").toUpperCase(), style: MainStyles.tabTextStyle ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 12.0),
              //       child: Text(Utils.getString(context, "page_donation_list___tab_fonds").toUpperCase(), style: MainStyles.tabTextStyle),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16,),
              Flexible(
                  flex: 1,
                  child:
                  ScrollConfiguration(
                    behavior: MainScrollBehavior(),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        PersonalTabView(),
                        // FondTabView(),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}


