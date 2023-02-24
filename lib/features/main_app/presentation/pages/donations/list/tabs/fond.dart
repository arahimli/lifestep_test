

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/features/main_app/data/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/page_messages/list_message.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/donations/fond.dart';
import 'package:lifestep/features/main_app/presentation/widgets/shimmers/skeleton_list.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/fond/logic/deatil_cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/fond/logic/donors/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/fond/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/list/logic/fond_list_cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/list/logic/fond_state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class FondTabView extends StatefulWidget {
  const FondTabView({Key? key}) : super(key: key);

  @override
  _FondTabViewState createState() => _FondTabViewState();
}

class _FondTabViewState extends State<FondTabView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<FondListCubit, FondListState>(
          listener: (context, state){
            if(state is FondListError && state.errorCode == WEB_SERVICE_ENUM.unAuth){
              Navigator.pushReplacementNamed(context, "/apploading");
            }
          },
          builder: (BuildContext context, state){
            if(state is FondListSuccess || state is FondUpdateListSuccess) {
              List<FondModel> charityList = [];
              bool hasReachedMax = false;
              if(state is FondListSuccess){
                charityList = state.dataList ?? [];
                hasReachedMax = state.hasReachedMax;
              }else if(state is FondUpdateListSuccess){
                charityList = state.dataList ?? [];
                hasReachedMax = state.hasReachedMax;
              }
              if(charityList.isNotEmpty){
                return NotificationListener(
                  onNotification: (t) {
                    //////// print("onNotification: (t)");
                    if (t is ScrollEndNotification) {

                      //////// print("onNotification: (t) end ");
                      //////// print(context.read<FondListCubit>().scrollController.position.pixels);
                      context.read<FondListCubit>().search(null);
                      return true;
                    }else{
                      return false;
                    }
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return RefreshIndicator(
                        onRefresh: ()async{
                          await context.read<FondListCubit>().refresh();
                        },
                        child: ScrollConfiguration(
                          behavior: MainScrollBehavior(),
                          child: SingleChildScrollView(
                              controller: context.read<FondListCubit>().scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight
                                ),
                                child: Column(
                                  children: [
                                    for(int i = 0; i<charityList.length; i++)
                                      _FondWidget(dataItem: charityList[i], dataList: charityList, hasReachedMax: hasReachedMax, index: i,),
                                    if(!hasReachedMax)
                                      const Text("Loading")
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
                  refresh: () {
                    context.read<FondListCubit>().refresh();
                  },
                  text: Utils.getString(context, "general__list__empty_message"),
                );
              }
            }
            else if(state is FondListError){
              return ListErrorMessageWidget(
                errorCode: state.errorCode,
                refresh: () {
                  context.read<FondListCubit>().refresh();
                },
                text: Utils.getString(context, state.errorText),
              );
            }
            else{
              return SkeletonListWidget(
                itemCount: ((size.height - 300)  / (size.width * 0.95 / 6 + 16)).round(),
                child: const FondDonationListItemShimmerWidget(),
              );
            }
          }
      );
  }
}


class _FondWidget extends StatelessWidget {
  final FondModel dataItem;
  final int index;
  final List<FondModel> dataList;
  final bool hasReachedMax;
  const _FondWidget({Key? key, required this.dataItem, required this.dataList, required this.hasReachedMax, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>DonationFondDetailView()));
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MultiBlocProvider(
              providers: [
                BlocProvider<FondDetailsBloc>(create: (context) => FondDetailsBloc(
                    fondModel: dataItem,
                    donationRepository: GetIt.instance<DonationRepository>()
                )),
                BlocProvider<FondDonorListCubit>(create: (context) => FondDonorListCubit(
                    fondModel: dataItem,
                    donationRepository: GetIt.instance<DonationRepository>()
                )),
              ],
              child: const DonationFondDetailView()))).then((value){
                if(value != null ){
                  BlocProvider.of<FondListCubit>(context).changeFond(listValue: dataList, boolValue: hasReachedMax, value: value, index: index);
                }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child:
                  CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(

                        // child:
                        // CircularProgressIndicator(
                        //   valueColor:
                        //   AlwaysStoppedAnimation<Color>(
                        //       Colors.orange),
                        // ),
                        width: size.width * 0.95 / 6,
                        height: size.width * 0.95 / 6,
                        decoration: const BoxDecoration(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        dataItem.name ?? '-',
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: MainColors.middleBlue300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(child: Text("${dataItem.totalSteps != null ? dataItem.totalSteps!.toString().length > 4 ? Utils.humanizeInteger(context, dataItem.totalSteps!) : dataItem.totalSteps! : 0} ${Utils.getString(context, "general__steps__count")}", style: MainStyles.boldTextStyle.copyWith(color: MainColors.white, fontSize: 13),)),
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
