
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/challenge/participants.dart';
import 'package:lifestep/src/models/challenge/participants_step_base.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/error/general_widget.dart';
import 'package:lifestep/src/tools/components/shimmers/general/rectangle.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list-no-scrolling.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants/state.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants_step_base/cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants_step_base/state.dart';
import 'package:sprintf/sprintf.dart';

class TrackBaseParticipantList extends StatefulWidget {
  const TrackBaseParticipantList({Key? key}) : super(key: key);

  @override
  State<TrackBaseParticipantList> createState() => _TrackBaseParticipantListState();
}

class _TrackBaseParticipantListState extends State<TrackBaseParticipantList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantListCubit, ParticipantListState>(
        builder: (context, stateParticipant) {
          //////// print("BlocBuilder<ParticipantListCubit, ParticipantListState>");
          //////// print(stateParticipant);
          return stateParticipant is ParticipantListSuccess ? ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 4,);
            },
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: stateParticipant.dataList.length,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _DataItem(index: index, participantModel: stateParticipant.dataList[index]);
            },
          ) : stateParticipant is ParticipantListError ?
          GeneralErrorLoadAgainWidget(
            onTap: (){
              context.read<ParticipantListCubit>().search();
            },
          )
              : const SkeletonNoScrollingListWidget(
            child: DonorListItemShimmerWidget(),
          );
        }
    );
  }
}


class _DataItem extends StatelessWidget {
  final int index;
  final ParticipantModel participantModel;
  const _DataItem({Key? key, required this.index, required this.participantModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
      ),
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
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
              // Container(
              //   clipBehavior: Clip.antiAlias,
              //   padding: const EdgeInsets.symmetric(
              //     // vertical: 12,
              //     // horizontal: 12,
              //   ),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(500),
              //   ),
              //   child: Image.asset(
              //     participantModel.genderType.getImage,
              //     width: size.width * 0.6 / 6,
              //     height: size.width * 0.6 / 6,
              //   ),
              //   // child: CachedNetworkImage(
              //   //   placeholder: (context, key){
              //   //     return Container(
              //   //       width: size.width * 0.6 / 6,
              //   //       height: size.width * 0.6 / 6,
              //   //       decoration: BoxDecoration(
              //   //         // color: Colors.blue,
              //   //         image: DecorationImage(
              //   //           image: AssetImage("assets/images/general/gray-shimmer.gif", ),
              //   //           fit: BoxFit.fill,
              //   //         ),
              //   //         borderRadius:
              //   //         BorderRadius.all(
              //   //           Radius.circular(500.0),
              //   //         ),
              //   //       ),
              //   //     );
              //   //   },
              //   //   // key: Key("${"vvvvv"}${1}"),
              //   //   // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
              //   //   imageUrl: MainConfig.defaultImage,
              //   //   width: size.width * 0.6 / 6,
              //   //   height: size.width * 0.6 / 6,
              //   // )
              // ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        participantModel.fullName ?? "-",
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        sprintf(Utils.getString(context, "challenges_details_view___participant_minute"), [((participantModel.time != null ? participantModel.time! : 0) / 60).round()]),
                        style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 12, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              Text((index + 1).toString(),
                style: MainStyles.extraBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 14, height: 1.1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
