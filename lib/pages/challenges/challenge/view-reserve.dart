// import 'dart:math';
//
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lifestep/tools/common/utlis.dart';
// import 'package:lifestep/tools/components/dialog/loading.dart';
// import 'package:lifestep/tools/components/dialog/yesno.dart';
// import 'package:lifestep/config/main_colors.dart';
// import 'package:lifestep/config/main_config.dart';
// import 'package:lifestep/config/styles.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/address/logic.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/bottom/cubit.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/bottom/state.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/main/cubit.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/main/state.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/step/cubit.dart';
// import 'package:lifestep/pages/challenges/challenge/logic/step/state.dart';
// import 'package:lifestep/pages/challenges/details_demo/demo2/location.helper.dart';
// import 'package:lifestep/repositories/service/web_service.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'dart:async';
//
// import 'package:pedometer/pedometer.dart';
//
// import 'logic/address/state.dart';
//
//
// class ChallengeView extends StatefulWidget {
//   const ChallengeView({Key? key}) : super(key: key);
//
//   @override
//   _ChallengeViewState createState() => _ChallengeViewState();
// }
//
// class _ChallengeViewState extends State<ChallengeView> {
//   late MapboxMapController mapboxMapController;
//   @override
//   void initState() {
//     // mapboxMapController = MapboxMapController(
//     //   mapboxGlPlatform: MapboxGlPlatform
//     // );
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // final String token = MainConfig.mapBoxAccessToken;
//     // final String style = 'mapbox://styles/digitalks22/ckzpb1qai000r14n8y7u9k6sy';
//     Size size = MediaQuery.of(context).size;
//     BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);
//
//     return WillPopScope(
//       onWillPop: () async{
//         showYesNoDialog(context, Utils.getString(context, "challenges_details_view___cancel_dialog"),() async{
//           closeLoading(context);
//           showLoading(context, Utils.getString(context, "general__loading_text"));
//           List listData = await context.read<MainMapChallengeCubit>().cancelChallenge();
//
//           if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
//             context.read<AddressInfoCubit>().dispose();
//             closeLoading(context);
//             Navigator.pop(context);
//             Utils.showSuccessModal(context, size, title: Utils.getString(context, "challenges_details_view___cancel_dialog_success_message"));
//           }
//           else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
//             closeLoading(context);
//             Utils.showErrorModal(context, size, title: Utils.getString(context, "error_went_wrong"));
//           } else {
//             closeLoading(context);
//             Utils.showErrorModal(context, size, title: Utils.getString(context, "challenges_details_view___cancel_dialog_error_message"));
//           }
//
//           return Future.value(true);
//         }, () {
//           // shouldClose = false;
//           Navigator.of(context).pop();
//           return Future.value(false);
//         });
//
//         return Future.value(false);
//       },
//       child: Scaffold(
//         body: BlocBuilder<MainMapChallengeCubit, MainMapChallengeState>(
//             builder: (context, mainMapChallengeState) {
//               return Stack(
//                 children: [
//
//                   Column(
//                     children: [
//                       Expanded(
//                         child: MapboxMap(
//                             accessToken: MainConfig.mapBoxAccessToken,
//                             styleString: context.read<MainMapChallengeCubit>().challengeModel.styleUrl,
//                             zoomGesturesEnabled: true,
//                             tiltGesturesEnabled: true,
//                             trackCameraPosition: true,
//                             myLocationEnabled: true,
//                             myLocationRenderMode: MyLocationRenderMode.COMPASS,
//                             // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
//                             onUserLocationUpdated: (UserLocation location){
//                               //////// print("onUserLocationUpdated____________________________________________");
//                               //////// print(location.position.latitude);
//                               //////// print(location.position.longitude);
//                               context.read<AddressInfoCubit>().getAddressInfoTimer(LatLng(location.position.latitude, location.position.longitude));
//                             },
//
//                             initialCameraPosition: CameraPosition(
//                               zoom: 12.0,
//                               target: computeCentroid([LatLng(40.377251,49.8425757), LatLng(40.3508735,49.8410668)]),
//                             ),
//
//                             // The onMapCreated callback should be used for everything related
//                             // to updating map components via the MapboxMapController instance
//                             onMapCreated: (MapboxMapController controller) async{
//                               // Acquire current location (returns the LatLng instance)
//                               final result = await acquireCurrentLocation();
//                               mapboxMapController = controller;
//                               // context.read<MainMapChallengeCubit>().addressInfo = context.read<MainMapChallengeCubit>().getAddressInfo(result);
//                               context.read<AddressInfoCubit>().getAddressInfo(result);
//
//                               // You can either use the moveCamera or animateCamera, but the former
//                               // causes a sudden movement from the initial to 'new' camera position,
//                               // while animateCamera gives a smooth animated transition
//                               await controller.animateCamera(
//                                 CameraUpdate.newLatLng(computeCentroid([LatLng(40.377251,49.8425757), LatLng(40.3508735,49.8410668)])),
//                               );
//                               // List dataMapFitToTour = _setMapFitToTour(LatLng(40.377251,49.8425757), LatLng(40.3508735,49.8410668), );
//                               // controller.animateCamera(CameraUpdate.newLatLngBounds(LatLngBounds(
//                               //     southwest: LatLng(dataMapFitToTour[0], dataMapFitToTour[1]),
//                               //     northeast: LatLng(dataMapFitToTour[2],dataMapFitToTour[3])
//                               // )));
//
//                               // Add a circle denoting current user location
//                               await controller.addCircle(
//                                 CircleOptions(
//                                   circleRadius: 8.0,
//                                   circleColor: '#006992',
//                                   circleOpacity: 0.8,
//
//                                   // YOU NEED TO PROVIDE THIS FIELD!!!
//                                   // Otherwise, you'll get a silent exception somewhere in the stack
//                                   // trace, but the parameter is never marked as @required, so you'll
//                                   // never know unless you check the stack trace
//                                   geometry: result,
//                                   draggable: false,
//                                 ),
//                               );
//                             }
//                         ),
//                       ),
//                       BlocBuilder<BottomSectionCubit, BottomSectionState>(
//                           builder: (context, bottomState) {
//                             return AnimatedContainer(
//                               // Use the properties stored in the State class.
//                               height: bottomState.height,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 // color: _color,
//                                 borderRadius: _borderRadius,
//                               ),
//                               // Define how long the animation should take.
//                               duration: const Duration(milliseconds: 200),
//                               // Provide an optional curve to make the animation feel smoother.
//                               curve: Curves.fastOutSlowIn,
//                               child: Container(
//                                 padding: EdgeInsets.fromLTRB(16, (size.width - 32) * 2 / 10 + 16, 16,  0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       children: [
//
//                                         BlocBuilder<AddressInfoCubit, AddressInfoState>(
//                                             builder: (context, addressInfoState) {
//                                               if(addressInfoState is AddressInfoSuccess) {
//                                                 return Container(
//                                                     padding: EdgeInsets.only(
//                                                         bottom: 16),
//                                                     child: AutoSizeText("${addressInfoState.addressText}",
//                                                       style: MainStyles.boldTextStyle.copyWith(fontSize: 20),
//                                                       textAlign: TextAlign.center,
//                                                       maxLines: 2,
//                                                       overflow: TextOverflow.ellipsis,
//                                                     )
//                                                 );
//                                               }else if(addressInfoState is AddressInfoError){
//                                                 return Container(
//                                                 );
//                                               }else{
//                                                 return Container(
//                                                   child: CircularProgressIndicator(),
//                                                 );
//                                               }
//                                             }
//                                         ),
//                                         Container(
//                                           width: double.infinity,
//                                           padding: PagePadding.all16(),
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(16),
//                                               border: Border.all(color: MainColors.darkPink500!, width: 2)
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                         border: Border(
//                                                             right: BorderSide(
//                                                                 width: 1,
//                                                                 color: MainColors.middleGrey200!
//                                                             )
//                                                         )
//                                                     ),
//                                                     child: Column(
//                                                       children: [
//                                                         SvgPicture.asset("assets/svgs/challenges/challenge-distance.svg"),
//                                                         SizedBox(height: 8,),
//                                                         AutoSizeText(
//                                                           Utils.getString(context, "challenges_details_view___distance"),
//                                                           style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
//                                                           textAlign: TextAlign.center,
//                                                           maxLines: 2,
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                         SizedBox(height: 8,),
//                                                         AutoSizeText(
//                                                           "0 ${Utils.getString(context, "challenges_details_view___distance_measure")}",
//                                                           style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
//                                                           textAlign: TextAlign.center,
//                                                           maxLines: 2,
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )
//                                               ),
//                                               Expanded(
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                     ),
//                                                     child: Column(
//                                                       children: [
//                                                         SvgPicture.asset("assets/svgs/challenges/duration.svg"),
//                                                         SizedBox(height: 8,),
//                                                         AutoSizeText(
//                                                           Utils.getString(context, "challenges_details_view___end_date"),
//                                                           style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
//                                                           textAlign: TextAlign.center,
//                                                           maxLines: 2,
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                         SizedBox(height: 8,),
//                                                         AutoSizeText(
//                                                           "43",
//                                                           // "${state.challengeModel.endDate != null ? Utils.stringToDatetoString(value: state.challengeModel.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-'}",
//                                                           style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
//                                                           textAlign: TextAlign.center,
//                                                           maxLines: 2,
//                                                           overflow: TextOverflow.ellipsis,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                     GestureDetector(
//                                       onTap: ()async{
//                                         showYesNoDialog(context, Utils.getString(context, "challenges_details_view___cancel_dialog"),() async{
//                                           closeLoading(context);
//                                           showLoading(context, Utils.getString(context, "general__loading_text"));
//                                           List listData = await context.read<MainMapChallengeCubit>().cancelChallenge();
//
//                                           if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
//                                             closeLoading(context);
//                                             Navigator.pop(context);
//                                             Utils.showSuccessModal(context, size, title: Utils.getString(context, "challenges_details_view___cancel_dialog_success_message"));
//                                           }
//                                           else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
//                                             closeLoading(context);
//                                             Utils.showErrorModal(context, size, title: Utils.getString(context, "error_went_wrong"));
//                                           } else {
//                                             closeLoading(context);
//                                             Utils.showErrorModal(context, size, title: Utils.getString(context, "challenges_details_view___cancel_dialog_error_message"));
//                                           }
//
//                                         }, () {
//                                           // shouldClose = false;
//                                           Navigator.of(context).pop();
//                                         });
//                                       },
//                                       child: Container(
//                                           padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                                           child: Text(Utils.getString(context, "challenges_page_view___cancel_button"), style: MainStyles.boldTextStyle.copyWith(fontSize: 18, color: MainColors.darkBlue500), textAlign: TextAlign.center,)
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//                       ),
//                     ],
//                   ),
//
//                   BlocBuilder<BottomSectionCubit, BottomSectionState>(
//                       builder: (context, bottomSectionState) {
//                         return Positioned(
//                           right: ((size.width - 32) - (size.width - 32) * 4 / 10) / 2,
//                           left: ((size.width - 32) - (size.width - 32) * 4 / 10) / 2,
//                           bottom: bottomSectionState.height - 16 - (size.width - 32) * 4 / 10 / 2,
//                           child: BlocBuilder<StepSectionCubit, StepSectionState>(
//                               builder: (context, stepSectionState) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: MainColors.backgroundColor,
//                                       borderRadius: BorderRadius.circular(1000)
//                                   ),
//                                   padding: EdgeInsets.all(16),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: MainColors.darkBlue500,
//                                         borderRadius: BorderRadius.circular(1000)
//                                     ),
//                                     width: (size.width - 32) * 4 / 10,
//                                     height: (size.width - 32) * 4 / 10,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(bottom: 16.0),
//                                           child: SvgPicture.asset("assets/svgs/challenges/runing-user.svg"),
//                                         ),
//                                         Text(stepSectionState.step.toString(), style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 28, color: MainColors.white),),
//                                         // Text(stepSectionState.status.toString(), style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 24, color: MainColors.white),)
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//                           ),
//                         );
//                       }
//                   ),
//                   BlocBuilder<BottomSectionCubit, BottomSectionState>(
//                       builder: (context, bottomSectionState) {
//                         return Positioned(
//                           right: 16,
//                           bottom: bottomSectionState.height + (size.width - 32) * 1.5 / 10 / 2,
//                           child: BlocBuilder<StepSectionCubit, StepSectionState>(
//                               builder: (context, stepSectionState) {
//                                 return GestureDetector(
//                                   onTap: () async{
//                                     final result = await acquireCurrentLocation();
//                                     mapboxMapController
//                                         .animateCamera( CameraUpdate.newCameraPosition(
//                                       CameraPosition(
//                                         bearing: 270.0,
//                                         target: LatLng(result.latitude, result.longitude),
//                                         // tilt: 30.0,
//                                         zoom: 15.0,
//                                       ),
//                                     ),
//                                     );
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: MainColors.white,
//                                         borderRadius: BorderRadius.circular(1000)
//                                     ),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           color: MainColors.white,
//                                           borderRadius: BorderRadius.circular(1000)
//                                       ),
//                                       width: (size.width - 32) * 1.3 / 10,
//                                       height: (size.width - 32) * 1.3 / 10,
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             child: SvgPicture.asset("assets/svgs/challenges/current-location.svg"),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }
//                           ),
//                         );
//                       }
//                   ),
//                   // BlocBuilder<BottomSectionCubit, BottomSectionState>(
//                   //     builder: (context, bottomSectionState) {
//                   //       return Positioned(
//                   //         left: 16,
//                   //         bottom: bottomSectionState.height + (size.width - 32) * 1.5 / 10 / 2,
//                   //         child: BlocBuilder<StepSectionCubit, StepSectionState>(
//                   //             builder: (context, stepSectionState) {
//                   //               return GestureDetector(
//                   //                 onTap: () async{
//                   //                   // await mapboxMapController.cameraPosition.zoom = 13;
//                   //                   await mapboxMapController.animateCamera(
//                   //                     CameraUpdate.newLatLngZoom(computeCentroid([LatLng(40.377251,49.8425757), LatLng(40.3508735,49.8410668)]), 12),
//                   //                   );
//                   //                 },
//                   //                 child: Container(
//                   //                   decoration: BoxDecoration(
//                   //                       color: MainColors.white,
//                   //                       borderRadius: BorderRadius.circular(1000)
//                   //                   ),
//                   //                   child: Container(
//                   //                     decoration: BoxDecoration(
//                   //                         color: MainColors.white,
//                   //                         borderRadius: BorderRadius.circular(1000)
//                   //                     ),
//                   //                     width: (size.width - 32) * 1.3 / 10,
//                   //                     height: (size.width - 32) * 1.3 / 10,
//                   //                     child: Column(
//                   //                       mainAxisAlignment: MainAxisAlignment.center,
//                   //                       children: [
//                   //                         Container(
//                   //                           child: SvgPicture.asset("assets/svgs/challenges/current-location.svg"),
//                   //                         ),
//                   //                       ],
//                   //                     ),
//                   //                   ),
//                   //                 ),
//                   //               );
//                   //             }
//                   //         ),
//                   //       );
//                   //     }
//                   // ),
//                 ],
//               );
//             }
//         ),
//       ),
//     );
//   }
//   LatLng computeCentroid(Iterable<LatLng> points) {
//     double latitude = 0;
//     double longitude = 0;
//     int n = points.length;
//
//     for (LatLng point in points) {
//       latitude += point.latitude;
//       longitude += point.longitude;
//     }
//
//     return LatLng(latitude / n, longitude / n);
//   }
//
//   _setMapFitToTour(LatLng first, LatLng second, ) {
//     double minLat = first.latitude;
//     double minLong = first.longitude;
//     double maxLat = second.latitude;
//     double maxLong = second.longitude;
//
//     if(second.latitude < minLat) minLat = second.latitude;
//     if(second.latitude > maxLat) maxLat = second.latitude;
//     if(first.longitude < minLong) minLong = first.longitude;
//     if(first.longitude > maxLong) maxLong = first.longitude;
//
//     return [minLat, minLong, maxLat, maxLat];
//   }
// }