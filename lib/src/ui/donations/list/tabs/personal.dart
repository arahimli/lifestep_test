import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/models/arguments/charity_detail_view.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/countdown/countdown_tag.dart';
import 'package:lifestep/src/tools/components/page_messages/list-message.dart';
import 'package:lifestep/src/tools/components/shimmers/donations/personal.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/src/tools/config/cache_image_key.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/ui/donations/details/personal/logic/deatil_cubit.dart';
import 'package:lifestep/src/ui/donations/details/personal/logic/donors/cubit.dart';
import 'package:lifestep/src/ui/donations/details/personal/view.dart';
import 'package:lifestep/src/ui/donations/list/logic/charity_list_cubit.dart';
import 'package:lifestep/src/ui/donations/list/logic/charity_state.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class PersonalTabView extends StatefulWidget {
  const PersonalTabView({Key? key}) : super(key: key);

  @override
  _PersonalTabViewState createState() => _PersonalTabViewState();
}

class _PersonalTabViewState extends State<PersonalTabView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<CharityListCubit, CharityListState>(
        listener: (context, state){
          if(state is CharityListError && state.errorCode == WEB_SERVICE_ENUM.UN_AUTH){
            Navigator.pushReplacementNamed(context, "/apploading");
          }
        },
        builder: (BuildContext context, state){
          if(state is CharityListSuccess || state is CharityUpdateListSuccess) {
            List<CharityModel> charityList = [];
            bool hasReachedMax = false;
            if(state is CharityListSuccess){
              charityList = state.dataList ?? [];
              hasReachedMax = state.hasReachedMax;
            }else if(state is CharityUpdateListSuccess){
              charityList = state.dataList ?? [];
              hasReachedMax = state.hasReachedMax;
            }
            if(charityList != null && charityList.isNotEmpty){
              return NotificationListener(
                onNotification: (t) {
                  //////// print("onNotification: (t)");
                  if (t is ScrollEndNotification) {

                    //////// print("onNotification: (t) end ");
                    //////// print(context.read<CharityListCubit>().scrollController.position.pixels);
                    context.read<CharityListCubit>().search(null);
                    return true;
                  }else{
                    return false;
                  }
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return RefreshIndicator(
                      onRefresh: ()async{
                        await context.read<CharityListCubit>().refresh();
                      },
                      child: ScrollConfiguration(
                        behavior: MainScrollBehavior(),
                        child: SingleChildScrollView(
                            controller: context.read<CharityListCubit>().scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight
                              ),
                              child: Column(
                                children: [
                                  for(int i = 0; i<charityList.length; i++)
                                    _DataListItem0(dataItem: charityList[i], dataList: charityList, hasReachedMax: hasReachedMax, index: i,),
                                  if(!hasReachedMax)
                                    Container(child: Text("Loading"))
                                ],
                              ),
                            )
                        ),
                      ),
                    );
                  }
                ),
              );
            }else{
              return ListMessageWidget(
                refresh:  () {
                  context.read<CharityListCubit>().refresh();
                },
                text: Utils.getString(context, "general__list__empty_message"),
              );
            }
          }
          else if(state is CharityListError){
            return ListErrorMessageWidget(
              errorCode: state.errorCode,
              refresh: ()  {
                context.read<CharityListCubit>().refresh();
              },
              text: Utils.getString(context, state.errorText),
            );
          }
          else{
            return SkeletonListWidget(
              itemCount: ((size.height - 300)  / (size.width * 0.95 / 6 + 16)).round(),
              child: PersonalDonationListItemShimmerWidget(),
            );
          }

        }
    );
  }
}

class _DataListItem0 extends StatefulWidget {
  final CharityModel dataItem;
  final int index;
  final List<CharityModel> dataList;
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

    endTime = Utils.stringToDate(value: widget.dataItem.endDate ?? '', format : "yyyy-MM-dd").millisecondsSinceEpoch + 1000000 * 87;
    controller = CountdownTimerController(endTime: endTime);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double realPercent = widget.dataItem.requiredSteps == 0 ? 0 : widget.dataItem.presentSteps / widget.dataItem.requiredSteps;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          // Utils.focusClose(context);
          Navigator.pushNamed(
            context,
            CharityDetailView.routeName,
            arguments: CharityDetailViewArguments(
                dataItem: widget.dataItem
            ),
          ).then((value){
            if(value != null && value is CharityModel ){
              BlocProvider.of<CharityListCubit>(context).changeCharity(listValue: widget.dataList, boolValue: widget.hasReachedMax, value: value, index: widget.index);
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

                                // child:
                                // CircularProgressIndicator(
                                //   valueColor:
                                //   AlwaysStoppedAnimation<Color>(
                                //       Colors.orange),
                                // ),
                                // width: size.width * 0.95 / 6,
                                // height: size.width * 0.95 / 6,
                                decoration: BoxDecoration(
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
                          key: Key("${MainWidgetKey.charityItem}${widget.dataItem.id}"),
                          fit: BoxFit.cover,
                          imageUrl: widget.dataItem.image ?? MainConfig.defaultImage,
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

                  if(widget.dataItem.isCompleted())
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
                            color: MainColors.successGreenColor,
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/svgs/general/succesed.svg"),
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

