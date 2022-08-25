import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/page_messages/list-message.dart';
import 'package:lifestep/src/tools/components/shimmers/achievement_list_item.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-grid.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/models/general/achievement_list.dart';
import 'package:lifestep/src/ui/user/profile/achievement/cubit.dart';
import 'package:lifestep/src/ui/user/profile/achievement/state.dart';
import 'package:shimmer/shimmer.dart';

class AchievementListWidget extends StatefulWidget {
  const AchievementListWidget({Key? key}) : super(key: key);

  @override
  AchievementListWidgetState createState() => AchievementListWidgetState();
}

class AchievementListWidgetState extends State<AchievementListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementListCubit, AchievementListState>(
      builder: (context, state) {
        if(state is AchievementListSuccess) {
          return RefreshIndicator(
            onRefresh: ()async{
              await context.read<AchievementListCubit>().refresh();
            },
            child: GridView.builder(
              itemCount: state.userDataList.length + state.getUniqueList().length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 0.601,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index){
                if(index < state.userDataList.length ) {
                  UserAchievementModel dataItem = state.userDataList[index];
                  return _AchievementItemWidget(
                    iconAddress: dataItem.imageUnlocked ?? MainConfig.defaultImage,
                    backgroundColor: MainColors.darkBlue500!,
                    titleText: dataItem.name ?? '',
                    title: AutoSizeText(
                      dataItem.name ?? '',
                      // Utils.getString(context, "${dataItem.name}"),
                      style: MainStyles.boldTextStyle.copyWith(height: 1.2,
                          fontSize: 16,
                          color: MainColors.middleGrey900),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    descriptionText: dataItem.description ?? '',
                    subTitle: Text(
                      dataItem.description ?? '',
                      // Utils.getString(context, "${dataItem.description}"),
                      style: MainStyles.boldTextStyle.copyWith(height: 1.12,
                          fontSize: 12,
                          color: MainColors.middleGrey600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }else {
                  int newIndex = index - state.userDataList.length;
                  AchievementModel dataItem = state.getUniqueList()[newIndex];
                  return _AchievementItemWidget(
                    iconAddress: dataItem.lockImage ?? MainConfig.defaultImage,
                    backgroundColor: MainColors.darkBlue500!,
                    titleText: dataItem.name ?? '',
                    title: AutoSizeText(
                      dataItem.name ?? '',
                      // Utils.getString(context, "${dataItem.name}"),
                      style: MainStyles.boldTextStyle.copyWith(height: 1.2,
                          fontSize: 16,
                          color: MainColors.middleGrey900),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    descriptionText: dataItem.description ?? '',
                    subTitle: Text(
                      dataItem.description ?? '',
                      // Utils.getString(context, "${dataItem.description}"),
                      style: MainStyles.boldTextStyle.copyWith(height: 1.2,
                          fontSize: 12,
                          color: MainColors.middleGrey600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                    ),
                  );
                }
              },
        ),
          );
        } else if(state is AchievementListError)
          return ListErrorMessageWidget(
            errorCode: state.errorCode,
            refresh: () {
              context.read<AchievementListCubit>().refresh();
            },
            text: Utils.getString(context, state.errorText),
          );
        else
          return SkeletonGridViewWidget(
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            child: AchievementListItemShimmerWidget(),
          );
      }
    );
  }
}

class _AchievementItemWidget extends StatelessWidget {
  final String iconAddress;
  final Color backgroundColor;
  final Widget title;
  final String titleText;
  final String descriptionText;
  final Widget subTitle;
  const _AchievementItemWidget({Key? key, required this.iconAddress, required this.backgroundColor,  required this.title,  required this.subTitle, required this.titleText, required this.descriptionText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async{
        Utils.focusClose(context);;
        Utils.showInfoByImageModal(context, size, title: titleText, text: descriptionText, buttonText: Utils.getString(context, "general__close_button_text"), imageText: iconAddress, onTap: (ctx){Navigator.pop(ctx);});
      },
      child: Container(
        decoration: BoxDecoration(
          color: MainColors.white,
          borderRadius: BorderRadius.circular(24)
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              // padding: const EdgeInsets.symmetric(
              //   horizontal: size.width * 1 / 12,
              // ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CachedNetworkImage(
                    placeholder: (context, key){
                      return Shimmer.fromColors(
                          highlightColor: MainColors.middleGrey150!.withOpacity(0.2),
                          baseColor: MainColors.middleGrey150!,
                          child: Image.asset("assets/images/achievements/prize.png", color: MainColors.middleGrey150,)
                      );
                    },
                    // key: Key("${"vvvvv"}${1}"),
                    // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                    fit: BoxFit.cover,
                    imageUrl: iconAddress,
                    // width: size.width * 0.95 / 6,
                    // height: size.width * 0.95 / 6,
                  ),
                )
                // SvgPicture.asset(iconAddress)
                // child: Image.asset(iconAddress)
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  title,
                  const SizedBox(height: 4),
                  // subTitle,
                  // const SizedBox(height: 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
