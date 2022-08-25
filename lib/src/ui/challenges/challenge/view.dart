
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/dialog/loading.dart';
import 'package:lifestep/src/tools/components/dialog/yesno.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/models/challenge/challenge_success.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/address/logic.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/bottom/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/bottom/state.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/main/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/main/state.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/polyline/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/polyline/state.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/step/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/step/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

import 'package:location/location.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'logic/address/state.dart';


class ChallengeView extends StatefulWidget {
  final LocationData? currentLocation;
  const ChallengeView({Key? key, this.currentLocation}) : super(key: key);

  @override
  _ChallengeViewState createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView>  with WidgetsBindingObserver{

  GoogleMapController? _controller;
  Location location = Location();
  LocationData? locationData;
  late StreamSubscription<LocationData> locationSubscription;
  int stepGeneral = 0;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:{
          //////// print('appLifeCycleState inactive');
        }
        break;
      case AppLifecycleState.resumed:
        {
          if (_controller != null) {
            GoogleMapController controller = _controller!;
            onMapCreated(controller);
          }
          // //////// print('appLifeCycleState resumed');
        }
        break;
      case AppLifecycleState.paused:
        {
          // //////// print('appLifeCycleState paused');
        }
        break;
      case AppLifecycleState.detached:
        {
          // //////// print('appLifeCycleState detached');
        }
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    location.enableBackgroundMode(enable: true);
    Permission.locationWhenInUse.request();
    location.requestPermission();
    super.initState();
  }
  // final geolocator.LocationSettings locationSettings = geolocator.LocationSettings(
  //   accuracy: geolocator.LocationAccuracy.high,
  //   distanceFilter: 100,
  // );



