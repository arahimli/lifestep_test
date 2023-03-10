
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/features/tools/common/modal_utlis.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/main_app/presentation/widgets/buttons/big_unborderd_button.dart';
import 'package:lifestep/features/main_app/presentation/widgets/carousel/general.dart';
import 'package:lifestep/features/main_app/presentation/widgets/countdown/countdown_tag.dart';
import 'package:lifestep/features/main_app/presentation/widgets/dialog/loading.dart';
import 'package:lifestep/features/main_app/presentation/widgets/dialog/yesno.dart';
import 'package:lifestep/features/tools/config/main_colors.dart';
import 'package:lifestep/features/tools/config/scroll_behavior.dart';
import 'package:lifestep/features/tools/config/styles.dart';
import 'package:lifestep/features/tools/constants/enum.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/cubit.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenge_user.dart';
import 'package:lifestep/features/tools/packages/read_more_html/text_overflow_decector.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/address/logic.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/bottom/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/main/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/polyline/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/step/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/view.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/deatil_cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/details_state.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/preview_map/logic/cubit.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/preview_map/logic/state.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sprintf/sprintf.dart';

export 'package:location_platform_interface/location_platform_interface.dart'
    show PermissionStatus, LocationAccuracy, LocationData;

import 'components/step_base/how_can_win/view.dart';
import 'components/step_base/participants/view.dart';
import 'components/step_base/step_stage/view.dart';
import 'components/track_base/participants/view.dart';
import 'logic/participants_step_base/cubit.dart';
import 'logic/pin-click/cubit.dart';
import 'logic/pin-click/state.dart';
import 'logic/sliding-up-panel/cubit.dart';
import 'logic/sliding-up-panel/state.dart';
import 'package:lifestep/features/tools/general/padding/page_padding.dart';

class ChallengeDetailView extends StatefulWidget {
  const ChallengeDetailView({Key? key}) : super(key: key);

  static const routeName = "/challenge-detail";

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
  late ConfettiController _controllerTopCenter;


