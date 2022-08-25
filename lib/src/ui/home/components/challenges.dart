
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/arguments/challenge_detail_view.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/challenge/inner.dart';
import 'package:lifestep/src/models/home/challenge_list.dart';
import 'package:lifestep/src/tools/components/error/general_widget.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton.dart';
import 'package:lifestep/src/tools/config/cache_image_key.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';
import 'package:lifestep/src/ui/challenges/details/view.dart';
import 'package:lifestep/src/ui/index/logic/challenge/cubit.dart';
import 'package:lifestep/src/ui/index/logic/challenge/state.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/ui/index/logic/navigation_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeChallengeWidget extends StatefulWidget {
  const HomeChallengeWidget({Key? key}) : super(key: key);

  @override
  State<HomeChallengeWidget> createState() => _HomeChallengeWidgetState();
}

class _HomeChallengeWidgetState extends State<HomeChallengeWidget> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return BlocBuilder<HomeChallengeListCubit, HomeChallengeListState>(
        builder: (context, state) {
          if(state is HomeChallengeListSuccess) {
            List<ChallengeModel> challengeList = state.dataList ?? [];
            List<StepInnerModel> stepInnerList = state.stepInnerList ?? [];

            return challengeList.isNotEmpty ?
              Column(
                children: [
                  const _SectionTitleWidget(),
                  SizedBox(
                    height: size.width * 1.1 / 6 + 36,
                    child: PageView.builder(
                      controller: PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93),
                      itemCount: challengeList.length ,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, ind){
                        ChallengeModel item = challengeList[ind];
                        double generalWidth = challengeList.length > 1 ? MediaQuery.of(context).size.width - 48 : MediaQuery.of(context).size.width - 32;
                        return _ChallengeWidget(
                          index: ind,
                          isLast: (challengeList.length - 1) <= ind ,
                          dataList: challengeList,
                          stepInnerModelList: stepInnerList,
                          dataItem: item,
                          stepInnerModel: stepInnerList.isNotEmpty && stepInnerList.length > ind ? stepInnerList[ind] : null ,
                          generalWidth: generalWidth,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16,),
                ],
              ):
              Container();
          }
          else if(state is HomeChallengeListError){
            return Column(
              children: [
                const _SectionTitleWidget(),
                Padding(
                  padding: PagePadding.leftRight16(),
                  child: GeneralErrorLoadAgainWidget(
                    onTap: (){
                      context.read<HomeChallengeListCubit>().refresh();
                    },
                  ),
                ),
                const SizedBox(height: 16,),
              ],
            );
          }
          else{
            return Column(
              children: [
                const _SectionTitleWidget(),
                SkeltonWidget(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: size.width * 1.1 / 6 + 36,
                  borderRadius: 8,
                  // width: 16,
                ),
                const SizedBox(height: 16,),
              ],
            );
          }
        }
    );

  }
}


class _SectionTitleWidget extends StatelessWidget {
  const _SectionTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: PagePadding.leftRight16(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(Utils.getString(context, "home__challenges_title"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                InkWell(
                    onTap: (){
                      navigationBloc.changeNavigationIndex(Navigation.challenges);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: AutoSizeText(Utils.getString(context, "general__all"), style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),),
                    )
                ),
              ],
            )
        ),
        const SizedBox(height: 16,),
      ],
    );
  }
}



class _ChallengeWidget extends StatelessWidget {
  final List<ChallengeModel> dataList;
  final List<StepInnerModel> stepInnerModelList;
  final ChallengeModel dataItem;
  final StepInnerModel? stepInnerModel;
  final int index;
  final bool isLast;
  final double generalWidth;
  const _ChallengeWidget({Key? key, required this.dataItem, required this.index, required this.generalWidth, required this.isLast, this.stepInnerModel, required this.dataList, required this.stepInnerModelList }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 1.1 / 6 + 4;
    ChallengeLevelModel? challengeLevelModel;
    int userSteps = 0;
    double realPercent = 0;
    double resultPercent = 0;
    String textPercent = '';
    if(stepInnerModel != null && stepInnerModel!.challengeLevels != null && stepInnerModel!.challengeLevels!.isNotEmpty) {
      
      challengeLevelModel = stepInnerModel!.challengeLevels![Utils.findRangeIndex(
          listData: stepInnerModel!.challengeLevels!.map((e) => e.goal!)
              .toList(), value: stepInnerModel!.userSteps!)];
      userSteps = stepInnerModel!.userSteps ?? 0;
      realPercent = (challengeLevelModel.goal! == 0 ? 0 : userSteps > challengeLevelModel.goal! ? 1: userSteps / challengeLevelModel.goal!);
      resultPercent = Utils.roundNumber((challengeLevelModel.goal! == 0 ? 0 : userSteps > challengeLevelModel.goal! ? 1: userSteps / challengeLevelModel.goal!));
      textPercent = "${realPercent > 0.999 && realPercent < 1 ? '99.9' : Utils.roundNumber((realPercent) * 100, toPoint: 1)}%";
    }
    return Container(
      width: generalWidth,
      margin: EdgeInsets.only(right: !isLast ? 6 : 2),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          Navigator.pushNamed(
            context,
            ChallengeDetailView.routeName,
            arguments: ChallengeDetailViewArguments(
                dataItem: dataItem
            ),
          ).then((value){
            if(value != null && value is ChallengeModel ){
              BlocProvider.of<HomeChallengeListCubit>(context).changeChallenge(listValue: dataList, listStepInnerModel: stepInnerModelList, boolValue: true, value: value, index: index);
            }
          });

        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16, ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: MainColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(

                        // child:
                        // CircularProgressIndicator(
                        //   valueColor:
                        //   AlwaysStoppedAnimation<Color>(
                        //       Colors.orange),
                        // ),
                        width: imageSize,
                        height: imageSize,
                        decoration: const BoxDecoration(
                          // color: Colors.blue,
                          image: DecorationImage(
                            image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      );
                    },
                    key: Key("${MainWidgetKey.challengeItem}${dataItem.id}"),
                    fit: BoxFit.cover,
                    imageUrl: dataItem.getImage(),
                    width: imageSize,
                    height: imageSize,
                  )
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        dataItem.name ?? '',
                        style: MainStyles.extraBoldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Column(
                        children: [
                          if(challengeLevelModel != null)
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "${Utils.humanizeInteger(context, userSteps)}",
                                      style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 13, height: 1.1),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                          "/${Utils.humanizeInteger(context, challengeLevelModel.goal ?? 0)} ",
                                          style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 13, height: 1.1),
                                        ),
                                        TextSpan(
                                          text:
                                          Utils.getString(context, "home__charity_list_subtitle"),
                                          style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 13, height: 1.1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // AutoSizeText(
                                //   sprintf(Utils.getString(context, "challenges_view___date_pattern"), [dataItem.endDate != null ? Utils.stringToDatetoString(value: dataItem.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-']),
                                //   style: MainStyles.boldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 14, height: 1.1),
                                //   maxLines: 1,
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                              ],
                            ),
                          if(challengeLevelModel != null)
                            const SizedBox(height: 8),
                          if(challengeLevelModel != null)
                            LinearPercentIndicator(
                              lineHeight: 8.0,
                              percent: resultPercent,
                              trailing: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  textPercent,
                                  style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleBlue300, fontSize:  12, ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              progressColor: MainColors.middleBlue300,
                              backgroundColor: MainColors.middleGrey100,
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}