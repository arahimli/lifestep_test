import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/models/step/user-item.dart';

class HomeLiderDataItem extends StatelessWidget {
  final int index;
  final double? borderRadius;
  final UserStepOrderModel userStepOrderModel;
  final bool owner;
  const HomeLiderDataItem({Key? key, required this.index, required this.userStepOrderModel, this.owner : false, this.borderRadius}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: owner ? MainColors.liderboardBackgroundColor : MainColors.backgroundColor,
        // border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
        borderRadius: BorderRadius.circular(borderRadius ?? 1)
      ),
      margin: const EdgeInsets.only(bottom:0),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          padding: EdgeInsets.only(left: owner ? 2 : 12 , right: 6),
          child: Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
              // borderRadius: BorderRadius.circular(borderRadius ?? 1)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.only(
                    // vertical: 12,
                    left: owner ? 16 : 6,
                    right: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: index < 0 ? SizedBox(
                    child: Center(
                      child: Text("${'-'}",
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 12),
                      ),
                    ),
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ): index > 2 ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/images/achievements/prize.png", ),
                          fit: BoxFit.cover
                        )
                    ),
                    child: Center(
                      child: Text("${(index + 1).toString()}",
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 13),
                      ),
                    ),
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ) : Image.asset(
                    "assets/images/achievements/prize${index + 1}.png",
                    width: size.width * 0.6 / 6,
                    height: size.width * 0.6 / 6,
                  ),
                  // child: CachedNetworkImage(
                  //   placeholder: (context, key){
                  //     return Container(
                  //       width: size.width * 0.6 / 6,
                  //       height: size.width * 0.6 / 6,
                  //       decoration: BoxDecoration(
                  //         // color: Colors.blue,
                  //         image: DecorationImage(
                  //           image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                  //           fit: BoxFit.fill,
                  //         ),
                  //         borderRadius:
                  //         BorderRadius.all(
                  //           Radius.circular(500.0),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   // key: Key("${"vvvvv"}${1}"),
                  //   // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                  //   imageUrl: MainConfig.defaultImage,
                  //   width: size.width * 0.6 / 6,
                  //   height: size.width * 0.6 / 6,
                  // )
                ),

                // Container(
                //   clipBehavior: Clip.antiAlias,
                //   margin: const EdgeInsets.symmetric(
                //     // vertical: 12,
                //     horizontal: 6,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(500),
                //   ),
                //   child: Image.asset(userStepOrderModel.genderType == GENDER_TYPE.MAN ? MainConfig.defaultMan : MainConfig.defaultWoman,
                //     width: size.width * 0.6 / 6,
                //     height: size.width * 0.6 / 6,
                //   ),
                //   // child: CachedNetworkImage(
                //   //   placeholder: (context, key){
                //   //     return Container(
                //   //       width: size.width * 0.6 / 6,
                //   //       height: size.width * 0.6 / 6,
                //   //       decoration: BoxDecoration(
                //   //         // color: Colors.blue,
                //   //         image: DecorationImage(
                //   //           image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                //   //           fit: BoxFit.fill,
                //   //         ),
                //   //         borderRadius:
                //   //         BorderRadius.all(
                //   //           Radius.circular(500.0),
                //   //         ),
                //   //       ),
                //   //     );
                //   //   },
                //   //   // key: Key("${"vvvvv"}${1}"),
                //   //   // key: Key("${MainWidgetKey.PRODUCT__IMAGE}${item.id}"),
                //   //   imageUrl: MainConfig.defaultImage,
                //   //   width: size.width * 0.6 / 6,
                //   //   height: size.width * 0.6 / 6,
                //   // )
                // ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                userStepOrderModel.fullName ?? "-",
                                style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        AutoSizeText(
                          "${userStepOrderModel.step != null && userStepOrderModel.step != 0 ? userStepOrderModel.step! : '0'} ${Utils.getString(context, "general__steps__count")}",
                          style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.darkPink500, fontSize: 12, height: 1.1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