  @override
  void initState() {
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 5));
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
      child: BlocConsumer<ChallengeDetailBloc, ChallengeDetailState>(
        listener: (context, state){
          log("[LOG joinStepBaseChallenge] the god" + state.hashCodeData);
        },
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
          return WillPopScope(
            onWillPop: ()async{
              if(context.read<ChallengeDetailBloc>().challengeChanged) {
                Navigator.pop(context, state.challengeModel);
              }
              else {
                Navigator.pop(context);
              }
              return Future(() => false);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: GestureDetector(
                onTap: () {
                  //////// print("GestureDetector");
                  Utils.focusClose(context);
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    state.challengeModel.type == CHALLENGE_TYPE.step ?
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
                              },
                              child: GoogleMap(
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                        () => EagerGestureRecognizer(),
                                  ),
                                },
                                compassEnabled: false,
                                zoomControlsEnabled: false,
                                polylines: Set<Polyline>.of(polylineMapState.polylines.values),
                                onMapCreated: (controller) async{
                                  _controller = controller;

                                  locationData ??= await location.getLocation();
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
                    if(!(state.challengeModel.type == CHALLENGE_TYPE.step))
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
                                  boxShadow: const [
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
                                            locationData ??= await location.getLocation();

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

                    if(!(state.challengeModel.type == CHALLENGE_TYPE.step))
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
                                  boxShadow: const [
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
                            minHeight: state.challengeModel.type == CHALLENGE_TYPE.step ? size.height - size.width + 24 : size.height * 4 / 10 - 64,
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
                            boxShadow: const [],

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

                                      borderRadius: const BorderRadius.only(
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
                                      //
                                      // Center(
                                      //   child: Container(
                                      //       width: 64,
                                      //       height: 4,
                                      //       decoration: BoxDecoration(
                                      //           color: MainColors.middleGrey200,
                                      //           borderRadius:
                                      //           BorderRadius.circular(30))),
                                      // ),
                                      //
                                      const SizedBox(
                                        height: 8,
                                      ),

                                      Expanded(
                                        child: ScrollConfiguration(
                                          behavior: MainScrollBehavior(),
                                          child: SingleChildScrollView(
                                            controller: sc,
                                            // physics: const ScrollPhysics(),
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

                                                      if(state.challengeModel.type == CHALLENGE_TYPE.checkPoint)
                                                      Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets.only(top:16),
                                                        padding: const PagePadding.all16(),
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
                                                                        state.challengeModel.endDate != null ? Utils.stringToDatetoString(value: state.challengeModel.endDate!, formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy"): '-',
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
                                                        height: 8,
                                                      ),
                                                      CustomHtmlReadMoreLess(
                                                        textStyle: MainStyles.semiBoldTextStyle.copyWith(height: 1.4, fontSize: 14 ),
                                                        maxHeight: 96,
                                                        text: state.challengeModel.description ?? '-',
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 16,
                                                ),

                                                StepStageWidget(
                                                  challengeModel: state.challengeModel,
                                                ),

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

                                                      if(state.challengeModel.type == CHALLENGE_TYPE.step)
                                                        HowCanWin(challengeModel: state.challengeModel),

                                                      if(state.challengeModel.type == CHALLENGE_TYPE.step)
                                                        const StepBaseParticipantList(),

                                                      if(state.challengeModel.type == CHALLENGE_TYPE.checkPoint)
                                                      Row(
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
                                                                    : const Text(" ");
                                                              }
                                                          ),
                                                        ],
                                                      ),

                                                      if(state.challengeModel.type == CHALLENGE_TYPE.checkPoint)
                                                        const SizedBox(height: 4,),

                                                      if(state.challengeModel.type == CHALLENGE_TYPE.checkPoint)
                                                        const TrackBaseParticipantList(),
                                                      if(state.challengeModel.sponsorName != null)
                                                        const SizedBox(height: 16),
                                                      if(state.challengeModel.sponsorName != null)
                                                        Container(
                                                          padding: const PagePadding.all16(),
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            color: MainColors.backgroundColor,
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              state.challengeModel.sponsorImage != null ?
                                                              CachedNetworkImage(
                                                                placeholder: (context, key){
                                                                  return Container(
                                                                    width: size.width * 1.9 / 10,
                                                                    height: size.width * 1.9 / 10,
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
                                                                imageUrl: state.challengeModel.sponsorImage!,
                                                                width: size.width * 1.9 / 10,
                                                                height: size.width * 1.9 / 10,
                                                              ):
                                                              Image.asset("assets/images/api/company.png", width: size.width * 1.9 / 10),
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
                                                                        state.challengeModel.sponsorName!,
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
                                                state.challengeModel.type == CHALLENGE_TYPE.step ?
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  child: Opacity(
                                                    opacity: state.challengeModel.isExpired! ? 0.4 : 1,
                                                    child: BigUnBorderedButton(
                                                      buttonColor: state.challengeModel.isJoined! ? MainColors.stopButtonColor : MainColors.generalSubtitleColor,
                                                      textColor: state.challengeModel.isJoined! ? MainColors.generalSubtitleColor : null,
                                                      onTap: () async{
                                                        if(state.challengeModel.isExpired!) {
                                                          return;
                                                        }
                                                        if (!state.challengeModel.isJoined!){
                                                          showLoading(context, Utils.getString(context, "general__loading_text"));
                                                          await context.read<ChallengeDetailBloc>().joinStepBaseChallenge().then((data) {
                                                            closeLoading(context);
                                                            switch (data[2]) {
                                                              case WEB_SERVICE_ENUM.success:
                                                                {
                                                                  BlocProvider.of<StepBaseParticipantListCubit>(context).search(reset: false);
                                                                  _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 5));
                                                                  _controllerTopCenter.play();
                                                                  ModalUtils.showGeneralInfoModal(context, size, image: "assets/svgs/challenges/step-base-challenge-join-dialog.svg", title: Utils.getString(context, "challenge_detail_view__step_success_join_title"), text: sprintf(Utils.getString(context, "challenge_detail_view__step_success_join_text"), [state.challengeModel.name ?? '']), controllerTopCenter: _controllerTopCenter);
                                                                  // _controllerTopCenter.stop();
                                                                }
                                                                break;
                                                              case WEB_SERVICE_ENUM.internetError:
                                                                {
                                                                  Utils.showErrorModal(context, size,
                                                                      errorCode: WEB_SERVICE_ENUM.internetError,
                                                                      title: Utils.getString(
                                                                          context, data[1] ?? "internet_connection_error"));
                                                                  // Utils.showErrorModal(context, size, image: "assets/svgs/dialog/error.svg", title: Utils.getString(context, "profile_view___form_success_message"));
                                                                }
                                                                break;
                                                              default:
                                                                {
                                                                  Utils.showErrorModal(context, size,
                                                                      errorCode: data[2],
                                                                      title: Utils.getString(
                                                                          context, data[1] ?? "error_went_wrong"));
                                                                }
                                                                break;
                                                            }
                                                          }).catchError((e, s){
                                                            log("[LOG joinStepBaseChallenge]" + s.toString());
                                                            closeLoading(context);
                                                            Utils.showErrorModal(context, size,
                                                                // errorCode: e.toString(),
                                                                title: Utils.getString(
                                                                    context, e.toString()));
                                                          });
                                                        }else{

                                                          showYesNoDialog(context, Utils.getString(context, "challenges_details_view___cancel_dialog"),() async{

                                                            Navigator.of(context).pop();

                                                            showLoading(context, Utils.getString(context, "general__loading_text"));
                                                            await context.read<ChallengeDetailBloc>().cancelStepBaseChallenge().then((data) {
                                                              closeLoading(context);
                                                              switch (data[2]) {
                                                                case WEB_SERVICE_ENUM.success:
                                                                  {
                                                                    BlocProvider.of<StepBaseParticipantListCubit>(context).search(reset: false);
                                                                    // ModalUtils.showGeneralInfoModal(context, size, image: "assets/svgs/challenges/step-base-challenge-join-dialog.svg", title: Utils.getString(context, "challenge_detail_view__step_success_cancel_title"), text: sprintf(Utils.getString(context, "challenge_detail_view__step_success_cancel_text"), [state.challengeModel.name ?? '']));                                          // Navigator.pushReplacementNamed(context, "apploading");
                                                                  }
                                                                  break;
                                                                case WEB_SERVICE_ENUM.internetError:
                                                                  {
                                                                    Utils.showErrorModal(context, size,
                                                                        errorCode: WEB_SERVICE_ENUM.internetError,
                                                                        title: Utils.getString(
                                                                            context, data[1] ?? "internet_connection_error"));
                                                                    // Utils.showErrorModal(context, size, image: "assets/svgs/dialog/error.svg", title: Utils.getString(context, "profile_view___form_success_message"));
                                                                  }
                                                                  break;
                                                                default:
                                                                  {
                                                                    Utils.showErrorModal(context, size,
                                                                        errorCode: data[2],
                                                                        title: Utils.getString(
                                                                            context, data[1] ?? "error_went_wrong"));
                                                                  }
                                                                  break;
                                                              }
                                                            }).catchError((e, s){
                                                              log("[LOG joinStepBaseChallenge]" + s.toString());
                                                              closeLoading(context);
                                                              Utils.showErrorModal(context, size,
                                                                  // errorCode: e.toString(),
                                                                  title: Utils.getString(
                                                                      context, e.toString()));
                                                            });
                                                          }, () {
                                                            // shouldClose = false;
                                                            Navigator.of(context).pop();
                                                          },
                                                          svgAsset: 'assets/svgs/challenges/step-base-challenge-cancel-dialog.svg',
                                                          yesText: Utils.getString(context, "challenge_detail_view__step_cancel_dialog__yes"),
                                                          yesTextColor: MainColors.red,
                                                          noText: Utils.getString(context, "challenge_detail_view__step_cancel_dialog__no"),
                                                          );

                                                        }
                                                      },
                                                      // borderRadius: 100,
                                                      text: Utils.getString(context, state.challengeModel.isJoined! ? "challenge_detail_view__button_cancel" : "challenge_detail_view__button_start"),
                                                    ),
                                                  ),
                                                ):
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  child: Opacity(
                                                    opacity: state.challengeModel.isExpired! ? 0.4 : 1,
                                                    child: BigUnBorderedButton(
                                                      buttonColor: MainColors.generalSubtitleColor,
                                                      onTap: () async{
                                                        if(state.challengeModel.isExpired!) {
                                                          return;
                                                        }
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
                                                        if (listData[2] == WEB_SERVICE_ENUM.success) {
                                                          ChallengeUserResponse challengeUserResponse = ChallengeUserResponse.fromJson(listData[1]);

                                                          Location location = Location();
                                                          location.getLocation().then((value)async{
                                                            if(value.latitude == null){
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
                                                                                  child: const ChallengeView()
                                                                              )));
                                                                }else{
                                                                  Utils.showErrorModal(context, size, image: "assets/svgs/challenges/location-error.svg", title: Utils.getString(context,"challenges_details_view___joined_to_challenge_dialog_you_are_not_in_start_point"));
                                                                }
                                                              }else{

                                                                closeLoading(context);
                                                                Utils.showErrorModal(context, size,
                                                                    errorCode: WEB_SERVICE_ENUM.unexpectedError,
                                                                    title: Utils.getString(context,
                                                                        "challenges_details_view___joined_to_challenge_dialog_unexpected_error_try_again"));
                                                              }
                                                            }
                                                          }).catchError((e){

                                                            closeLoading(context);
                                                          });
                                                        }
                                                        else
                                                        if (listData[2] == WEB_SERVICE_ENUM.unAuth) {
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
                                                ),
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

                      ],
                    ),

                    Positioned(
                      left: 2.0,
                      top: 50.0,
                      child: GestureDetector(
                        onTap: () {
                          Utils.focusClose(context);
                          if(context.read<ChallengeDetailBloc>().challengeChanged) {
                            Navigator.pop(context, state.challengeModel);
                          }
                          else {
                            Navigator.pop(context);
                          }
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

                    // Positioned(
                    //   right: 2.0,
                    //   top: 50.0,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Utils.focusClose(context);
                    //       Navigator.pop(context);
                    //     },
                    //     child: Container(
                    //
                    //       padding: const EdgeInsets.fromLTRB(
                    //         14,
                    //         14,
                    //         14,
                    //         14,
                    //         // 0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(
                    //             100),
                    //         // color: MainColors.white,
                    //
                    //         // boxShadow: [
                    //         //     BoxShadow(
                    //         //     blurRadius: 8.0,
                    //         //     color: Color.fromRGBO(0, 0, 0, 0.25),
                    //         //   ),
                    //         // ],
                    //       ),
                    //       child: SvgPicture.asset(
                    //         "assets/svgs/menu/share.svg",
                    //         color: MainColors.white,
                    //         height: 24,
                    //       ),
                    //     ),
                    //
                    //   ),
                    // ),



                  ],
                ),
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


  @override
  void dispose() {
    // TODO: implement dispose
    _controllerTopCenter.dispose();
    super.dispose();
  }

}







