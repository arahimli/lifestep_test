import 'package:equatable/equatable.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/model/step/user-order.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class GeneralUserLeaderBoardMonthStepState extends Equatable {
  const GeneralUserLeaderBoardMonthStepState();

  @override
  List<Object> get props => [];
}

class GeneralUserLeaderBoardMonthStepLoading extends GeneralUserLeaderBoardMonthStepState {}

// class GeneralUserLeaderBoardMonthStepFetching extends GeneralUserLeaderBoardMonthStepState {}

class GeneralUserLeaderBoardMonthStepSuccess extends GeneralUserLeaderBoardMonthStepState {
  final UserOrderModel mainData;

  const GeneralUserLeaderBoardMonthStepSuccess({required this.mainData});

  GeneralUserLeaderBoardMonthStepSuccess copyWith({
    UserOrderModel? mainData,
  }) {
    return GeneralUserLeaderBoardMonthStepSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'GeneralUserLeaderBoardMonthStepSuccess { mainData: ${mainData != null ? mainData.number : 0}}';
}

class GeneralUserLeaderBoardMonthStepError extends GeneralUserLeaderBoardMonthStepState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardMonthStepError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}