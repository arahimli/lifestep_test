
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/tools/config/cache_image_key.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/ui/challenges/details/logic/deatil_cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/step_base_stage/cubit.dart';
import 'package:lifestep/src/ui/challenges/details/view.dart';
import 'package:lifestep/src/ui/challenges/preview_map/logic/cubit.dart';
import 'package:lifestep/src/ui/index/logic/main/cubit.dart';
import 'package:lifestep/src/ui/index/logic/main/state.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:sprintf/sprintf.dart';

class HomeChallengeWidget extends StatefulWidget {
  const HomeChallengeWidget({Key? key}) : super(key: key);

  @override
  State<HomeChallengeWidget> createState() => _HomeChallengeWidgetState();
}

class _HomeChallengeWidgetState extends State<HomeChallengeWidget> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //////// print("HomeChallengeWidget");
    return BlocBuilder<IndexCubit,IndexState>(
        builder: (context, state) {
          return state is IndexLoaded && state.indexPageModel.bannerData != null?
          Column(
            children: [
              SizedBox(
                height: size.width * 1.1 / 6 + 36,
                child: PageView.builder(
                  // scrollBehavior: ScrollBehavior,
                  controller: PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93),
                  // itemCount: state.indexPageModel.challengeList!.length ,
                  // scrollDirection: Axis.horizontal,
                  itemCount: state.indexPageModel.challengeList.length ,
                  scrollDirection: Axis.horizontal,
                  // separatorBuilder: (context, ind){
                  //   return SizedBox(width: 8,);
                  // },
                  itemBuilder: (context, ind){
                    ChallengeModel item = state.indexPageModel.challengeList[ind];
                    double generalWidth = state.indexPageModel.challengeList.length > 1 ? MediaQuery.of(context).size.width - 48 : MediaQuery.of(context).size.width - 32;
                    return _ChallengeWidget(
                      index: ind,
                      isLast: (state.indexPageModel.challengeList.length - 1) <= ind ,
                      dataItem: item,
                      generalWidth: generalWidth,
                    );
                  },
                ),
              ),
            ],
          ) : Container();
        }
    );
  }
}



class _ChallengeWidget extends StatelessWidget {
  final ChallengeModel dataItem;
  final int index;
  final bool isLast;
  final double generalWidth;
  const _ChallengeWidget({Key? key, required this.dataItem, required this.index, required this.generalWidth, required this.isLast }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 1.1 / 6 + 4;
    return Container(
      width: generalWidth,
      margin: EdgeInsets.only(right: !isLast ? 8 : 0),
      child: GestureDetector(
        onTap: () async{
          Utils.focusClose(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MultiBlocProvider(
              providers: [
                BlocProvider<ChallengeDetailBloc>(create: (context) => ChallengeDetailBloc(
                    challengeModel: dataItem,
                    challengeRepository: GetIt.instance<ChallengeRepository>()
                )),
                BlocProvider<ParticipantListCubit>(create: (context) => ParticipantListCubit(
                    challengeModel: dataItem,
                    challengeRepository: GetIt.instance<ChallengeRepository>()
                )),
                BlocProvider<StepBaseStageCubit>(create: (context) => StepBaseStageCubit(
                    challengeModel: dataItem,
                    challengeRepository: GetIt.instance<ChallengeRepository>()
                )),

                BlocProvider<PreviewPolylineMapCubit>(
                    create: (
                        BuildContext context) =>
                        PreviewPolylineMapCubit(
                          challengeRepository: GetIt.instance<ChallengeRepository>(),
                          challengeModel: dataItem,
                        )),
              ],
              child: const ChallengeDetailView())));

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
                    imageUrl: dataItem.image ?? MainConfig.defaultImage,
                    width: imageSize,
                    height: imageSize,
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
                      AutoSizeText(
                        dataItem.name ?? '',
                        style: MainStyles.extraBoldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        sprintf(Utils.getString(context, "challenges_view___date_pattern"), [dataItem.endDate != null ? Utils.stringToDatetoString(value: dataItem.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-']),
                        style: MainStyles.boldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 14, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              SvgPicture.asset("assets/svgs/general/navigate-right.svg", color: MainColors.black,)
            ],
          ),
        ),
      ),
    );
  }
}