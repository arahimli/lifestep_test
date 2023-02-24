import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/data/models/challenge/inner.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/error/general_widget.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton_list_no_scrolling.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/step_base_stage/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/step_base_stage/state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'item.dart';


class StepStageWidget extends StatefulWidget {
  final ChallengeModel challengeModel;
  const StepStageWidget({Key? key, required this.challengeModel}) : super(key: key);

  @override
  State<StepStageWidget> createState() => _StepStageWidgetState();
}

class _StepStageWidgetState extends State<StepStageWidget> {

  late PageController _controller;

  @override
  void initState() {
    log("[LOG] : initState ${"initState"}");
    // _controller = PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    log("[LOG] : StepBaseStageState ${"build"}");
    return BlocConsumer<StepBaseStageCubit, StepBaseStageState>(
      listener: (context, state){},
      builder: (context, state){
        log("[LOG] : StepBaseStageState ${"StepBaseStageState"}");
        if(state is StepBaseStageSuccess ){
          if(widget.challengeModel.isJoined!){
            _controller = PageController(initialPage: Utils.findRangeIndex(listData: state.challengeLevels.map((e) => e.goal!).toList(), value: state.userSteps), keepPage: true, viewportFraction: 0.93);
          } else {
            try {
              _controller.jumpTo(0);
            }catch(e){
              _controller = PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93);
            }
          }
          return Column(
            children: [

              SizedBox(
                height: size.width * 0.9 / 6 + 36,
                child: PageView.builder(
                  // scrollBehavior: ScrollBehavior,
                  controller: _controller,
                  // itemCount: state.challengeLevels!.length ,
                  // scrollDirection: Axis.horizontal,
                  itemCount: state.challengeLevels.length ,
                  scrollDirection: Axis.horizontal,
                  // separatorBuilder: (context, ind){
                  //   return SizedBox(width: 8,);
                  // },
                  onPageChanged: (page){},
                  itemBuilder: (context, ind){
                    ChallengeLevelModel item = state.challengeLevels[ind];
                    double generalWidth = state.challengeLevels.length > 1 ? size.width - 48 : size.width - 32;
                    return StepBaseItemWidget(
                      challengeModel: widget.challengeModel,
                      index: ind,
                      userSteps: state.userSteps,
                      isLast: (state.challengeLevels.length - 1) <= ind ,
                      dataItem: item,
                      generalWidth: generalWidth,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16,),

              SmoothPageIndicator(
                controller: _controller,  // PageController
                count:  state.challengeLevels.length,
                onDotClicked: (int index) async{
                  await _controller.nextPage(
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 300));
                },
                // forcing the indicator to use a specific direction
                // textDirection: TextDirection.RTL,
                effect:  WormEffect(

                  dotColor: MainColors.middleBlue150!,
                  activeDotColor: MainColors.generalSubtitleColor!,
                  dotHeight: 8,
                  dotWidth: 8,
                  strokeWidth: 24,
                ),
              )

            ],
          );
        }
        else if(state is StepBaseStageError) {
          return GeneralErrorLoadAgainWidget(
            onTap: () {
              context.read<StepBaseStageCubit>().search();
            },
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SkeletonNoScrollingListWidget(
            itemCount: 1,
            child: SkeltonWidget(
              height: size.width * 0.9 / 6 + 36,
              // width: 16,
            ),
          ),
        );
      },
    );
  }
}
