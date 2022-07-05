// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart' as latlong;
// import 'package:lifestep/config/main_config.dart';
// import 'package:location/location.dart';
//
// import 'package:mapbox_flutter/mapbox_flutter.dart';
//
// import '../widgets/drawer.dart';
//
// class MapControllerPage extends StatefulWidget {
//   static const String route = 'map_controller';
//
//   @override
//   MapControllerPageState createState() {
//     return MapControllerPageState();
//   }
// }
//
// class MapControllerPageState extends State<MapControllerPage> {
//
//   MapboxFlutterMapController? mapController;
//
//   void _onMapCreated(MapboxFlutterMapController controller) {
//     mapController = controller;
//   }
//   @override
//   Widget build(BuildContext context) {
//     var markers = <Marker>[
//
//     ];
//
//     return Scaffold(
//       appBar: AppBar(title: Text('MapController')),
//       drawer: buildDrawer(context, MapControllerPage.route),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Flexible(
//               child: Stack(
//                 children: [
//                   MapboxFlutterMap(
//                     accessToken: MainConfig.mapBoxAccessToken,
//                     styleString: "mapbox://styles/digitalks22/ckzpb1qai000r14n8y7u9k6sy",
//                     onMapCreated: _onMapCreated,
//                     initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
//                     onStyleLoadedCallback: onStyleLoadedCallback,
//                   ),
//
//                   // Align(
//                   //   alignment: Alignment.center,
//                   //   child: CurrentLocation(mapController: mapController)
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
//
//   void onStyleLoadedCallback() {}
// }
//
// class CurrentLocation extends StatefulWidget {
//   const CurrentLocation({
//     Key? key,
//     required this.mapController,
//   }) : super(key: key);
//
//   final MapController mapController;
//
//   @override
//   _CurrentLocationState createState() => _CurrentLocationState();
// }
//
// class _CurrentLocationState extends State<CurrentLocation> {
//   int _eventKey = 0;
//
//   var icon = Icons.gps_not_fixed;
//   late final StreamSubscription<MapEvent> mapEventSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     mapEventSubscription =
//         widget.mapController.mapEventStream.listen(onMapEvent);
//   }
//
//   @override
//   void dispose() {
//     mapEventSubscription.cancel();
//     super.dispose();
//   }
//
//   void setIcon(IconData newIcon) {
//     if (newIcon != icon && mounted) {
//       setState(() {
//         icon = newIcon;
//       });
//     }
//   }
//
//   void onMapEvent(MapEvent mapEvent) {
//     if (mapEvent is MapEventMove && mapEvent.id == _eventKey.toString()) {
//       setIcon(Icons.gps_not_fixed);
//     }
//   }
//
//   void _moveToCurrent() async {
//     _eventKey++;
//     var location = Location();
//
//     try {
//       var currentLocation = await location.getLocation();
//       var moved = widget.mapController.move(
//         latlong.LatLng(currentLocation.latitude!, currentLocation.longitude!),
//         18,
//         id: _eventKey.toString(),
//       );
//
//       if (moved) {
//         setIcon(Icons.gps_fixed);
//       } else {
//         setIcon(Icons.gps_not_fixed);
//       }
//     } catch (e) {
//       setIcon(Icons.gps_off);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(icon),
//       onPressed: _moveToCurrent,
//     );
//   }
// }
