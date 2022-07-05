

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/model/auth/login.dart';
import 'package:lifestep/model/auth/profile.dart';



class PolylineMapState {
  final Map<PolylineId, Polyline> polylines;


  PolylineMapState({
    this.polylines = const {},
  });

  PolylineMapState copyWith({
    final Map<PolylineId, Polyline>? polylines,
  }) {
    return PolylineMapState(
      polylines: polylines ?? this.polylines,
    );
  }
}