import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/components/error/general_widget.dart';
import 'package:lifestep/src/tools/components/shimmers/step/step-list-item.dart';
import 'package:lifestep/src/tools/constants/enum.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/step/user_item.dart';
import 'package:lifestep/src/ui/home/components/liderboard_item.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';
import 'cubit.dart';
import 'state.dart';

class AllDonationUserOrderView extends StatelessWidget {
  final bool display;
  final double? horizontalPadding;
  const AllDonationUserOrderView({Key? key, this.display = true, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(display) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0),
        child: BlocBuilder<
            GeneralUserLeaderBoardAllDonationCubit,
            GeneralUserLeaderBoardAllDonationState>(
            builder: (context, state) {
              if (state is GeneralUserLeaderBoardAllDonationSuccess) {
                return HomeLiderDataItem(
                  // borderRadius: 12,
                  index: state.mainData.number! == 0 ? -1 : state.mainData
                      .number!,
                  owner: true,
                  userStepOrderModel: UserStepOrderModel(
                      id: BlocProvider
                          .of<SessionCubit>(context)
                          .currentUser != null ? BlocProvider
                          .of<SessionCubit>(context)
                          .currentUser!
                          .id : 0,
                      fullName: BlocProvider
                          .of<SessionCubit>(context)
                          .currentUser != null ? BlocProvider
                          .of<SessionCubit>(context)
                          .currentUser!
                          .name : '',
                      genderType: BlocProvider
                          .of<SessionCubit>(context)
                          .currentUser != null ? BlocProvider
                          .of<SessionCubit>(context)
                          .currentUser!
                          .genderType : GENDER_TYPE.MAN,
                      step: state.mainData.userRating != null ? state.mainData
                          .userRating!.steps : 0
                  ),
                );
              }
              else if (state is GeneralUserLeaderBoardAllDonationError) {
                return Padding(
                  padding: PagePadding.leftRight16(),
                  child: GeneralErrorLoadAgainWidget(
                    onTap: () {
                      context.read<GeneralUserLeaderBoardAllDonationCubit>()
                          .refresh();
                    },
                  ),
                );
              }
              else {
                return const LeadderDataItemShimmerWidget(
                  owner: true,
                );
              }
            }
        ),
      );
    }
    else {
      return Container();
    }
  }
}
