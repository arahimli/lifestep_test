import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/challenge/inner.dart';
import 'package:lifestep/src/tools/components/error/general-widget.dart';
import 'package:lifestep/src/tools/components/shimmers/donations/donor.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list-no-scrolling.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/ui/challenges/details/logic/step_base_stage/cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/step_base_stage/state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'item.dart';


class StepStageWidget extends StatefulWidget {
  const StepStageWidget({Key? key}) : super(key: key);

  @override
  State<StepStageWidget> createState() => _StepStageWidgetState();
}

class _StepStageWidgetState extends State<StepStageWidget> {

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    return BlocConsumer<StepBaseStageCubit, StepBaseStageState>(
      listener: (context, state){},
      builder: (context, state){

        return state is StepBaseStageSuccess ? Column(
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
                itemBuilder: (context, ind){
                  ChallengeLevelModel item = state.challengeLevels[ind];
                  double generalWidth = state.challengeLevels.length > 1 ? size.width - 48 : size.width - 32;
                  return StepBaseItemWidget(
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
        ) : state is StepBaseStageError ?
        GeneralErrorLoadAgainWidget(
          onTap: (){
            context.read<StepBaseStageCubit>().search();
          },
        )
            : SkeletonNoScrollingListWidget(
          child: DonorListItemShimmerWidget(),
        );
      },
    );
  }
}
