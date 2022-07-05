import 'package:equatable/equatable.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class HealthMonthState extends Equatable {
  const HealthMonthState();

  @override
  List<Object> get props => [];
}

class HealthMonthLoading extends HealthMonthState {}

class HealthMonthSuccess extends HealthMonthState {
  final int stepCount;
  final int stepCountDay;
  final num calories;
  final num distance;
  final int selectedMonth;

  const HealthMonthSuccess({ this.calories : 0, this.stepCount:0 , this.stepCountDay:0 , this.distance:0, required this.selectedMonth});

  HealthMonthSuccess copyWith({
    int? stepCount,
    int? stepCountDay,
    num? calories,
    num? distance,
    int? selectedMonth,
  }) {
    return HealthMonthSuccess(
      stepCount: stepCount ?? this.stepCount,
      stepCountDay: stepCountDay ?? this.stepCountDay,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  @override
  List<Object> get props => [calories, stepCount, distance];

  @override
  String toString() =>
      'HealthMonthSuccess { mainData: ${ calories }, stepCount: $stepCount , distance: $distance }';
}

class HealthMonthSuccessLoading extends HealthMonthState {
  final int selectedMonth;

  const HealthMonthSuccessLoading({required this.selectedMonth});

  HealthMonthSuccess copyWith({
    int? selectedMonth,
  }) {
    return HealthMonthSuccess(
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  @override
  List<Object> get props => [selectedMonth];

  @override
  String toString() =>
      'HealthMonthSuccess { mainData: ${ selectedMonth.toString() }';
}

class HealthMonthError extends HealthMonthState {
  final WEB_SERVICE_ENUM errorCode;

  const HealthMonthError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}
class HealthMonthNotGranted extends HealthMonthState {

  @override
  List<Object> get props => [];
}