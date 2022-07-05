

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/logic/session/state.dart';
import 'package:lifestep/logic/settings/cubit.dart';
import 'package:lifestep/logic/settings/state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GeneralBalanceBlockedView extends StatefulWidget {
  const GeneralBalanceBlockedView({Key? key}) : super(key: key);

  @override
  _GeneralBalanceBlockedViewState createState() => _GeneralBalanceBlockedViewState();
}

class _GeneralBalanceBlockedViewState extends State<GeneralBalanceBlockedView> {

  PageController pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          return sessionState.currentUser != null ? Column(
            children: [
              GridView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
//                                        maxCrossAxisExtent: 220,
//                                        childAspectRatio: 0.6
                  crossAxisCount: 1,
                  childAspectRatio: 2.8,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                children: [
                  _InformationItemWidget(
                    backgroundColor: MainColors.darkPink500!,
                    steps: 2000,
                  ),
                ],
              ),


              SizedBox(height: 12,),
            ],
          ):Container();
        }
    );
  }
}



class _InformationItemWidget extends StatelessWidget {
  final Color backgroundColor;
  final int steps;
  const _InformationItemWidget({Key? key, required this.backgroundColor,  required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            // color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svgs/health/blocked-balance.svg"),
                SizedBox(width: 12,),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text("Balansınız dondurulub. Davam etmək üçün ianə edin.", style: MainStyles.boldTextStyle.copyWith(fontSize: 15 ,color: MainColors.white),),
                        ),
                        Text("20 230 addım", style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 15 ,color: MainColors.white!.withOpacity(0.7)))
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                SvgPicture.asset("assets/svgs/health/blocked-balance-next.svg"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



