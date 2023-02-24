import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

abstract class HealthTodayState extends Equatable {
  const HealthTodayState();

  @override
  List<Object> get props => [];
}

class HealthTodayLoading extends HealthTodayState {}

class HealthTodaySuccess extends HealthTodayState {
  final int stepCount;
  final num calories;
  final num distance;

  const HealthTodaySuccess({ this.calories = 0, this.stepCount = 0 , this.distance = 0 });

  HealthTodaySuccess copyWith({
    int? stepCount,
    num? calories,
    num? distance,
  }) {
    return HealthTodaySuccess(
      stepCount: stepCount ?? this.stepCount,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
    );
  }

  @override
  List<Object> get props => [calories, stepCount, distance];

  @override
  String toString() =>
      'HealthTodaySuccess { mainData: calories, stepCount: $stepCount , distance: $distance }';
}

class HealthTodayError extends HealthTodayState {
  final WEB_SERVICE_ENUM errorCode;

  const HealthTodayError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}
class HealthTodayNotGranted extends HealthTodayState {

  @override
  List<Object> get props => [];
}