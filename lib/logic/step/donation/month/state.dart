import 'package:equatable/equatable.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/model/step/user-order.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class GeneralUserLeaderBoardMonthDonationState extends Equatable {
  const GeneralUserLeaderBoardMonthDonationState();

  @override
  List<Object> get props => [];
}

class GeneralUserLeaderBoardMonthDonationLoading extends GeneralUserLeaderBoardMonthDonationState {}

// class GeneralUserLeaderBoardMonthDonationFetching extends GeneralUserLeaderBoardMonthDonationState {}

class GeneralUserLeaderBoardMonthDonationSuccess extends GeneralUserLeaderBoardMonthDonationState {
  final UserOrderModel mainData;

  const GeneralUserLeaderBoardMonthDonationSuccess({required this.mainData});

  GeneralUserLeaderBoardMonthDonationSuccess copyWith({
    UserOrderModel? mainData,
  }) {
    return GeneralUserLeaderBoardMonthDonationSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [this.mainData, this.mainData.userRating!, this.mainData.userRating!.steps!];

  @override
  String toString() => 'GeneralUserLeaderBoardMonthDonationSuccess { mainData: ${mainData != null ? mainData.number : 0}, steps: ${mainData != null && mainData.userRating != null && mainData.userRating!.steps != null ? mainData.userRating!.steps : 0}}';
}

class GeneralUserLeaderBoardMonthDonationError extends GeneralUserLeaderBoardMonthDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardMonthDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}