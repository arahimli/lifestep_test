import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/page-messages/list-message.dart';
import 'package:lifestep/tools/components/shimmers/donations/personal.dart';
import 'package:lifestep/tools/components/shimmers/skeleton-list.dart';
import 'package:lifestep/config/main_colors.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/config/scroll_behavior.dart';
import 'package:lifestep/config/styles.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/pages/donations/details/personal/logic/deatil_cubit.dart';
import 'package:lifestep/pages/donations/details/personal/logic/donors/cubit.dart';
import 'package:lifestep/pages/donations/details/personal/view.dart';
import 'package:lifestep/pages/donations/list/logic/charity_list_cubit.dart';
import 'package:lifestep/pages/donations/list/logic/charity_state.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
            if(charityList != null && charityList.length > 0){
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
                            physics: AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight
                              ),
                              child: Column(
                                children: [
                                  for(int i = 0; i<charityList.length; i++)
                                    _PersonalWidget(dataItem: charityList[i], dataList: charityList, hasReachedMax: hasReachedMax, index: i,),
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

class _PersonalWidget extends StatelessWidget {
  final CharityModel dataItem;
  final int index;
  final List<CharityModel> dataList;
  final bool hasReachedMax;
  const _PersonalWidget({Key? key, required this.dataItem, required this.dataList, required this.hasReachedMax, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double realPercent = dataItem.requiredSteps == 0 ? 0 : dataItem.presentSteps / dataItem.requiredSteps;
    return Container(
      margin: EdgeInsets.only(bottom:0),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: GestureDetector(
        onTap: () async{
          // Utils.focusClose(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MultiBlocProvider(
              providers: [
                BlocProvider<CharityDetailsBloc>(create: (context) => CharityDetailsBloc(
                    charityModel: dataItem,
                    donationRepository: DonationRepository()
                )),
                BlocProvider<DonorListCubit>(create: (context) => DonorListCubit(
                    charityModel: dataItem,
                    donationRepository: DonationRepository()
                )),
              ],
              child: DonationPersonalDetailView()))).then((value){
                if(value != null ){
                  BlocProvider.of<CharityListCubit>(context).changeCharity(listValue: dataList, boolValue: hasReachedMax, value: value, index: index);
                }
          });
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

                        // child:
                        // CircularProgressIndicator(
                        //   valueColor:
                        //   AlwaysStoppedAnimation<Color>(
                        //       Colors.orange),
                        // ),
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
                      SizedBox(height: 8),
                      Text(
                        dataItem.name ?? '-',
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${dataItem.presentSteps} ${Utils.getString(context, "general__steps__count")}",
                        style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 12, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: dataItem.requiredSteps == 0 ? 0 : dataItem.presentSteps / dataItem.requiredSteps > 1 ? 1 : dataItem.presentSteps / dataItem.requiredSteps,
                        trailing: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("${realPercent > 0.999 && realPercent < 1 ? '99.9' : Utils.roundNumber((realPercent) * 100, toPoint: 1)}%", style: MainStyles.boldTextStyle.copyWith(color: MainColors.middleBlue300, fontSize:  12, ),),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        progressColor: MainColors.middleBlue300,
                        backgroundColor: MainColors.middleGrey100,
                      ),
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

