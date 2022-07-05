import 'package:equatable/equatable.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/model/step/user-order.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class GeneralUserLeaderBoardWeekDonationState extends Equatable {
  const GeneralUserLeaderBoardWeekDonationState();

  @override
  List<Object> get props => [];
}

class GeneralUserLeaderBoardWeekDonationLoading extends GeneralUserLeaderBoardWeekDonationState {}

// class GeneralUserLeaderBoardWeekDonationFetching extends GeneralUserLeaderBoardWeekDonationState {}

class GeneralUserLeaderBoardWeekDonationSuccess extends GeneralUserLeaderBoardWeekDonationState {
  final UserOrderModel mainData;

  const GeneralUserLeaderBoardWeekDonationSuccess({required this.mainData});

  GeneralUserLeaderBoardWeekDonationSuccess copyWith({
    UserOrderModel? mainData,
  }) {
    return GeneralUserLeaderBoardWeekDonationSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'GeneralUserLeaderBoardWeekDonationSuccess { mainData: ${mainData != null ? mainData.number : 0}}';
}

class GeneralUserLeaderBoardWeekDonationError extends GeneralUserLeaderBoardWeekDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardWeekDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}