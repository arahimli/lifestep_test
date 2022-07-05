import 'package:equatable/equatable.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/model/step/user-order.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class GeneralUserLeaderBoardAllStepState extends Equatable {
  const GeneralUserLeaderBoardAllStepState();

  @override
  List<Object> get props => [];
}

class GeneralUserLeaderBoardAllStepLoading extends GeneralUserLeaderBoardAllStepState {}

// class GeneralUserLeaderBoardAllStepFetching extends GeneralUserLeaderBoardAllStepState {}

class GeneralUserLeaderBoardAllStepSuccess extends GeneralUserLeaderBoardAllStepState {
  final UserOrderModel mainData;

  const GeneralUserLeaderBoardAllStepSuccess({required this.mainData});

  GeneralUserLeaderBoardAllStepSuccess copyWith({
    UserOrderModel? mainData,
  }) {
    return GeneralUserLeaderBoardAllStepSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'GeneralUserLeaderBoardAllStepSuccess { mainData: ${mainData != null ? mainData.number : 0}}';
}

class GeneralUserLeaderBoardAllStepError extends GeneralUserLeaderBoardAllStepState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardAllStepError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}