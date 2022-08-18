import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/tools/components/error/general-widget.dart';
import 'package:lifestep/src/tools/components/shimmers/home-charity/donation-grid-item.dart';
import 'package:lifestep/src/tools/components/shimmers/home-charity/home-charity-grid.dart';
import 'package:lifestep/src/tools/config/cache_image_key.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';
import 'package:lifestep/src/ui/donations/details/personal/logic/deatil_cubit.dart';
import 'package:lifestep/src/ui/donations/details/personal/logic/donors/cubit.dart';
import 'package:lifestep/src/ui/donations/details/personal/view.dart';
import 'package:lifestep/src/ui/index/logic/charity/cubit.dart';
import 'package:lifestep/src/ui/index/logic/charity/state.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/donation/cubit.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/step/cubit.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeCharityListWidget extends StatefulWidget {
  const HomeCharityListWidget({Key? key}) : super(key: key);

  @override
  State<HomeCharityListWidget> createState() => _HomeCharityListWidgetState();
}

class _HomeCharityListWidgetState extends State<HomeCharityListWidget> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeCharityListCubit, HomeCharityListState>(
        builder: (context, state) {
          if(state is HomeCharityListSuccess || state is CharityUpdateListSuccess) {
            List<CharityModel> charityList = [];
            if(state is HomeCharityListSuccess){
              charityList = state.dataList ?? [];
            }else if(state is CharityUpdateListSuccess){
              charityList = state.dataList ?? [];
            }
            return charityList.isNotEmpty ?
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.width * 1.1 / 6 + 36,
                      child: PageView.builder(
                        // scrollBehavior: ScrollBehavior,
                        controller: PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93),
                        // itemCount: charityList!.length ,
                        // scrollDirection: Axis.horizontal,
                        itemCount: charityList.length ,
                        scrollDirection: Axis.horizontal,
                        // separatorBuilder: (context, ind){
                        //   return SizedBox(width: 8,);
                        // },
                        itemBuilder: (context, ind){
                          CharityModel item = charityList[ind];
                          double generalWidth = charityList.length > 1 ? MediaQuery.of(context).size.width - 48 : MediaQuery.of(context).size.width - 32;
                          return _DonationWidget(
                            index: ind,
                            dataList: charityList,
                            isLast: (charityList.length - 1) <= ind ,
                            dataItem: item,
                            generalWidth: generalWidth,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ):
              Container();
          }
          else if(state is HomeCharityListError){
            return Padding(
              padding: PagePadding.leftRight16(),
              child: GeneralErrorLoadAgainWidget(
                onTap: (){
                  context.read<HomeCharityListCubit>().refresh();
                },
              ),
            );
          }
          else{
            return HomeSkeletonGridViewWidget(
              itemCount: 2,
              child: ChairtyListItemShimmerWidget(),
            );
          }
        }
    );
  }
}



class _DonationWidget extends StatelessWidget {
  final CharityModel dataItem;
  final List<CharityModel> dataList;
  final int index;
  final bool isLast;
  final double generalWidth;
  const _DonationWidget({Key? key, required this.dataItem, required this.index, required this.generalWidth, required this.isLast, required this.dataList }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 1.1 / 6 + 4;
    double realPercent = (dataItem.requiredSteps == 0 ? 0 : dataItem.presentSteps / dataItem.requiredSteps);
    double resultPercent = Utils.roundNumber((dataItem.requiredSteps == 0 ? 0 : dataItem.presentSteps / dataItem.requiredSteps > 1 ? 1 : dataItem.presentSteps / dataItem.requiredSteps));
    String textPercent = "${realPercent > 0.999 && realPercent < 1 ? '99.9' : Utils.roundNumber((realPercent) * 100, toPoint: 1)}%";
    return Container(
      width: generalWidth,
      margin: EdgeInsets.only(right: !isLast ? 8 : 0),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> MultiBlocProvider(
              providers: [
                BlocProvider<CharityDetailsBloc>(create: (context) => CharityDetailsBloc(
                    charityModel: dataItem,
                    donationRepository: GetIt.instance<DonationRepository>()
                )),
                BlocProvider<DonorListCubit>(create: (context) => DonorListCubit(
                    charityModel: dataItem,
                    donationRepository: GetIt.instance<DonationRepository>()
                )),
              ],
              child: DonationPersonalDetailView()))).then((value){
            if(value != null ){
              BlocProvider.of<HomeLeaderBoardDonationCubit>(context).refresh();
              BlocProvider.of<HomeLeaderBoardStepCubit>(context).refresh();
              BlocProvider.of<HomeCharityListCubit>(context).changeCharity(listValue: dataList, value: value, index: index);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16, ),
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
                  padding: const EdgeInsets.symmetric(
                    // vertical: 12,
                    // horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, key){
                      return Container(
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
                    // key: Key("${"vvvvv"}${1}"),
                    // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                    key: Key("${MainWidgetKey.charityItem}${dataItem.id}"),
                    fit: BoxFit.cover,
                    imageUrl: dataItem.image ?? MainConfig.defaultImage,
                    width: imageSize,
                    height: imageSize,
                  )
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    // vertical: 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataItem.name ?? '',
                        style: MainStyles.extraBoldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "${Utils.humanizeInteger(context, dataItem.presentSteps)}/",
                                style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 12, height: 1.1),
                                children: <TextSpan>[
                                    TextSpan(
                                      text:
                                      "${Utils.humanizeInteger(context, dataItem.requiredSteps)} ",
                                      style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 12, height: 1.1),
                                    ),
                                    TextSpan(
                                      text:
                                      Utils.getString(context, "home__charity_list_subtitle"),
                                      style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 12, height: 1.1),
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
                      const SizedBox(height: 4),
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