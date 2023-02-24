import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

abstract class HomeDailyStepState extends Equatable {
  const HomeDailyStepState();

  @override
  List<Object> get props => [];
}

class HomeDailyStepLoading extends HomeDailyStepState {}

class HomeDailyStepSuccess extends HomeDailyStepState {
  final int stepCountDay;
  final DateTime selectedDate;

  const HomeDailyStepSuccess({ this.stepCountDay=0, required this.selectedDate});

  HomeDailyStepSuccess copyWith({
    int? stepCountDay,
    DateTime? selectedDate,
  }) {
    return HomeDailyStepSuccess(
      stepCountDay: stepCountDay ?? this.stepCountDay,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [stepCountDay, selectedDate];

  @override
  String toString() =>
      'HomeDailyStepSuccess { mainData: $stepCountDay';
}

class HomeDailyStepSuccessLoading extends HomeDailyStepState {
  final int stepCountDay;
  final DateTime selectedDate;

  const HomeDailyStepSuccessLoading({ this.stepCountDay=0 ,required this.selectedDate});

  HomeDailyStepSuccess copyWith({
    int? stepCountDay,
    DateTime? selectedDate,
  }) {
    return HomeDailyStepSuccess(
      stepCountDay: stepCountDay ?? this.stepCountDay,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object> get props => [stepCountDay];

  @override
  String toString() =>
      'HomeDailyStepSuccess { mainData: ${ selectedDate.toString() }, stepCountDay: $stepCountDay }';
}

class HomeDailyStepError extends HomeDailyStepState {
  final WEB_SERVICE_ENUM errorCode;

  const HomeDailyStepError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}
class HomeDailyStepNotGranted extends HomeDailyStepState {
  final int stepCountDay;
  final DateTime selectedDate;

  const HomeDailyStepNotGranted({ this.stepCountDay=0 ,required this.selectedDate});

  @override
  List<Object> get props => [];
}