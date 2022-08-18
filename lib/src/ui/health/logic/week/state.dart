import 'package:equatable/equatable.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class HealthWeekState extends Equatable {
  const HealthWeekState();

  @override
  List<Object> get props => [];
}

class HealthWeekLoading extends HealthWeekState {}

class HealthWeekSuccess extends HealthWeekState {
  final int stepCount;
  final int stepCountDay;
  final num calories;
  final num distance;
  final DateTime selectedDate;

  const HealthWeekSuccess({ this.calories = 0, this.stepCount = 0 , this.stepCountDay = 0 , this.distance = 0, required this.selectedDate});

  HealthWeekSuccess copyWith({
    int? stepCount,
    int? stepCountDay,
    num? calories,
    num? distance,
    DateTime? selectedDate,
  }) {
    return HealthWeekSuccess(
      stepCount: stepCount ?? this.stepCount,
      stepCountDay: stepCountDay ?? this.stepCountDay,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [calories, stepCount, distance];

  @override
  String toString() =>
      'HealthWeekSuccess { mainData: ${ calories }, stepCount: $stepCount , distance: $distance }';
}

class HealthWeekSuccessLoading extends HealthWeekState {
  final int stepCount;
  final DateTime selectedDate;

  const HealthWeekSuccessLoading({ this.stepCount:0 ,required this.selectedDate});

  HealthWeekSuccess copyWith({
    int? stepCount,
    DateTime? selectedDate,
  }) {
    return HealthWeekSuccess(
      stepCount: stepCount ?? this.stepCount,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [stepCount];

  @override
  String toString() =>
      'HealthWeekSuccess { mainData: ${ selectedDate.toString() }, stepCount: $stepCount }';
}

class HealthWeekError extends HealthWeekState {
  final WEB_SERVICE_ENUM errorCode;

  const HealthWeekError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}
class HealthWeekNotGranted extends HealthWeekState {

  @override
  List<Object> get props => [];
}