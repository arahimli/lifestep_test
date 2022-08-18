// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lifestep/src/tools/config/main_colors.dart';
// import 'package:lifestep/src/tools/config/main_config.dart';
// import 'package:lifestep/src/models/challenge/challenges.dart';
// import 'package:lifestep/src/ui/challenges/preview_map/logic/state.dart';
// import 'package:lifestep/src/resources/challenge.dart';
//
//
// class PreviewPolylineMapCubit extends Cubit<PreviewPolylineMapState> {
//   final ChallengeRepository challengeRepository;
//   final ChallengeModel challengeModel;
//
//
//   Map<PolylineId, Polyline> polylines = {};
//
//   PolylinePoints polylinePoints = PolylinePoints();
//   List<LatLng> polylineCoordinates = [];
//
//
//
//
//   PreviewPolylineMapCubit({required this.challengeRepository, required this.challengeModel}) : super(PreviewPolylineMapState()) {
//     // initialize0();
//     initialize();
//   }
//
//   Future<void> initialize() async {
//     polylines = {};
//     List<LatLng> coordinates = challengeModel.mapJsonGet().map((element) => LatLng(element[1], element[0])).toList();
//     // for(int i=0; (coordinates.length - 2) > i; i++) {
//         // await drawPolyline(coordinates[i], coordinates[i + 1], i);
//       _addPolyLine(polykey: "poly-key-${0.toString()}",startLatLng: LatLng(coordinates[0].latitude, coordinates[0].longitude), plc: coordinates);
//
//       // await _addPolyLine(polykey: "poly-key-${i.toString()}", coordinates[i], coordinates[i + 1], i);
//         // emit(state.copyWith(polylines: polylines));
//     // }
//     emit(state.copyWith(polylines: polylines));
//   }
//
//   drawPolyline(LatLng start, LatLng end, int index) async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         MainConfig.main_map_api_key,
//         PointLatLng(start.latitude, start.longitude),
//         PointLatLng(end.latitude, end.longitude),
//         travelMode: TravelMode.walking,
//         optimizeWaypoints: false
//     );
//     List<LatLng> localPolylineCoordinates = [];
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         localPolylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     _addPolyLine(polykey: "poly-key-${index.toString()}",startLatLng: LatLng(start.latitude, start.longitude,), plc: localPolylineCoordinates);
//   }
//
//   _addPolyLine({required LatLng startLatLng, required List<LatLng> plc, required String polykey}) {
//     PolylineId id = PolylineId(polykey);
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: MainColors.darkPink500!,
//       points: plc,
//       width: 2,
//     );
//     polylines[id] = polyline;
//   }
//
//
//
//
// }
