import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/step/user-order.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class GeneralUserLeaderBoardWeekStepState extends Equatable {
  const GeneralUserLeaderBoardWeekStepState();

  @override
  List<Object> get props => [];
}

class GeneralUserLeaderBoardWeekStepLoading extends GeneralUserLeaderBoardWeekStepState {}

// class GeneralUserLeaderBoardWeekStepFetching extends GeneralUserLeaderBoardWeekStepState {}

class GeneralUserLeaderBoardWeekStepSuccess extends GeneralUserLeaderBoardWeekStepState {
  final UserOrderModel mainData;

  const GeneralUserLeaderBoardWeekStepSuccess({required this.mainData});

  GeneralUserLeaderBoardWeekStepSuccess copyWith({
    UserOrderModel? mainData,
  }) {
    return GeneralUserLeaderBoardWeekStepSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'GeneralUserLeaderBoardWeekStepSuccess { mainData: ${mainData.number}}';
}

class GeneralUserLeaderBoardWeekStepError extends GeneralUserLeaderBoardWeekStepState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardWeekStepError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}