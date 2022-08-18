
import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/src/tools/common/utlis.dart';
import 'package:lifestep/src/tools/components/buttons/big_unborderd_button.dart';
import 'package:lifestep/src/tools/components/carousel/general.dart';
import 'package:lifestep/src/tools/components/countdown/countdown_tag.dart';
import 'package:lifestep/src/tools/components/dialog/loading.dart';
import 'package:lifestep/src/tools/components/error/general-widget.dart';
import 'package:lifestep/src/tools/components/shimmers/donations/donor.dart';
import 'package:lifestep/src/tools/components/shimmers/skeleton-list-no-scrolling.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/scroll_behavior.dart';
import 'package:lifestep/src/tools/config/styles.dart';
import 'package:lifestep/src/tools/constants/enum.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/models/challenge/challenge-user.dart';
import 'package:lifestep/src/models/challenge/participants.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/address/logic.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/bottom/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/main/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/polyline/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/step/cubit.dart';
import 'package:lifestep/src/ui/challenges/challenge/view.dart';
import 'package:lifestep/src/ui/challenges/details/logic/deatil_cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/details_state.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/src/ui/challenges/details/logic/participants/state.dart';
import 'package:lifestep/src/ui/challenges/preview_map/logic/cubit.dart';
import 'package:lifestep/src/ui/challenges/preview_map/logic/state.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

export 'package:location_platform_interface/location_platform_interface.dart'
    show PermissionStatus, LocationAccuracy, LocationData
;
import 'package:sprintf/sprintf.dart';

import 'components/step_stage/view.dart';
import 'logic/pin-click/cubit.dart';
import 'logic/pin-click/state.dart';
import 'logic/sliding-up-panel/cubit.dart';
import 'logic/sliding-up-panel/state.dart';
import 'package:lifestep/src/tools/general/padding/page-padding.dart';

import 'logic/step_base_stage/cubit.dart';
import 'logic/step_base_stage/state.dart';

class ChallengeDetailView extends StatefulWidget {
  const ChallengeDetailView({Key? key}) : super(key: key);

  @override
  _ChallengeDetailViewState createState() => _ChallengeDetailViewState();
}

class _ChallengeDetailViewState extends State<ChallengeDetailView> with WidgetsBindingObserver{

