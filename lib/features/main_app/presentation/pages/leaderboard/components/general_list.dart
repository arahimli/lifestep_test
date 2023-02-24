
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/constants/enum.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/step/donation/all/view.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/step/donation/month/view.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/step/donation/week/view.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/step/step/all/view.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/step/step/month/view.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/step/step/week/view.dart';
import 'package:lifestep/features/main_app/data/models/leaderboard/list.dart';
import 'package:lifestep/features/main_app/data/models/step/user_item.dart';
import 'package:lifestep/features/main_app/presentation/pages/home/components/liderboard_item.dart';

class GeneralListItem extends StatelessWidget {
  final Function refresh;
  final USER_ORDER_STEP_TYPE widgetType;
  final List<UsersRatingModel> ratingList;
  const GeneralListItem({Key? key, required this.ratingList, required this.refresh, required this.widgetType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
              builder: (context, constraints) {
                return RefreshIndicator(
                  // onRefresh: ()async{
                  //   // await context.read<ChallengeListCubit>().refresh();
                  // },
                  onRefresh: ()async{
                    await refresh();
                  },
                  child: ScrollConfiguration(
                    behavior: MainScrollBehavior(),
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        // controller: context.read<ChallengeListCubit>().scrollController,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraints.maxHeight
                          ),
                          // padding: const PagePadding.leftRight16(),
                          child: Column(
                            children: ratingList.asMap().entries.map((entry) => HomeLiderDataItem(
                              owner: BlocProvider.of<SessionCubit>(context).currentUser != null ? BlocProvider.of<SessionCubit>(context).currentUser!.id == entry.value.userId : false,
                              index: entry.key,
                              userStepOrderModel: UserStepOrderModel(
                                  id: entry.value.userId,
                                  fullName: entry.value.name ?? '',
                                  genderType: entry.value.genderType,
                                  step: entry.value.steps ?? 0
                              ),
                            )).toList(),
                          ),
                        )
                    ),
                  ),
                );
              }
          ),
        ),
        if(widgetType == USER_ORDER_STEP_TYPE.stepWeek)
          WeekStepUserOrderView(
            display: BlocProvider.of<SessionCubit>(context).currentUser != null && !ratingList.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id)
          ),
        if(widgetType == USER_ORDER_STEP_TYPE.stepMonth)
          MonthStepUserOrderView(
              display: BlocProvider.of<SessionCubit>(context).currentUser != null && !ratingList.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id)
          ),
        if(widgetType == USER_ORDER_STEP_TYPE.stepAll)
          AllStepUserOrderView(
              display: BlocProvider.of<SessionCubit>(context).currentUser != null && !ratingList.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id)
          ),
        if(widgetType == USER_ORDER_STEP_TYPE.donationWeek)
          WeekDonationUserOrderView(
              display: BlocProvider.of<SessionCubit>(context).currentUser != null && !ratingList.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id)
          ),
        if(widgetType == USER_ORDER_STEP_TYPE.donationMonth)
          MonthDonationUserOrderView(
              display: BlocProvider.of<SessionCubit>(context).currentUser != null && !ratingList.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id)
          ),
        if(widgetType == USER_ORDER_STEP_TYPE.donationAll)
          AllDonationUserOrderView(
              display: BlocProvider.of<SessionCubit>(context).currentUser != null && !ratingList.map((element) => element.userId).contains(BlocProvider.of<SessionCubit>(context).currentUser!.id)
          ),

      ],
    );
  }
}
