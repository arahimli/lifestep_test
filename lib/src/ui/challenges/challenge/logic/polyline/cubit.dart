import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/src/tools/config/main_colors.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/challenge/challenge-user.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/ui/challenges/challenge/logic/polyline/state.dart';
import 'package:lifestep/src/resources/challenge.dart';


class PolylineMapCubit extends Cubit<PolylineMapState> {
  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final ChallengeUserModel challengeUserModel;
  CancelToken dioToken = CancelToken();


  Map<PolylineId, Polyline> polylines = {};

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];




  PolylineMapCubit({required this.challengeRepository, required this.challengeModel, required this.challengeUserModel}) : super(PolylineMapState()) {
    // initialize0();
    initialize();
  }

  // Future<void> initialize0() async {
  //
  //   polylines = {};
  //   // List<LatLng> coordinates = [
  //   //   LatLng(40.3795457,49.8473268), LatLng(40.3782524,49.8480003),
  //   //   LatLng(40.373982,49.8447103), LatLng(40.3758338,49.8466038),
  //   //   LatLng(40.373063,49.8419983), LatLng(40.370328,49.8434533),
  //   //   LatLng(40.3680669,49.8392531), LatLng(40.3672704,49.8385874),
  //   // ];
  //   List<LatLng> coordinates = [
  //     LatLng(49.847377351, 40.345487533), LatLng(49.846014789, 40.347548113),
  //     LatLng(49.843836835, 40.346689546), LatLng(49.843836835, 40.346689546),
  //     LatLng(49.84369736, 40.346804022), LatLng(49.843536428, 40.346804022),
  //     LatLng(49.843386224, 40.346722253), LatLng(49.843386224, 40.346640484),
  //     // LatLng(49.840929321, 40.346771314),
  //   ];
  //   //////// print("coordinates__coordinates__coordinates__coordinates__coordinates__coordinates");
  //   debugPrint('data1:$coordinates');
  //   _addPolyLine(polykey: "poly-key-${1.toString()}",startLatLng: coordinates.first, plc: coordinates);
  //
  //   // for(int i=0; i<coordinates.length-1; i++)
  //   //   await drawPolyline(coordinates[i], coordinates[i + 1], i);
  //   emit(state.copyWith(polylines: polylines));
  //
  // }

  Future<void> initialize() async {
    polylines = {};
    List<LatLng> coordinates = challengeModel.mapJsonGet().map((element) => LatLng(element[1], element[0])).toList();
    // for(int i=0; (coordinates.length - 2) > i; i++) {
        // await drawPolyline(coordinates[i], coordinates[i + 1], i);
      _addPolyLine(polykey: "poly-key-${0.toString()}",startLatLng: LatLng(coordinates[0].latitude, coordinates[0].longitude), plc: coordinates);

      // await _addPolyLine(polykey: "poly-key-${i.toString()}", coordinates[i], coordinates[i + 1], i);
        // emit(state.copyWith(polylines: polylines));
    // }
    emit(state.copyWith(polylines: polylines));
  }

  drawPolyline(LatLng start, LatLng end, int index) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        MainConfig.main_map_api_key,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(end.latitude, end.longitude),
        travelMode: TravelMode.walking,
        optimizeWaypoints: false
    );
    List<LatLng> localPolylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        localPolylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine(polykey: "poly-key-${index.toString()}",startLatLng: LatLng(start.latitude, start.longitude,), plc: localPolylineCoordinates);
  }

  _addPolyLine({required LatLng startLatLng, required List<LatLng> plc, required String polykey}) {
    PolylineId id = PolylineId(polykey);
    Polyline polyline = Polyline(
      polylineId: id,
      color: MainColors.darkPink500!,
      points: plc,
      width: 2,
    );
    polylines[id] = polyline;
  }




}
