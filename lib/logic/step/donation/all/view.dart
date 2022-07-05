import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/components/error/general-widget.dart';
import 'package:lifestep/tools/components/shimmers/home-charity/donation-grid-item.dart';
import 'package:lifestep/tools/components/shimmers/step/step-list-item.dart';
import 'package:lifestep/tools/constants/enum.dart';
import 'package:lifestep/logic/session/cubit.dart';
import 'package:lifestep/model/step/user-item.dart';
import 'package:lifestep/pages/home/components/liderboard_item.dart';
import 'cubit.dart';
import 'state.dart';

class AllDonationUserOrderView extends StatelessWidget {
  final bool display;
  final double? horizontalPadding;
  const AllDonationUserOrderView({Key? key, this.display : true, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(display)
      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0),
        child: BlocBuilder<GeneralUserLeaderBoardAllDonationCubit, GeneralUserLeaderBoardAllDonationState>(
          builder: (context, state) {
            if(state is GeneralUserLeaderBoardAllDonationSuccess) {
              return HomeLiderDataItem(
                // borderRadius: 12,
                index: state.mainData.number! == 0 ? -1 : state.mainData.number!,
                owner: true,
                userStepOrderModel: UserStepOrderModel(
                    id: BlocProvider.of<SessionCubit>(context).currentUser != null ? BlocProvider.of<SessionCubit>(context).currentUser!.id : 0,
                    fullName: BlocProvider.of<SessionCubit>(context).currentUser != null ? BlocProvider.of<SessionCubit>(context).currentUser!.name : '',
                    genderType: BlocProvider.of<SessionCubit>(context).currentUser != null ? BlocProvider.of<SessionCubit>(context).currentUser!.genderType : GENDER_TYPE.MAN,
                    step: state.mainData.userRating != null ? state.mainData.userRating!.steps : 0
                ),
              );
            }
            else if(state is GeneralUserLeaderBoardAllDonationError){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GeneralErrorLoadAgainWidget(
                  onTap: (){
                    context.read<GeneralUserLeaderBoardAllDonationCubit>().refresh();
                  },
                ),
              );
            }
            else{
              return LeadderDataItemShimmerWidget(
                owner: true,
              );
            }
          }
        ),
      );
    else
      return Container();
  }
}