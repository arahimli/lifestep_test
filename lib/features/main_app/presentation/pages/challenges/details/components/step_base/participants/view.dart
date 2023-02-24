
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/participants_step_base.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/general_widget.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/general/rectangle.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton_list_no_scrolling.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants_step_base/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants_step_base/state.dart';

class StepBaseParticipantList extends StatefulWidget {
  const StepBaseParticipantList({Key? key}) : super(key: key);

  @override
  State<StepBaseParticipantList> createState() => _StepBaseParticipantListState();
}

class _StepBaseParticipantListState extends State<StepBaseParticipantList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepBaseParticipantListCubit, StepBaseParticipantListState>(
        builder: (context, stateParticipant) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: AutoSizeText(Utils.getString(context, "challenge_detail_view__step_base_last_members"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),)
                  ),
                  // BlocBuilder<ParticipantListCubit, ParticipantListState>(
                  //     builder: (context, stateParticipant) {
                  //       return stateParticipant is ParticipantListSuccess ?
                  //       AutoSizeText("${stateParticipant.dataCount} ${Utils.getString(context, "general__person__count")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),)
                  //           : Container(child: Text(" "),);
                  //     }
                  // ),
                ],
              ),
              stateParticipant is StepBaseParticipantListSuccess ? ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 4,);
                },
                padding: const EdgeInsets.symmetric(horizontal: 0),
                itemCount: stateParticipant.dataList.length,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return _StepBaseParticipantItem(index: index, stepBaseParticipantModel: stateParticipant.dataList[index]);
                },
              ) : stateParticipant is StepBaseParticipantListError ?
              GeneralErrorLoadAgainWidget(
                onTap: (){
                  context.read<StepBaseParticipantListCubit>().search();
                },
              )
                  : const SkeletonNoScrollingListWidget(
                child: DonorListItemShimmerWidget(),
              )
            ],
          );
        }
    );
  }
}



class _StepBaseParticipantItem extends StatelessWidget {
  final int index;
  final StepBaseParticipantModel stepBaseParticipantModel;
  const _StepBaseParticipantItem({Key? key, required this.index, required this.stepBaseParticipantModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
      ),
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
//          focusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: MainColors.white,
            // border: Border(
            //   bottom: BorderSide(
            //     color: MainColors.middleGrey200!
            //   )
            // )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 12,
                    // top: 4,
                    // bottom: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        stepBaseParticipantModel.fullName ?? "-",
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // const SizedBox(height: 8),
                      // AutoSizeText(
                      //   "${stepBaseParticipantModel.steps} ${Utils.getString(context, "challenges_details_view___participant_minute")}",
                      //   style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 12, height: 1.1),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
              ),
              AutoSizeText(
                "${Utils.humanizeInteger(context, stepBaseParticipantModel.steps ?? 0)} ${Utils.getString(context, "general__steps__count")}",
                style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 12, height: 1.1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Text("${(index + 1).toString()}",
              //   style: MainStyles.extraBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 14, height: 1.1),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
