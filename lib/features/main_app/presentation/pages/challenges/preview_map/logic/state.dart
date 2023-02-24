

import 'package:google_maps_flutter/google_maps_flutter.dart';



class PreviewPolylineMapState {
  final Map<PolylineId, Polyline> polylines;


  PreviewPolylineMapState({
    this.polylines = const {},
  });

  PreviewPolylineMapState copyWith({
    final Map<PolylineId, Polyline>? polylines,
  }) {
    return PreviewPolylineMapState(
      polylines: polylines ?? this.polylines,
    );
  }
}