import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/appbar/auth-left.dart';
import 'package:lifestep/tools/components/page-messages/list-message.dart';
import 'package:lifestep/tools/components/shimmers/challenges/challenge-list.dart';
import 'package:lifestep/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/pages/challenges/details/logic/deatil_cubit.dart';
import 'package:lifestep/pages/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/pages/challenges/details/view.dart';
import 'package:lifestep/pages/challenges/list/logic/cubit.dart';
import 'package:lifestep/pages/challenges/list/logic/state.dart';
import 'package:lifestep/pages/challenges/preview_map/logic/cubit.dart';
import 'package:lifestep/pages/index/index/navigation_bloc.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class ChallengeListView extends StatefulWidget {
  const ChallengeListView({Key? key}) : super(key: key);

  @override
  _ChallengeListViewState createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        navigationBloc.changeNavigationIndex(Navigation.HOME);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: MainColors.white,
        body: SafeArea(
          child: Column(
            children: [
              AuthLeftAppBar(title: Utils.getString(context, "challenges_view___title")),
              SizedBox(height: 4,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                        onSubmitted: (value){
                          Utils.focusClose(context);
                          context.read<ChallengeListCubit>().search(value, reset: true);
                        },
                        onSuffixTap: (){
                          context.read<ChallengeListCubit>().search('', reset: true);
                          context.read<ChallengeListCubit>().searchTextController.text = '';
                        },
                        // style: MainStyles.normalTextStyle,
                        // placeholderStyle: MainStyles.grayTextStyle,
                        itemSize: size.height / (836 / 24),
                        itemColor: Color(0xFFC3C5D4),
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
                    //       padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0, ),
                    //       child: SvgPicture.asset("assets/svgs/form/filter.svg"),
                    //     )
                    // )
                  ],
                ),
              ),
              SizedBox(height: 4,),
              Flexible(
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
          if(state is ChallengeListError && state.errorCode == WEB_SERVICE_ENUM.UN_AUTH){
            Navigator.pushReplacementNamed(context, "/apploading");
          }
        },
        builder: (BuildContext context, state){
           if (state is ChallengeListSuccess )
           return state.dataList != null && state.dataList!.length > 0 ? NotificationListener(
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
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: context.read<ChallengeListCubit>().scrollController,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraints.maxHeight
                          ),
                          // padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              for(int i = 0; i<state.dataList!.length; i++)
                                _ChallengeItemWidget(dataItem: state.dataList![i],),
                              if(!state.hasReachedMax)
                                Container(child: Text("Loading"))
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
           );
           else if (state is ChallengeListError )
             return ListErrorMessageWidget(
               errorCode: state.errorCode,
               refresh: () {
                 context.read<ChallengeListCubit>().refresh();
               },
               text: Utils.getString(context, state.errorText),
             );
           else
             return SkeletonListWidget(
                 itemCount: ((size.height - 300)  / (size.width * 0.95 / 6 + 16)).round(),
                 child: ChallengeListItemShimmerWidget(),
               );
        }
    );
  }
}




class _ChallengeItemWidget extends StatelessWidget {
  final ChallengeModel dataItem;
  const _ChallengeItemWidget({Key? key, required this.dataItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MultiBlocProvider(
              providers: [
                BlocProvider<ChallengeDetailBloc>(create: (context) => ChallengeDetailBloc(
                    challengeModel: dataItem,
                    challengeRepository: ChallengeRepository()
                )),
                BlocProvider<ParticipantListCubit>(create: (context) => ParticipantListCubit(
                    challengeModel: dataItem,
                    challengeRepository: ChallengeRepository()
                )),

                BlocProvider<PreviewPolylineMapCubit>(
                    create: (
                        BuildContext context) =>
                        PreviewPolylineMapCubit(
                          challengeRepository: ChallengeRepository(),
                          challengeModel: dataItem,
                        )),
              ],
              child: ChallengeDetailView())));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(
                        width: size.width * 0.95 / 6,
                        height: size.width * 0.95 / 6,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          image: DecorationImage(
                            image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                          BorderRadius.all(
                            Radius.circular(500.0),
                          ),
                        ),
                      );
                    },
                    // key: Key("${"vvvvv"}${1}"),
                    // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                    fit: BoxFit.cover,
                    imageUrl: dataItem.image ?? MainConfig.defaultImage,
                    width: size.width * 0.95 / 6,
                    height: size.width * 0.95 / 6,
                  )),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataItem.name ?? '-',
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        dataItem.description ?? '-',
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 14, color: MainColors.middleGrey400),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),

                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                decoration: BoxDecoration(
                                  color: MainColors.middleBlue300,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(child: Text("${sprintf(Utils.getString(context, "challenges_view___distance_pattern"), [dataItem.distance ?? 0])}", style: MainStyles.boldTextStyle.copyWith(color: MainColors.white, fontSize: 13,),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              )
                          ),
                          SizedBox(width: 4),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                decoration: BoxDecoration(
                                  color: MainColors.middleBlue300,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(child: Text("${sprintf(Utils.getString(context, "challenges_view___date_pattern"), [dataItem.endDate != null ? Utils.stringToDatetoString(value: dataItem.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-'])}", style: MainStyles.boldTextStyle.copyWith(color: MainColors.white, fontSize: 13),)),
                              )
                          ),
                        ],
                      )
                    ],
                  ),
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