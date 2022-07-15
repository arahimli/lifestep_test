
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/cache_image_key.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/index/banner.dart';
import 'package:lifestep/pages/general/static_page.dart';
import 'package:lifestep/pages/index/logic/main/cubit.dart';
import 'package:lifestep/pages/index/logic/main/state.dart';
import 'package:lifestep/pages/index/logic/navigation_bloc.dart';
import 'package:lifestep/tools/common/utlis.dart';

class CarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //////// print("CarouselWidget");
    return BlocBuilder<IndexCubit,IndexState>(
        builder: (context, state) {
          return state is IndexLoaded && state.indexPageModel.bannerData != null?
          Container(
            child: Column(
              children: [
                Container(
                  height: (MediaQuery.of(context).size.width - 32) / 1.85,
                  child: PageView.builder(
                    // scrollBehavior: ScrollBehavior,
                    controller: PageController(initialPage: 0, keepPage: true, viewportFraction: 0.93),
                    // itemCount: state.indexPageModel.bannerData!.topBanners!.length ,
                    // scrollDirection: Axis.horizontal,
                    itemCount: state.indexPageModel.bannerData!.topBanners!.length ,
                    scrollDirection: Axis.horizontal,
                    // separatorBuilder: (context, ind){
                    //   return SizedBox(width: 8,);
                    // },
                    itemBuilder: (context, ind){
                      BannerModel item = state.indexPageModel.bannerData!.topBanners![ind];
                      double generalWidth = state.indexPageModel.bannerData!.topBanners!.length > 1 ? MediaQuery.of(context).size.width - 48 : MediaQuery.of(context).size.width - 32;
                      return GestureDetector(
                        onTap: (){
                          if(item.linkType == SLIDER_LINK_TYPE.STATIC){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaticPageView(
                                      htmlData: item.text ?? '',
                                      title: item.header ?? '',
                                    )));

                          }else if(item.linkType == SLIDER_LINK_TYPE.LINK){
                            if(item.value != null && item.value != 'null' )
                              Utils.launchUrl(item.value!);
                          }else if(item.linkType == SLIDER_LINK_TYPE.MODULE){
                            // 1-fund,2-charity,3-challenge,4-notification
                            if(item.value == '1'){
                              navigationBloc.changeNavigationIndex(Navigation.DONATIONS);
                            }else if(item.value == '2'){
                              navigationBloc.changeNavigationIndex(Navigation.DONATIONS);
                            }else if(item.value == '3'){
                              navigationBloc.changeNavigationIndex(Navigation.CHALLENGES);
                            }else if(item.value == '4'){
                              Navigator.pushNamed(context, "notification-list");
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: state.indexPageModel.bannerData!.topBanners!.length == (ind + 1) ? 0 : 8),
                          clipBehavior: Clip.antiAlias,
                          width:  generalWidth,
                          height: (generalWidth) / 1.85,
                          decoration: BoxDecoration(
                            // color: Color(0xFFFD5A77),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[

                                  Expanded(
                                    child: Container(
                                      width: generalWidth,
                                      height: double.infinity,
                                      child:
                                      item.image != null || item.imageLocalization != null ? CachedNetworkImage(
                                        placeholder: (context, key){
                                          return Container(
                                            // child:
                                            // CircularProgressIndicator(
                                            //   valueColor:
                                            //   AlwaysStoppedAnimation<
                                            //       Color>(
                                            //       Colors.orange),
                                            // ),
                                            width: MediaQuery.of(context).size.width * 10 / 10 / 2,
                                            height: double.infinity,
                                            padding: EdgeInsets.all(70.0),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/images/general/gray-shimmer.gif", ),
                                                fit: BoxFit.fill,
                                              ),
                                              // color: Colors.blue,
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          );
                                        },
                                        key: Key("${MainWidgetKey.SLIDER_ITEM}${item.id}"),
                                        imageUrl: item.imageLocalization != null ? item.imageLocalization! : item.image != null ? item.image! : MainConfig.defaultImage,
                                        width: size.width * 10 / 10 / 2,
                                        height: double.infinity,
                                        fit: BoxFit.fill,
                                      ):
                                      Image.asset(
                                        "assets/images/api/Banner.png",
                                        width: size.width * 10 / 10 / 2,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // if(item.mainText != null || item.secondText != null  )
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.red.withOpacity(0.3),
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    //   // stops: [0.2, 0.5, 0.7, 1],
                                    //   colors: Iterable<int>.generate(15).toList().map((e) => Colors.black.withOpacity(0.01 * e)).toList(),
                                    // ),
                                  ),
                                  height: double.infinity,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    top: 18,
                                    left: 32,
                                    right: 32,
                                    bottom: 18,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // if(item.header != null)
                                      //   AutoSizeText(
                                      //     item.header!,
                                      //     style: MainStyles.boldTextStyle.copyWith(fontSize: 24, height: 1.3)
                                      //         .copyWith(
                                      //         color: MainColors.white),
                                      //   ),
                                      // Row(
                                      //   children: [
                                      //     SmallBorderedButton(
                                      //       buttonColor: MainColors.white,
                                      //       onTap: (){},
                                      //       borderRadius: 100,
                                      //       text: Utils.getString(context, "home__slider_button_text"),
                                      //       textStyle: MainStyles.boldTextStyle.copyWith(color: MainColors.white, fontSize: 13),
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
//                 CarouselSlider(
//                   items: state.indexPageModel.bannerData!.topBanners!.map((item) =>
//                       GestureDetector(
//                         onTap: (){
//                           if(item.linkType == SLIDER_LINK_TYPE.STATIC){
//
//                           }else if(item.linkType == SLIDER_LINK_TYPE.LINK){
//
//                           }else if(item.linkType == SLIDER_LINK_TYPE.MODULE){
//                             // 1-fund,2-charity,3-challenge,4-notification
//                             if(item.value == '1'){
//                               navigationBloc.changeNavigationIndex(Navigation.DONATIONS);
//                             }else if(item.value == '2'){
//                               navigationBloc.changeNavigationIndex(Navigation.DONATIONS);
//                             }else if(item.value == '3'){
//                               navigationBloc.changeNavigationIndex(Navigation.CHALLENGES);
//                             }else if(item.value == '4'){
//                               Navigator.pushNamed(context, "notification-list");
//                             }
//                           }
//                         },
//                         child: Container(
//                           clipBehavior: Clip.antiAlias,
//                           width: MediaQuery.of(context).size.width - 32,
//                           height:
//                           MediaQuery.of(context).size.width * 3.5 / 10,
//                           decoration: BoxDecoration(
//                             // color: Color(0xFFFD5A77),
//                             borderRadius:
//                             BorderRadius.circular(16),
//                           ),
//                           child: Stack(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//
//                                   Expanded(
//                                     child: Container(
//                                       width: MediaQuery.of(context).size.width - 32,
//                                       height: double.infinity,
//                                       child:
//                                       item.image != null ? CachedNetworkImage(
//                                         placeholder: (context, key){
//                                           return Container(
//                                             // child:
//                                             // CircularProgressIndicator(
//                                             //   valueColor:
//                                             //   AlwaysStoppedAnimation<
//                                             //       Color>(
//                                             //       Colors.orange),
//                                             // ),
//                                             width: MediaQuery.of(context).size.width * 10 / 10 / 2,
//                                             height: double.infinity,
//                                             padding: EdgeInsets.all(70.0),
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image: AssetImage("assets/images/general/gray-shimmer.gif", ),
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               // color: Colors.blue,
//                                               borderRadius:
//                                               BorderRadius.all(
//                                                 Radius.circular(8.0),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         key: Key("${MainWidgetKey.SLIDER_ITEM}${item.id}"),
//                                         imageUrl: item.image ?? MainConfig.defaultImage,
//                                         width: size.width * 10 / 10 / 2,
//                                         height: double.infinity,
//                                         fit: BoxFit.fill,
//                                       ):
//                                       Image.asset(
//                                         "assets/images/api/Banner.png",
//                                         width: size.width * 10 / 10 / 2,
//                                         height: double.infinity,
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // if(item.mainText != null || item.secondText != null  )
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       // color: Colors.red.withOpacity(0.3),
//                                       // gradient: LinearGradient(
//                                       //   begin: Alignment.topCenter,
//                                       //   end: Alignment.bottomCenter,
//                                       //   // stops: [0.2, 0.5, 0.7, 1],
//                                       //   colors: Iterable<int>.generate(15).toList().map((e) => Colors.black.withOpacity(0.01 * e)).toList(),
//                                       // ),
//                                     ),
//                                     height: double.infinity,
//                                     width: double.infinity,
//                                     padding: EdgeInsets.only(
//                                       top: 18,
//                                       left: 32,
//                                       right: 32,
//                                       bottom: 18,
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       // mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         if(item.text != null)
//                                         AutoSizeText(
//                                           item.text!,
//                                           style: MainStyles.boldTextStyle.copyWith(fontSize: 24, height: 1.3)
//                                               .copyWith(
//                                               color: MainColors.white),
//                                         ),
//                                         // Row(
//                                         //   children: [
//                                         //     SmallBorderedButton(
//                                         //       buttonColor: MainColors.white,
//                                         //       onTap: (){},
//                                         //       borderRadius: 100,
//                                         //       text: Utils.getString(context, "home__slider_button_text"),
//                                         //       textStyle: MainStyles.boldTextStyle.copyWith(color: MainColors.white, fontSize: 13),
//                                         //     ),
//                                         //   ],
//                                         // )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ))
//                       .toList(),
//                   // carouselController: model.carouselController,
//                   options: CarouselOptions(
//                     // height: 100,
// //                    autoPlayCurve: Curves.easeOutExpo,
//                       enableInfiniteScroll: true,
//                       viewportFraction: 0.90,
//                       reverse: false,
//                       autoPlay: state.indexPageModel.bannerData!.topBanners!.length > 1,
//                       // autoPlay: homeViewModel.indexViewModel.topSliders.length > 1,
//                       disableCenter: true,
//                       enlargeCenterPage: false,
//                       aspectRatio: 1.85,
//                       onPageChanged: (index, reason) {
//                         // model.carouselIndex = index;
// //                    //////// print(model.carouselIndex);
//                       }),
//                 ),
//                PageView(
//                  children: imageSlider(context),
//                ),
//           SizedBox(
//             height: 36,
//           ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: homeViewModel.indexViewModel.topSliders.asMap().entries.map((entry) {
                //     return GestureDetector(
                //       onTap: () {
                //         //////// print(entry.key);
                //         model.carouselController.animateToPage(entry.key);
                //       },
                //       child: Container(
                //         width: 8.0,
                //         height: 8.0,
                //         margin: EdgeInsets.symmetric(
                //             vertical: 8.0, horizontal: 4.0),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: (Theme.of(context).brightness ==
                //                 Brightness.dark
                //                 ? Colors.white
                //                 : model.carouselIndex == entry.key
                //                 ? MainColors.black
                //                 : Color(0xFFCDD6E0))
                //                 .withOpacity(model.carouselIndex == entry.key
                //                 ? 1
                //                 : 0.8)),
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
          ) : Container();
        }
    );
  }
}