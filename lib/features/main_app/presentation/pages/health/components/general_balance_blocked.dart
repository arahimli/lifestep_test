
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/navigation_bloc.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/state.dart';
import 'package:lifestep/features/tools/general/padding/page_padding.dart';

class GeneralBalanceBlockedView extends StatefulWidget {
  const GeneralBalanceBlockedView({Key? key}) : super(key: key);

  @override
  _GeneralBalanceBlockedViewState createState() => _GeneralBalanceBlockedViewState();
}

class _GeneralBalanceBlockedViewState extends State<GeneralBalanceBlockedView> {

  PageController pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          return sessionState.currentUser != null ? Column(
            children: [
              GridView(
                padding: const PagePadding.leftRight16(),
                physics: const ScrollPhysics(),
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
                    onTap: (){
                      navigationBloc.changeNavigationIndex(Navigation.donations);
                    },
                    backgroundColor: MainColors.darkPink500!,
                    steps: "${sessionState.currentUser!.balanceSteps.toString().length > 6 ? Utils.humanizeInteger(context, sessionState.currentUser!.balanceSteps ?? 0) : sessionState.currentUser!.balanceSteps ?? 0}  ${Utils.getString(context, "general__steps__count")}",
                  ),
                ],
              ),


              const SizedBox(height: 12,),
            ],
          ):Container();
        }
    );
  }
}



class _InformationItemWidget extends StatelessWidget {
  final Color backgroundColor;
  final String steps;
  final Function? onTap;
  const _InformationItemWidget({Key? key, required this.backgroundColor,  required this.steps, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          if(onTap != null){
            onTap!();}
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/svgs/health/blocked-balance.svg"),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(Utils.getString(context, "general_balance_blocked"), style: MainStyles.boldTextStyle.copyWith(fontSize: 14 ,color: MainColors.white, height: 1.2), maxLines: 2,),
                    ),
                    Text(steps, style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14 ,color: MainColors.white!.withOpacity(0.7)))
                  ],
                ),
              ),
              const SizedBox(width: 12,),
              GestureDetector(child: SvgPicture.asset("assets/svgs/health/blocked-balance-next.svg")),
            ],
          ),
        ),
      ),
    );
  }
}



