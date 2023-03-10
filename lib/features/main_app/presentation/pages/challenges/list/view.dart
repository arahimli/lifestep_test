import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/features/main_app/data/models/arguments/challenge_detail_view.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/appbar/auth_left.dart';
import 'package:lifestep/features/main_app/presentation/widgets/countdown/countdown_tag.dart';
import 'package:lifestep/features/main_app/presentation/widgets/page_messages/list_message.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/challenges/challenge_list.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton_list.dart';
import 'package:lifestep/features/tools/config/cache_image_key.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/list/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/list/logic/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/navigation_bloc.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:async/async.dart';

class ChallengeListView extends StatefulWidget {
  const ChallengeListView({Key? key}) : super(key: key);

  @override
  _ChallengeListViewState createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView> {


  late CancelableOperation<void> cancellableOperation;
  final _delayTime = const Duration(milliseconds: 700);
  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    cancellableOperation = CancelableOperation.fromFuture(
      Future.delayed(_delayTime),
      onCancel: () {
        log("cancelled...");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        navigationBloc.changeNavigationIndex(Navigation.home);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: MainColors.white,
        body: SafeArea(
          child: Column(
            children: [
              AuthLeftAppBar(title: Utils.getString(context, "challenges_view___title")),
              const SizedBox(height: 4,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoSearchTextField(
                        controller: context.read<ChallengeListCubit>().searchTextController,
                        // backgroundColor: MainColors.backgroundColor,
                        decoration: BoxDecoration(
                          color: MainColors.backgroundColor,
                          // border: Border.all(
                          //   color: Color(0xFFE2E6EE),
                          //   width: 1,
                          // ),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        // onChanged: _onItemChanged,
                        onSubmitted: (value){
                          Utils.focusClose(context);
                          context.read<ChallengeListCubit>().search(value, reset: true);
                        },
                        onChanged: (value){
                          cancellableOperation.cancel();
                          _start();
                          cancellableOperation.value.whenComplete(() {
                            context.read<ChallengeListCubit>().search(value, reset: true);
                            Utils.focusClose(context);
                          });
                        },
                        onSuffixTap: (){
                          context.read<ChallengeListCubit>().search('', reset: true);
                          context.read<ChallengeListCubit>().searchTextController.text = '';
                        },
                        // style: MainStyles.normalTextStyle,
                        // placeholderStyle: MainStyles.grayTextStyle,
                        itemSize: size.height / (836 / 24),
                        itemColor: const Color(0xFFC3C5D4),
                        placeholder: Utils.getString(context, "page_donation_list___search_hint"),
                        placeholderStyle: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.generalCupertinoSearchPlaceholder),
                        padding: EdgeInsets.symmetric(vertical: size.height / (836 / 16), horizontal: size.width / (375 / 16)),
                        prefixInsets: EdgeInsets.only(left: size.width / (375 / 16)),
                        suffixInsets: EdgeInsets.only(right: size.width / (375 / 16)),
                        suffixMode: OverlayVisibilityMode.editing,
                        prefixIcon: SvgPicture.asset("assets/svgs/general/search.svg"),
                      ),
                    ),
                    // MaterialInkWell(
                    //     color: MainColors.white,
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0, ),
                    //       child: SvgPicture.asset("assets/svgs/form/filter.svg"),
                    //     )
                    // )
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              const Flexible(
                flex: 1,
                child: _DataListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class _DataListWidget extends StatefulWidget {
  const _DataListWidget({Key? key}) : super(key: key);

  @override
  _DataListWidgetState createState() => _DataListWidgetState();
}

class _DataListWidgetState extends State<_DataListWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<ChallengeListCubit, ChallengeListState>(
        listener: (context, state){
          if(state is ChallengeListError && state.errorCode == WEB_SERVICE_ENUM.unAuth){
            Navigator.pushReplacementNamed(context, "/apploading");
          }
        },
        builder: (BuildContext context, state){
           if (state is ChallengeListSuccess ){
           return state.dataList != null && state.dataList!.isNotEmpty ? NotificationListener(
            onNotification: (t) {
              //////// print("onNotification: (t)");
              if (t is ScrollEndNotification) {

                //////// print("onNotification: (t) end ");
                //////// print(context.read<ChallengeListCubit>().scrollController.position.pixels);
                context.read<ChallengeListCubit>().search(null);
                return true;
              }else{
                return false;
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return RefreshIndicator(
                  onRefresh: ()async{
                    await context.read<ChallengeListCubit>().refresh();
                  },
                  child: ScrollConfiguration(
                    behavior: MainScrollBehavior(),
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: context.read<ChallengeListCubit>().scrollController,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraints.maxHeight
                          ),
                          // padding: const PagePadding.leftRight16(),
                          child: Column(
                            children: [
                                ...state.dataList!.asMap().entries.map((e) => _DataListItem0(
                                  dataItem: e.value,
                                  dataList: state.dataList!,
                                  index: e.key,
                                  hasReachedMax: state.hasReachedMax,
                                )),
                              if(!state.hasReachedMax)
                                const Text("Loading")
                            ],
                          ),
                        )
                    ),
                  ),
                );
              }
            ),
          ) : ListMessageWidget(
             refresh: () {
               context.read<ChallengeListCubit>().refresh();
             },
              text: Utils.getString(context, "general__list__empty_message"),
           );}
           else if (state is ChallengeListError ) {
             return ListErrorMessageWidget(
               errorCode: state.errorCode,
               refresh: () {
                 context.read<ChallengeListCubit>().refresh();
               },
               text: Utils.getString(context, state.errorText),
             );
           }
           else {
             return SkeletonListWidget(
               itemCount: ((size.height - 300) / (size.width * 0.95 / 6 + 16))
                   .round(),
               child: const ChallengeListItemShimmerWidget(),
             );
           }
        }
    );
  }
}




class _DataListItem0 extends StatefulWidget {
  final ChallengeModel dataItem;
  final int index;
  final List<ChallengeModel> dataList;
  final bool hasReachedMax;
  const _DataListItem0({Key? key, required this.dataItem, required this.dataList, required this.hasReachedMax, required this.index}) : super(key: key);


  @override
  State<_DataListItem0> createState() => _DataListItem0State();
}

class _DataListItem0State extends State<_DataListItem0> {
  late CountdownTimerController controller;
  late int endTime;

  @override
  void initState() {
    super.initState();

    endTime = Utils.stringToDate(value: widget.dataItem.endDate ?? '', format : "yyyy-MM-dd").millisecondsSinceEpoch + 864 * 100000;
    controller = CountdownTimerController(endTime: endTime);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          await
          Navigator.pushNamed(
            context,
            ChallengeDetailView.routeName,
            arguments: ChallengeDetailViewArguments(
              dataItem: widget.dataItem
            ),
          ).then((value){
            if(value != null && value is ChallengeModel ){
              BlocProvider.of<ChallengeListCubit>(context).changeChallenge(listValue: widget.dataList, boolValue: widget.hasReachedMax, value: value, index: widget.index);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Stack(
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.symmetric(
                        // vertical: 12,
                        // horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AspectRatio(
                        aspectRatio: 343 / 200,
                        child: CachedNetworkImage(
                          placeholder: (context, key){
                            return AspectRatio(
                              aspectRatio: 343 / 200,
                              child: Container(
                                decoration: const BoxDecoration(
                                  // color: Colors.blue,
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                ),
                              ),
                            );
                          },
                          key: Key("${MainWidgetKey.challengeItem}${widget.dataItem.id}"),
                          fit: BoxFit.cover,
                          imageUrl: widget.dataItem.getImage(),
                          height: double.infinity,
                          width: double.infinity,

                        ),
                      )
                  ),

                  Positioned(
                    bottom: 16,
                    left: 16,
                    // width: 300,
                    // right: 0,
                    child: CountdownTagWidget(controller: controller,),
                  ),

                  if(widget.dataItem.isJoined!)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      // width: 300,
                      // right: 0,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: BackdropFilter(
                            filter: ImageFilter.compose(
                                inner: ImageFilter.blur(
                                  sigmaX: 50,
                                  sigmaY: 0,
                                  // tileMode: TileMode.decal
                                ),
                                outer: ImageFilter.blur(
                                  sigmaX: -double.infinity / 2,
                                  sigmaY: 20,
                                  // tileMode: TileMode.decal
                                )
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10, ),
                              color: widget.dataItem.isCompleted! ? MainColors.successGreenColor : widget.dataItem.isJoined! ? MainColors.darkPink500 : MainColors.transparent,
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/svgs/general/${widget.dataItem.isCompleted! ? "succesed" : widget.dataItem.isJoined! ? 'active-challenge' : 'succesed'}.svg", color: Colors.white,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.dataItem.name ?? '-',
                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Text(
                    //   "${widget.dataItem.presentSteps} ${Utils.getString(context, "general__steps__count")}",
                    //   style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 12, height: 1.1),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // SizedBox(height: 8),
                    // LinearPercentIndicator(
                    //   lineHeight: 8.0,
                    //   percent: widget.dataItem.requiredSteps == 0 ? 0 : widget.dataItem.presentSteps / widget.dataItem.requiredSteps > 1 ? 1 : widget.dataItem.presentSteps / widget.dataItem.requiredSteps,
                    //   trailing: Padding(
                    //     padding: const EdgeInsets.only(left: 8.0),
                    //     child: Text("${realPercent > 0.999 && realPercent < 1 ? '99.9' : Utils.roundNumber((realPercent) * 100, toPoint: 1)}%", style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleBlue300, fontSize:  12, ),),
                    //   ),
                    //   padding: const EdgeInsets.symmetric(horizontal: 4),
                    //   progressColor: MainColors.middleBlue300,
                    //   backgroundColor: MainColors.middleGrey100,
                    // ),
                  ],
                ),
              ),

              // SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.black,)
            ],
          ),
        ),
      ),
    );
  }
}