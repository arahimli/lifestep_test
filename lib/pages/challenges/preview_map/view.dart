import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/tools/components/dialog/loading.dart';
import 'package:lifestep/config/main_colors.dart';

import 'package:location/location.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'logic/cubit.dart';
import 'logic/state.dart';



class PreviewMapView extends StatefulWidget {
  final LocationData? currentLocation;
  const PreviewMapView({Key? key, this.currentLocation}) : super(key: key);

  @override
  _PreviewMapViewState createState() => _PreviewMapViewState();
}

class _PreviewMapViewState extends State<PreviewMapView>  with WidgetsBindingObserver{

  GoogleMapController? _controller;
  Location location = Location();
  LocationData? locationData;
  late StreamSubscription<LocationData> locationSubscription;

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
  // final geolocator.LocationSettings locationSettings = geolocator.LocationSettings(
  //   accuracy: geolocator.LocationAccuracy.high,
  //   distanceFilter: 100,
  // );



  @override
  Widget build(BuildContext context) {
    // final String token = MainConfig.mapBoxAccessToken;
    // final String style = 'mapbox://styles/digitalks22/ckzpb1qai000r14n8y7u9k6sy';
    Size size = MediaQuery.of(context).size;
    CameraPosition cameraPosition  = CameraPosition(
        bearing: 1,
        tilt: 1,
        target: computeCentroid(
            context.read<PreviewPolylineMapCubit>().challengeModel.getCoordinates()
        ),
        zoom: 13
    );

    return WillPopScope(
      onWillPop: () async{
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<PreviewPolylineMapCubit, PreviewPolylineMapState>(
                builder: (context, polylineMapState) {
                  return GoogleMap(
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
                  );
                }
            ),
            Align(
              alignment: Alignment(0.8, 0.9),
              child: Container(
                  height: size.width * 1.5 / 10,
                  width: size.width * 1.5 / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 1.5 / 10),
                  ),
                  child: GestureDetector(
                    onTap: (){

                      _controller!.animateCamera( CameraUpdate.newCameraPosition(cameraPosition));

                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: MainColors.white,
                          borderRadius: BorderRadius.circular(size.width * 1.5 / 10),
                        ),
                        child: Center(
                            child: SvgPicture.asset("assets/svgs/challenges/full-track.svg", height : (size.width * 1.5 / 10) * 1.4 / 4, color: MainColors.black)
                        )
                    ),
                  )
              ),
            )

          ],
        ),
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
    locationSubscription.cancel();

    // location.enableBackgroundMode(enable: false);



    super.dispose();
  }




}