  PageController controller = PageController(viewportFraction: 0.9);
  GoogleMapController? _controller;
  Location location = Location();
  LocationData? locationData;
  late StreamSubscription<LocationData> locationSubscription;
  late CountdownTimerController countdownTimerController;
  late int endTime;




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
    Permission.locationWhenInUse.request();
    location.requestPermission();



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return MultiBlocProvider(
      providers: [
        BlocProvider<SlidingUpCubit>(create: (BuildContext context) => SlidingUpCubit(height: size.height)),
        BlocProvider<PinClickCubit>(create: (BuildContext context) => PinClickCubit()),

      ],
      child: BlocBuilder<ChallengeDetailBloc, ChallengeDetailState>(
        builder: (context, state) {
          endTime = Utils.stringToDate(value: state.challengeModel.endDate ?? '', format : "yyyy-MM-dd").millisecondsSinceEpoch + 1000000 * 87;
          countdownTimerController = CountdownTimerController(endTime: endTime);
          CameraPosition cameraPosition  = CameraPosition(
              bearing: 1,
              tilt: 1,
              target: computeCentroid(
                  context.read<PreviewPolylineMapCubit>().challengeModel.getCoordinates()
              ),
              zoom: state.challengeModel.mapZoom!
          );
          return Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {
                //////// print("GestureDetector");
                Utils.focusClose(context);
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  state.challengeModel.type == CHALLENGE_TYPE.STEP ?
                  state.challengeModel.gallery != null ?
                    GeneralCarouselWidget(
                      imageList: state.challengeModel.gallery!,
                      height: size.width,
                      extraWidgets: [

                        Positioned(
                          bottom: 56,
                          left: 16,
                          // width: 300,
                          // right: 0,
                          child: CountdownTagWidget(controller: countdownTimerController,),
                        ),
                      ]
                    ) : Container() :
                  BlocBuilder<PreviewPolylineMapCubit, PreviewPolylineMapState>(
                      builder: (context, polylineMapState) {
                        return SizedBox(
                          height: size.height * 6 / 10 + 20,
                          child: Listener(
                            onPointerUp: (e) {

                              // print("USER IS onPointerUp");
                              // if(model.markerId != null) {
                              //////// print(model.markers[model.markerId].position);
                              //////// print(model.markers[model.markerId].infoWindow.title);
                              //   model.getAddressInfo();
                              // }
                            },
                            onPointerMove: (e) {

                              context.read<PinClickCubit>().bothFalse();
                              // print("USER IS onPointerMove");
                              // if(model.markerId != null) {
                              //////// print(model.markers[model.markerId].position);
                              //////// print(model.markers[model.markerId].infoWindow.title);
                              //   model.getAddressInfo();
                              // }
                            },
                            child: GoogleMap(
                              gestureRecognizers: [
                                Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                ),
                              ].toSet(),
                              compassEnabled: false,
                              zoomControlsEnabled: false,
                              polylines: Set<Polyline>.of(polylineMapState.polylines.values),
                              onMapCreated: (controller) async{
                                _controller = controller;

                                if(locationData == null) {
                                  // showLoading(context, Utils.getString(
                                  //     context, "general__loading_text"));
                                  locationData = await location.getLocation();
                                  // closeLoading(context);
                                }
                                onMapCreated(controller);
                                locationSubscription = location.onLocationChanged.listen((loc)  {
                                  locationData = loc;
                                });
                              },
                              // markers: model.markers.values.toSet(),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,

                              initialCameraPosition: cameraPosition,
                            ),
                          ),
                        );
                      }
                  ),
                  if(!(state.challengeModel.type == CHALLENGE_TYPE.STEP))
                  BlocBuilder<SlidingUpCubit, SlidingUpState>(
                      builder: (context, state) {
                        return Positioned(
                          right: 10.0 + size.width * 1.4 / 10 + 16,
                          bottom: state.fabHeight,
                          // top: 50,
                          child: Container(
                              height: size.width * 1.4 / 10,
                              width: size.width * 1.4 / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width * 1.4 / 10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                ],
                              ),
                              child: BlocBuilder<PinClickCubit, PinClickState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: ()async{

                                        if(!state.clicked) {
                                          if (locationData == null) {
                                            // showLoading(context, Utils.getString(
                                            //     context, "general__loading_text"));
                                            locationData = await location.getLocation();
                                            // closeLoading(context);
                                          }

                                          context.read<PinClickCubit>().clickLocationActive();
                                          _controller!
                                              .animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                // bearing: 270.0,
                                                target: LatLng(
                                                  locationData!.latitude!,
                                                  locationData!.longitude!,),
                                                // tilt: 30.0,
                                                zoom: 16.0,
                                              ),
                                            ),
                                          );
                                        }else{
                                        }
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: MainColors.white,
                                            borderRadius: BorderRadius.circular(size.width * 1.4 / 10),
                                          ),
                                          child: Center(
                                              child: SvgPicture.asset("assets/svgs/challenges/current-location-np.svg", height : (size.width * 1.4 / 10) * 1.6 / 4, color: state.clicked ? MainColors.generalSubtitleColor : MainColors.black)
                                          )
                                      ),
                                    );
                                  }
                              )
                          ),
                        );
                      }
                  ),

                  if(!(state.challengeModel.type == CHALLENGE_TYPE.STEP))
                  BlocBuilder<SlidingUpCubit, SlidingUpState>(
                      builder: (context, state) {
                        return Positioned(
                          right: 16.0,
                          bottom: state.fabHeight,
                          // top: 50,
                          child: Container(
                              height: size.width * 1.4 / 10,
                              width: size.width * 1.4 / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width * 1.4 / 10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                ],
                              ),
                              child: BlocBuilder<PinClickCubit, PinClickState>(
                                builder: (context, pinClickState) {
                                  return GestureDetector(
                                    onTap: (){

                                      context.read<PinClickCubit>().clickTrackActive();
                                      _controller!.animateCamera( CameraUpdate.newCameraPosition(cameraPosition));

                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: MainColors.white,
                                          borderRadius: BorderRadius.circular(size.width * 1.4 / 10),
                                        ),
                                        child: Center(
                                            child: SvgPicture.asset("assets/svgs/challenges/full-track.svg", height : (size.width * 1.4 / 10) * 1.4 / 4, color: pinClickState.clickedTrack ? MainColors.generalSubtitleColor : MainColors.black)
                                        )
                                    ),
                                  );
                                }
                              )
                          ),
                        );
                      }
                  ),

                  Column(
                    children: [
                      Expanded(
                        child: SlidingUpPanel(
                          backdropEnabled: true,
                          maxHeight: size.height * 1.0 - 64 - 128,
                          minHeight: state.challengeModel.type == CHALLENGE_TYPE.STEP ? size.height - size.width - 56 : size.height * 4 / 10 - 64,
                          parallaxEnabled: true,
                          parallaxOffset: .5,
                          // collapsed: Container(
                          //   height: 30,
                          //   color: Colors.red,
                          // ),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0)
                          ),
                          boxShadow: [

                            // BoxShadow(
                            //     color: Color.fromRGBO(0, 0, 0, 0.25),
                            //     blurRadius: 4.0,
                            //     offset: Offset(0.0, -4.0)
                            // ),
                          ],

                          // borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(18.0),
                          //     topRight: Radius.circular(18.0)),
                          // body: Container(),
                          panelBuilder: (sc) => MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MainColors.white,

                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.0),
                                        topRight: Radius.circular(24.0))
                                ),
                                padding: const EdgeInsets.only(
                                    // left: 16,
                                    // right: 16,
                                    top: 8,
                                    bottom: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Center(
                                      child: Container(
                                          width: 64,
                                          height: 4,
                                          decoration: BoxDecoration(
                                              color: MainColors.middleGrey200,
                                              borderRadius:
                                              BorderRadius.circular(30))),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: ScrollConfiguration(
                                        behavior: MainScrollBehavior(),
                                        child: SingleChildScrollView(
                                          controller: sc,
                                          // physics: ScrollPhysics(),
                                          // physics: const AlwaysScrollableScrollPhysics(),
                                          child: Column(
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                ),
                                                child: Column(
                                                  children: [
                                                    AutoSizeText(
                                                      state.challengeModel.name ?? '-',
                                                      style: MainStyles.appbarStyle,
                                                      textAlign: TextAlign.center,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),

                                                    Container(
                                                      width: double.infinity,
                                                      padding: PagePadding.all16(),
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
                                                                    SvgPicture.asset("assets/svgs/challenges/map-pin.svg"),
                                                                    const SizedBox(height: 8,),
                                                                    AutoSizeText(
                                                                      Utils.getString(context, "challenges_details_view___distance"),
                                                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    const SizedBox(height: 8,),
                                                                    AutoSizeText(
                                                                      "${state.challengeModel.distance ?? '0'} ${Utils.getString(context, "challenges_details_view___distance_measure")}",
                                                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
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
                                                                    SvgPicture.asset("assets/svgs/challenges/finish-time.svg"),
                                                                    const SizedBox(height: 8,),
                                                                    AutoSizeText(
                                                                      Utils.getString(context, "challenges_details_view___end_date"),
                                                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    const SizedBox(height: 8,),
                                                                    AutoSizeText(
                                                                      "${state.challengeModel.endDate != null ? Utils.stringToDatetoString(value: state.challengeModel.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-'}",
                                                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                                      textAlign: TextAlign.center,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
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
                                                                    Utils.getString(context, "challenges_details_view___average_time"),
                                                                    style: MainStyles.semiBoldTextStyle.copyWith(height: 1.1, fontSize: 12, color: MainColors.middleGrey400),
                                                                    textAlign: TextAlign.center,
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  const SizedBox(height: 8,),
                                                                  AutoSizeText(
                                                                    "~ ${state.challengeModel.averageTime ?? '0'} ${Utils.getString(context, "challenges_details_view___average_time_measure")}",
                                                                    style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                                    textAlign: TextAlign.center,
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    AutoSizeText(
                                                      state.challengeModel.description  ?? '-',
                                                      style: MainStyles.semiBoldTextStyle.copyWith(height: 1.3, ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 24,
                                              ),

                                              StepStageWidget(),

                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                ),
                                                child: Column(
                                                  children: [

                                                    Container(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            AutoSizeText(Utils.getString(context, "challenge_detail_view__top_members"), style: MainStyles.boldTextStyle.copyWith(fontSize: 20),),
                                                            BlocBuilder<ParticipantListCubit, ParticipantListState>(
                                                                builder: (context, stateParticipant) {
                                                                  //////// print("BlocBuilder<ParticipantListCubit, ParticipantListState>");
                                                                  //////// print(stateParticipant);
                                                                  return stateParticipant is ParticipantListSuccess ?
                                                                  AutoSizeText("${stateParticipant.dataCount} ${Utils.getString(context, "general__person__count")}", style: MainStyles.boldTextStyle.copyWith(fontSize: 16, color: MainColors.generalSubtitleColor),)
                                                                      : Container(child: Text(" "),);
                                                                }
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                    const SizedBox(height: 4,),

                                                    BlocBuilder<ParticipantListCubit, ParticipantListState>(
                                                        builder: (context, stateParticipant) {
                                                          //////// print("BlocBuilder<ParticipantListCubit, ParticipantListState>");
                                                          //////// print(stateParticipant);
                                                          return stateParticipant is ParticipantListSuccess ? ListView.separated(
                                                            separatorBuilder: (BuildContext context, int index) {
                                                              return SizedBox(height: 4,);
                                                            },
                                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                                            itemCount: stateParticipant.dataList.length,
                                                            physics: ScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              return _DataItem(index: index, participantModel: stateParticipant.dataList[index]);
                                                            },
                                                          ) : stateParticipant is ParticipantListError ?
                                                          GeneralErrorLoadAgainWidget(
                                                            onTap: (){
                                                              context.read<ParticipantListCubit>().search();
                                                            },
                                                          )
                                                              : SkeletonNoScrollingListWidget(
                                                            child: DonorListItemShimmerWidget(),
                                                          );
                                                        }
                                                    ),
                                                    if(state.challengeModel.sponsorName != null)
                                                      const SizedBox(height: 16),
                                                    if(state.challengeModel.sponsorName != null)
                                                      Container(
                                                        padding: PagePadding.all16(),
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: MainColors.backgroundColor,
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset("assets/images/api/company.png", width: size.width * 1.5 / 10),
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets.only(left: 16),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [

                                                                    Padding(
                                                                      padding: const EdgeInsets.only(bottom: 4),
                                                                      child: Text(
                                                                        Utils.getString(context, "challenge_detail_view__sponsor"),
                                                                        style: MainStyles.semiBoldTextStyle.copyWith(fontSize: 14, color: MainColors.middleGrey400),
                                                                        textAlign: TextAlign.left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    AutoSizeText(
                                                                      "${state.challengeModel.sponsorName!}",
                                                                      style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                                                                      textAlign: TextAlign.left,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          onPanelSlide: (double pos) {
                            // context.read<SlidingUpCubit>().changePosition(pos);
                            // setState(() {
                            //   _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                            //       _initFabHeight;
                            // });
                          },
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: BigUnBorderedButton(
                          buttonColor: MainColors.generalSubtitleColor,
                          onTap: () async{
                            if(Platform.isAndroid) {
                              var status = await Permission.activityRecognition.status;
                              if (status.isDenied) {
                                var status2 = await Permission.activityRecognition.request();
                                if (!status2.isGranted) {
                                  //////// print("!status2.isGranted");
                                  // stepsPermissionDialog();
                                  return;
                                }
                              }
                            }else if(Platform.isIOS){

                            }
                            var status3 = await Permission.locationWhenInUse.status;
                            if(status3.isDenied) {
                              var status4 =await Permission.locationWhenInUse.request();
                              if(!status4.isGranted) {
                                //////// print("!status4.isGranted");
                                // stepsPermissionDialog();
                                return;
                              }
                            }
                            Location location = Location();
                            await location.requestPermission();

                            showLoading(context, Utils.getString(context, "general__loading_text"));
                            List listData = await context.read<ChallengeDetailBloc>().handleChallenge();
                            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
                              ChallengeUserResponse challengeUserResponse = ChallengeUserResponse.fromJson(listData[1]);

                              Location location = Location();
                              location.getLocation().then((value)async{
                                if(value == null || value.latitude == null){
                                  closeLoading(context);
                                  Utils.showErrorModal(context, size, image: "assets/svgs/challenges/location-error.svg", title: Utils.getString(context,"challenges_details_view___joined_to_challenge_dialog_cant_get_your_location"));
                                }else {
                                  List<int> distanceListData = await context
                                      .read<ChallengeDetailBloc>()
                                      .challengeRepository
                                      .getDistanceBetweenPoints(LatLng(
                                      value.latitude!, value.longitude!),
                                      LatLng(state.challengeModel.startLat!,
                                          state.challengeModel.startLong!));
                                  //////// print("location__location__location__location__location__location");
                                  //////// print(distanceListData[0]);
                                  if(distanceListData[0] != -1) {
                                    closeLoading(context);
                                    if(distanceListData[0] >= 0 && distanceListData[0] <= state.challengeModel.startDistance!) {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider<
                                                            MainMapChallengeCubit>(
                                                            create: (
                                                                BuildContext context) =>
                                                                MainMapChallengeCubit(
                                                                    challengeRepository: GetIt.instance<ChallengeRepository>(),
                                                                    challengeModel: state
                                                                        .challengeModel,
                                                                    challengeUserModel: challengeUserResponse
                                                                        .data!
                                                                )),
                                                        BlocProvider<
                                                            BottomSectionCubit>(
                                                            create: (
                                                                BuildContext context) =>
                                                                BottomSectionCubit(
                                                                  challengeRepository: GetIt.instance<ChallengeRepository>(),
                                                                  challengeModel: state
                                                                      .challengeModel,
                                                                  height: size
                                                                      .height *
                                                                      0.45,
                                                                )),
                                                        BlocProvider<
                                                            StepSectionCubit>(
                                                            create: (
                                                                BuildContext context) =>
                                                                StepSectionCubit(
                                                                  challengeRepository: GetIt.instance<ChallengeRepository>(),
                                                                  challengeModel: state
                                                                      .challengeModel,
                                                                  step: 0,
                                                                )),
                                                        BlocProvider<
                                                            AddressInfoCubit>(
                                                            create: (
                                                                BuildContext context) =>
                                                                AddressInfoCubit(
                                                                    challengeRepository: GetIt.instance<ChallengeRepository>(),
                                                                    challengeModel: state
                                                                        .challengeModel,
                                                                    challengeUserModel: challengeUserResponse
                                                                        .data!
                                                                )),
                                                        BlocProvider<
                                                            PolylineMapCubit>(
                                                            create: (
                                                                BuildContext context) =>
                                                                PolylineMapCubit(
                                                                    challengeRepository: GetIt.instance<ChallengeRepository>(),
                                                                    challengeModel: state
                                                                        .challengeModel,
                                                                    challengeUserModel: challengeUserResponse
                                                                        .data!
                                                                )),
                                                      ],
                                                      child: ChallengeView()
                                                  )));
                                    }else{
                                      Utils.showErrorModal(context, size, image: "assets/svgs/challenges/location-error.svg", title: Utils.getString(context,"challenges_details_view___joined_to_challenge_dialog_you_are_not_in_start_point"));
                                    }
                                  }else{

                                    closeLoading(context);
                                    Utils.showErrorModal(context, size,
                                        errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR,
                                        title: Utils.getString(context,
                                            "challenges_details_view___joined_to_challenge_dialog_unexpected_error_try_again"));
                                  }
                                }
                              }).catchError((e){

                                closeLoading(context);
                              });
                            }
                            else
                            if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH) {
                              closeLoading(context);
                              BlocProvider.of<SessionCubit>(context).setUser(null);
                              Navigator.pushReplacementNamed(context, "/apploading");
                            } else {
                              closeLoading(context);
                              //////// print("listData[2]listData[2]listData[2]");
                              //////// print(listData[2]);
                              Utils.showErrorModal(context, size,
                                  errorCode: listData[2],
                                  title: Utils.getString(
                                      context, "error_went_wrong"));
                            }

                          },
                          // borderRadius: 100,
                          text: Utils.getString(context, "challenge_detail_view__button_start"),
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    left: 2.0,
                    top: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Utils.focusClose(context);
                        Navigator.pop(context);
                      },
                      child: Container(

                        padding: const EdgeInsets.fromLTRB(
                          14,
                          14,
                          14,
                          14,
                          // 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100),
                          // color: MainColors.white,

                          // boxShadow: [
                          //     BoxShadow(
                          //     blurRadius: 8.0,
                          //     color: Color.fromRGBO(0, 0, 0, 0.25),
                          //   ),
                          // ],
                        ),
                        child: SvgPicture.asset(
                          "assets/svgs/menu/back.svg",
                          color: MainColors.white,
                          height: 24,
                        ),
                      ),

                    ),
                  ),

                  Positioned(
                    right: 2.0,
                    top: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Utils.focusClose(context);
                        Navigator.pop(context);
                      },
                      child: Container(

                        padding: const EdgeInsets.fromLTRB(
                          14,
                          14,
                          14,
                          14,
                          // 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100),
                          // color: MainColors.white,

                          // boxShadow: [
                          //     BoxShadow(
                          //     blurRadius: 8.0,
                          //     color: Color.fromRGBO(0, 0, 0, 0.25),
                          //   ),
                          // ],
                        ),
                        child: SvgPicture.asset(
                          "assets/svgs/menu/share.svg",
                          color: MainColors.white,
                          height: 24,
                        ),
                      ),

                    ),
                  ),



                ],
              ),
            ),
          );
        }
      ),
    );
  }

  //onMapCreated method
  void onMapCreated(GoogleMapController controller) async{

    _controller = controller;


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



}


class _DataItem extends StatelessWidget {
  final int index;
  final ParticipantModel participantModel;
  const _DataItem({Key? key, required this.index, required this.participantModel}) : super(key: key);


@override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MainColors.mainBorderColor)),
      ),
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: MainColors.white,
            // border: Border(
            //   bottom: BorderSide(
            //     color: MainColors.middleGrey200!
            //   )
            // )
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
                  child: Image.asset(
                      participantModel.genderType.getImage,
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

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        participantModel.fullName ?? "-",
                        style: MainStyles.boldTextStyle.copyWith(height: 1.1, fontSize: 16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        "${sprintf(Utils.getString(context, "challenges_details_view___participant_minute"), [((participantModel.time != null ? participantModel.time! : 0) / 60).round()])}",
                        style: MainStyles.semiBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 12, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              Text("${(index + 1).toString()}",
                style: MainStyles.extraBoldTextStyle.copyWith(color: MainColors.middleGrey400, fontSize: 14, height: 1.1),
              )
            ],
          ),
        ),
      ),
    );
  }
}





class _AchievementItemWidget extends StatelessWidget {
  final String iconAddress;
  final Color backgroundColor;
  final Widget title;
  final Widget subTitle;
  const _AchievementItemWidget({Key? key, required this.iconAddress, required this.backgroundColor,  required this.title,  required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 3.0 / 10,
      margin: const EdgeInsets.only(bottom:0),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: GestureDetector(
        onTap: () async{
          FocusScope.of(context).requestFocus(FocusNode());
//          focusNode.unfocus();
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/api/ach1.png", height: size.width * 3.0 / 10 - 8,),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      title,
                      const SizedBox(height: 4),
                      subTitle,
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