  @override
  Widget build(BuildContext context) {
    // final String token = MainConfig.mapBoxAccessToken;
    // final String style = 'mapbox://styles/digitalks22/ckzpb1qai000r14n8y7u9k6sy';
    Size size = MediaQuery.of(context).size;
    BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

    return WillPopScope(
      onWillPop: () async{
        showYesNoDialog(context, Utils.getString(context, "challenges_details_view___cancel_dialog"),() async{
          closeLoading(context);
          showLoading(context, Utils.getString(context, "general__loading_text"));
          List listData = await context.read<MainMapChallengeCubit>().cancelChallenge(stepGeneral);

          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            ProfileResponse profileResponse = ProfileResponse.fromJson(listData[1]);
            BlocProvider.of<SessionCubit>(context).setUser(profileResponse.data);
            context.read<AddressInfoCubit>().closeCubit();
            context.read<MainMapChallengeCubit>().closeCubit();
            closeLoading(context);
            Navigator.pop(context);

            int completedMinute = (context.read<AddressInfoCubit>().completedSecond / 60).round();
            double calStep = calculateDistance(context.read<StepSectionCubit>().stepLocal);
            double booster = context.read<MainMapChallengeCubit>().challengeModel.booster ?? 0;
            if(booster > 1)
              booster -= 1;
            int stepLocal = context.read<StepSectionCubit>().stepLocal;
            int bonusStep = (context.read<StepSectionCubit>().stepLocal * booster).round();
            Utils.showChallengeResultModal(context, size, image: "assets/svgs/challenges/canceled-challenge.svg", calStep: calStep, step: stepLocal , bonusStep: bonusStep,calMinute: completedMinute , title: "${Utils.getString(context, "challenges_details_view___cancel_dialog_success_title")}", description: "${sprintf(Utils.getString(context, "challenges_details_view___cancel_dialog_success_message"), [context.read<MainMapChallengeCubit>().challengeModel.name ?? ''])}");
          }
          else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
            closeLoading(context);
            BlocProvider.of<SessionCubit>(context).setUser(null);
            Navigator.pushReplacementNamed(context, "/apploading");
          } else {
            closeLoading(context);
            Utils.showErrorModal(context, size, errorCode: listData[2], title: Utils.getString(context, "challenges_details_view___cancel_dialog_error_message"));
          }

          return Future.value(true);
        }, () {
          // shouldClose = false;
          Navigator.of(context).pop();
          return Future.value(false);
        },
        svgAsset: "assets/svgs/challenges/cancel-dialog.svg"
        );

        return Future.value(false);
      },
      child: Scaffold(
        body: BlocBuilder<MainMapChallengeCubit, MainMapChallengeState>(
            builder: (context, mainMapChallengeState) {
              return Stack(
                children: [

                  Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<PolylineMapCubit, PolylineMapState>(
                          builder: (context, polylineMapState) {
                            // try {
                            //   //////// print(polylineMapState.polylines.values);
                            //   if (_controller != null &&
                            //       polylineMapState.polylines != null &&
                            //       !polylineMapState.polylines.isEmpty &&
                            //       polylineMapState.polylines.values.isNotEmpty)
                            //     _controller!
                            //         .animateCamera(
                            //       CameraUpdate.newCameraPosition(
                            //         CameraPosition(
                            //             bearing: 1,
                            //             tilt: 1,
                            //             target: computeCentroid(
                            //                 polylineMapState.polylines.values
                            //                     .first.points
                            //             ),
                            //             zoom: 13
                            //         ),
                            //       ),
                            //     );
                            // }catch(e){
                            //
                            // }
                            return GoogleMap(
                              compassEnabled: false,
                              zoomControlsEnabled: false,
                              polylines: Set<Polyline>.of(polylineMapState.polylines.values),
                              onMapCreated: (controller) async{
                                _controller = controller;

                                if(locationData == null) {
                                  showLoading(context, Utils.getString(
                                      context, "general__loading_text"));
                                  locationData = await location.getLocation();
                                  closeLoading(context);
                                }
                                // _controller!
                                //     .animateCamera( CameraUpdate.newCameraPosition(
                                //   CameraPosition(
                                //     // bearing: 270.0,
                                //     target: LatLng(locationData!.latitude!, locationData!.longitude!, ),
                                //     // tilt: 30.0,
                                //     zoom: 16.0,
                                //   ),
                                // ),
                                // );
                                onMapCreated(controller);
                                  if(widget.currentLocation != null){
                                    BlocProvider.of<AddressInfoCubit>(context).getAddressInfo(LatLng(widget.currentLocation!.latitude!, widget.currentLocation!.longitude!));
                                  }
                                  locationSubscription = location.onLocationChanged.listen((loc)  {
                                  locationData = loc;
                                  if(loc != null && loc.longitude != null) {
                                    BlocProvider.of<AddressInfoCubit>(context)
                                        .getAddressInfoTimer(LatLng(loc.latitude!, loc.longitude!));
                                    _controller!.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(target: LatLng(loc.latitude!, loc.longitude!),zoom: 18)),
                                    );
                                  }
                                  else {
                                    // //////// print(loc != null && loc.longitude != null);
                                  }

                                });
                              },
                              // markers: model.markers.values.toSet(),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,

                              initialCameraPosition: CameraPosition(
                                bearing: 1,
                                tilt: 1,
                                  target: computeCentroid(
                                      context.read<MainMapChallengeCubit>().challengeModel.getCoordinates()
                                  ),
                                  zoom: 13
                              ),
                            );
                          }
                        ),
                      ),
                      BlocBuilder<BottomSectionCubit, BottomSectionState>(
                          builder: (context, bottomState) {
                            return AnimatedContainer(
                              // Use the properties stored in the State class.
                              height: bottomState.height,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // color: _color,
                                borderRadius: _borderRadius,
                              ),
                              // Define how long the animation should take.
                              duration: const Duration(milliseconds: 200),
                              // Provide an optional curve to make the animation feel smoother.
                              curve: Curves.fastOutSlowIn,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(16, (size.width - 32) * 2 / 10 + 12, 16,  0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [

                                        BlocConsumer<AddressInfoCubit, AddressInfoState>(
                                            // listenWhen: (context, state) {
                                            //   return state is AddressInfoSuccess;
                                            // },
                                            listener: (context, state) async{
                                              if(state is AddressInfoSuccess){
                                                if(state.completed){

                                                  showLoading(context, Utils.getString(context, "general__loading_text"));
                                                  List listData = await context.read<AddressInfoCubit>().successChallenge(stepGeneral);
                                                  if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
                                                    //////// print("successChallengesuccessChallenge");
                                                    //////// print(listData[1]);
                                                    ChallengeSuccessResponse challengeSuccessResponse = ChallengeSuccessResponse.fromJson(listData[1]);
                                                    BlocProvider.of<SessionCubit>(context).setUser(challengeSuccessResponse.data!.joinedUser!.user);
                                                    closeLoading(context);
                                                    Navigator.of(context).pop();

                                                    int completedMinute = (context.read<AddressInfoCubit>().completedSecond / 60).round();
                                                    double calStep = calculateDistance(context.read<StepSectionCubit>().stepLocal);
                                                    double booster = context.read<MainMapChallengeCubit>().challengeModel.booster ?? 0;
                                                    if(booster > 1)
                                                      booster -= 1;
                                                    int stepLocal = context.read<StepSectionCubit>().stepLocal;
                                                    int bonusStep = (context.read<StepSectionCubit>().stepLocal * booster).round();
                                                    Navigator.of(context).pop();
                                                    Utils.showChallengeResultModal(context, size, image: "assets/svgs/challenges/completed-challenge.svg", calStep: calStep, step: stepLocal , bonusStep: bonusStep,calMinute: completedMinute , title: "${Utils.getString(context, "challenges_details_view___completed_dialog_success_title")}", description: "${sprintf(Utils.getString(context, "challenges_details_view___completed_dialog_success_message"), [context.read<MainMapChallengeCubit>().challengeModel.name ?? ''])}");
                                                  }
                                                  else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
                                                    closeLoading(context);
                                                    BlocProvider.of<SessionCubit>(context).setUser(null);
                                                    Navigator.pushReplacementNamed(context, "/apploading");
                                                  } else {
                                                    closeLoading(context);
                                                    Utils.showErrorModal(context, size, errorCode: listData[2], title: Utils.getString(context, "challenges_details_view___cancel_dialog_error_message"));
                                                  }
                                                }
                                              }

                                              // Navigate to next screen
                                              // Navigator.of(context).pushNamed('OrderCompletedScreen');
                                            },
                                          builder: (context, addressInfoState) {
                                            if(addressInfoState is AddressInfoSuccess) {
                                              return Container(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 16),
                                                  child: AutoSizeText("${addressInfoState.addressText}",
                                                    style: MainStyles.boldTextStyle.copyWith(fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                              );
                                            }else if(addressInfoState is AddressInfoError){
                                              return Container(
                                              );
                                            }else{
                                              return Container(
                                                child: const SkeltonWidget(
                                                  height: 8,
                                                ),
                                              );
                                            }
                                          }
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: MainColors.darkPink500!, width: 2)
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                width: 1,
                                                                color: MainColors.middleGrey200!
                                                            )
                                                        )
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset("assets/svgs/challenges/challenge-distance.svg"),
                                                        const SizedBox(height: 6,),
                                                        AutoSizeText(
                                                          Utils.getString(context, "challenges_page_view___user_distance"),
                                                          style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        const SizedBox(height: 6,),
                                                        BlocBuilder<StepSectionCubit, StepSectionState>(
                                                            builder: (context, stepSectionState) {
                                                              double calStep = calculateDistance(stepSectionState.step);
                                                              return AutoSizeText(
                                                                "${ calStep > 10 ? Utils.humanizeDouble(context, Utils.roundNumber(calStep, toPoint: 1)) : Utils.roundNumber(calStep, toPoint: 2)} ${ Utils.getString(context, "challenges_details_view___distance_measure")}",
                                                                style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                                textAlign: TextAlign.center,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              );
                                                            }
                                                        ),
                                                        // BlocBuilder<AddressInfoCubit, AddressInfoState>(
                                                        //   builder: (context, addressInfoState) {
                                                        //     if(addressInfoState is AddressInfoSuccess)
                                                        //     return AutoSizeText(
                                                        //       "${addressInfoState.distance != null ? addressInfoState.distance! > 1000 ? Utils.roundNumber(addressInfoState.distance! / 1000, toPoint: 2) : addressInfoState.distance! : 0} ${addressInfoState.distance!= null && addressInfoState.distance! < 1000 ? Utils.getString(context, "challenges_details_view___distance_measure_meter") : Utils.getString(context, "challenges_details_view___distance_measure")}",
                                                        //       style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                        //       textAlign: TextAlign.center,
                                                        //       maxLines: 2,
                                                        //       overflow: TextOverflow.ellipsis,
                                                        //     );
                                                        //     else{
                                                        //       return AutoSizeText(
                                                        //         "0 ${Utils.getString(context, "challenges_details_view___distance_measure")}",
                                                        //         style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                        //         textAlign: TextAlign.center,
                                                        //         maxLines: 2,
                                                        //         overflow: TextOverflow.ellipsis,
                                                        //       );
                                                        //     }
                                                        //   }
                                                        // ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    children: [
                                                      SvgPicture.asset("assets/svgs/challenges/duration.svg"),
                                                      const SizedBox(height: 8,),
                                                      AutoSizeText(
                                                        Utils.getString(context, "challenges_page_view___duration"),
                                                        style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
                                                        textAlign: TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 8,),
                                                      StreamBuilder<int>(
                                                          stream: context.read<AddressInfoCubit>().stopWatchTimer.rawTime,
                                                          initialData: context.read<AddressInfoCubit>().stopWatchTimer.rawTime.value,
                                                        builder: (context, snapshot) {
                                                          final value = snapshot.data!;
                                                          final displayTime = StopWatchTimer.getDisplayTime(value, milliSecond: false);
                                                          return AutoSizeText(
                                                            displayTime,
                                                            // "${state.challengeModel.endDate != null ? Utils.stringToDatetoString(value: state.challengeModel.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-'}",
                                                            style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                            textAlign: TextAlign.center,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        showYesNoDialog(context, Utils.getString(context, "challenges_details_view___cancel_dialog"),() async{

                                          closeLoading(context);

                                          showLoading(context, Utils.getString(context, "general__loading_text"));
                                          List listData = await context.read<MainMapChallengeCubit>().cancelChallenge(stepGeneral);
                                          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
                                            ProfileResponse profileResponse = ProfileResponse.fromJson(listData[1]);
                                            BlocProvider.of<SessionCubit>(context).setUser(profileResponse.data);
                                            context.read<AddressInfoCubit>().closeCubit();
                                            context.read<MainMapChallengeCubit>().closeCubit();
                                            closeLoading(context);
                                            Navigator.pop(context);

                                            int completedMinute = (context.read<AddressInfoCubit>().completedSecond / 60).round();
                                            double calStep = calculateDistance(context.read<StepSectionCubit>().stepLocal);
                                            double booster = context.read<MainMapChallengeCubit>().challengeModel.booster ?? 0;
                                            if(booster > 1) {
                                              booster -= 1;
                                            }
                                            int stepLocal = context.read<StepSectionCubit>().stepLocal;
                                            int bonusStep = (context.read<StepSectionCubit>().stepLocal * booster).round();
                                            Utils.showChallengeResultModal(context, size, image: "assets/svgs/challenges/canceled-challenge.svg", calStep: calStep, step: stepLocal , bonusStep: bonusStep,calMinute: completedMinute , title: Utils.getString(context, "challenges_details_view___cancel_dialog_success_title"), description: sprintf(Utils.getString(context, "challenges_details_view___cancel_dialog_success_message"), [context.read<MainMapChallengeCubit>().challengeModel.name ?? '']));
                                          }
                                          else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
                                            closeLoading(context);
                                            Utils.showErrorModal(context, size, errorCode: listData[2], title: Utils.getString(context, "error_went_wrong"));
                                          } else {
                                            closeLoading(context);
                                            Utils.showErrorModal(context, size, errorCode: listData[2], title: Utils.getString(context, "challenges_details_view___cancel_dialog_error_message"));
                                          }
                                        }, () {
                                          // shouldClose = false;
                                          Navigator.of(context).pop();
                                        },
                                        svgAsset: "assets/svgs/challenges/cancel-dialog.svg"
                                        );
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.only(bottom: 20, top: 16, left: 16, right: 16),
                                          child: Text(Utils.getString(context, "challenges_page_view___cancel_button"), style: MainStyles.boldTextStyle.copyWith(fontSize: 18, color: MainColors.darkBlue500), textAlign: TextAlign.center,)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),

                  BlocBuilder<BottomSectionCubit, BottomSectionState>(
                      builder: (context, bottomSectionState) {
                        return Positioned(
                          right: ((size.width - 32) - (size.width - 32) * 4 / 10) / 2,
                          left: ((size.width - 32) - (size.width - 32) * 4 / 10) / 2,
                          bottom: bottomSectionState.height - 16 - (size.width - 32) * 4 / 10 / 2,
                          child: BlocBuilder<StepSectionCubit, StepSectionState>(
                              builder: (context, stepSectionState) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: MainColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(1000)
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: MainColors.darkBlue500,
                                        borderRadius: BorderRadius.circular(1000)
                                    ),
                                    width: (size.width - 32) * 4 / 10,
                                    height: (size.width - 32) * 4 / 10,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16.0),
                                          child: SvgPicture.asset("assets/svgs/challenges/runing-user.svg"),
                                        ),
                                        Text(stepSectionState.step.toString(), style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 28, color: MainColors.white),),
                                        // Text(stepSectionState.status.toString(), style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 24, color: MainColors.white),)
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                        );
                      }
                  ),
                  BlocBuilder<BottomSectionCubit, BottomSectionState>(
                      builder: (context, bottomSectionState) {
                        return Positioned(
                          right: 16,
                          bottom: bottomSectionState.height + (size.width - 32) * 1.5 / 10 / 2,
                          child: BlocBuilder<StepSectionCubit, StepSectionState>(
                              builder: (context, stepSectionState) {
                                return GestureDetector(
                                  onTap: () async{
                                    stepGeneral = stepSectionState.step;
                                    // geolocator.Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high)
                                    //     .then((value) {
                                    //     _controller
                                    //         .animateCamera( CameraUpdate.newCameraPosition(
                                    //       CameraPosition(
                                    //         // bearing: 270.0,
                                    //         target: LatLng(value.latitude, value.longitude),
                                    //         // tilt: 30.0,
                                    //         zoom: 13.0,
                                    //       ),
                                    //     ),
                                    //     );
                                    // });
                                    //     if(locationData == null)
                                          locationData??= await location.getLocation();
                                        _controller!
                                            .animateCamera( CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            // bearing: 270.0,
                                            target: LatLng(locationData!.latitude!, locationData!.longitude!, ),
                                            // tilt: 30.0,
                                            zoom: 16.0,
                                          ),
                                        ),
                                        );

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: MainColors.white,
                                        borderRadius: BorderRadius.circular(1000)
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: MainColors.white,
                                          borderRadius: BorderRadius.circular(1000)
                                      ),
                                      width: (size.width - 32) * 1.3 / 10,
                                      height: (size.width - 32) * 1.3 / 10,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/svgs/challenges/current-location.svg"),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        );
                      }
                  ),
                  // BlocBuilder<BottomSectionCubit, BottomSectionState>(
                  //     builder: (context, bottomSectionState) {
                  //       return Positioned(
                  //         left: 16,
                  //         bottom: bottomSectionState.height + (size.width - 32) * 1.5 / 10 / 2,
                  //         child: BlocBuilder<StepSectionCubit, StepSectionState>(
                  //             builder: (context, stepSectionState) {
                  //               return GestureDetector(
                  //                 onTap: () async{
                  //                   // await mapboxMapController.cameraPosition.zoom = 13;
                  //                   await mapboxMapController.animateCamera(
                  //                     CameraUpdate.newLatLngZoom(computeCentroid([LatLng(40.377251,49.8425757), LatLng(40.3508735,49.8410668)]), 12),
                  //                   );
                  //                 },
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                       color: MainColors.white,
                  //                       borderRadius: BorderRadius.circular(1000)
                  //                   ),
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                         color: MainColors.white,
                  //                         borderRadius: BorderRadius.circular(1000)
                  //                     ),
                  //                     width: (size.width - 32) * 1.3 / 10,
                  //                     height: (size.width - 32) * 1.3 / 10,
                  //                     child: Column(
                  //                       mainAxisAlignment: MainAxisAlignment.center,
                  //                       children: [
                  //                         Container(
                  //                           child: SvgPicture.asset("assets/svgs/challenges/current-location.svg"),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               );
                  //             }
                  //         ),
                  //       );
                  //     }
                  // ),
                ],
              );
            }
        ),
      ),
    );
  }
  //onMapCreated method
  void onMapCreated(GoogleMapController controller) async{

    _controller = controller;
    // _controller!.setMapStyle("[]");


    // setState(() {
    // });

  }


  LatLng computeCentroid(Iterable<LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    return LatLng(latitude / n, longitude / n);
  }

  // _setMapFitToTour(LatLng first, LatLng second, ) {
  //   double minLat = first.latitude;
  //   double minLong = first.longitude;
  //   double maxLat = second.latitude;
  //   double maxLong = second.longitude;
  //
  //   if(second.latitude < minLat) minLat = second.latitude;
  //   if(second.latitude > maxLat) maxLat = second.latitude;
  //   if(first.longitude < minLong) minLong = first.longitude;
  //   if(first.longitude > maxLong) maxLong = first.longitude;
  //
  //   return [minLat, minLong, maxLat, maxLat];
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    locationSubscription.cancel();

    // location.enableBackgroundMode(enable: false);



    super.dispose();
  }


  double calculateDistance(int currentStepCount) {
    if(!mounted) {
        return currentStepCount * 0.0008 * 0.6214;
    } else {
        return currentStepCount * 0.0008 * 0.6214;
    }
  }


}