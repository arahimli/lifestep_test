import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

abstract class AddressInfoState extends Equatable {
  const AddressInfoState();

  @override
  List<Object> get props => [];
}

class AddressInfoLoading extends AddressInfoState {}

class AddressInfoSuccess extends AddressInfoState {
  final String? addressText;
  final LatLng? point;
  final int? distance;
  final bool completed;

  const AddressInfoSuccess({this.addressText, this.point, this.distance : 0, this.completed : false});

  AddressInfoSuccess copyWith({
    String? addressText,
    LatLng? point,
    int? distance,
    bool? completed
  }) {
    return AddressInfoSuccess(
      addressText: addressText ?? this.addressText,
      point: point?? this.point,
      distance: distance?? this.distance,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object> get props => [addressText ?? '', point ?? LatLng(0, 0)];

  @override
  String toString() =>
      'AddressInfoSuccess { mainData: ${addressText != null ? addressText!.length : 0}, hasReachedMax: $addressText }';
}
class AddressInfoEmpty extends AddressInfoState {
  final String addressText;

  const AddressInfoEmpty({required this.addressText});

  AddressInfoEmpty copyWith({
    required String addressText,
  }) {
    return AddressInfoEmpty(
      addressText: addressText,
    );
  }

  @override
  List<Object> get props => [addressText];

  @override
  String toString() =>
      'AddressInfoEmpty { mainData: ${addressText.length}';
}

class AddressInfoError extends AddressInfoState {
  final WEB_SERVICE_ENUM errorCode;

  const AddressInfoError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}