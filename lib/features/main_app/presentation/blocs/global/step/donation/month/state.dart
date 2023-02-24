import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/step/user_order.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

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
  List<Object> get props => [mainData, mainData.userRating!, mainData.userRating!.steps!];

  @override
  String toString() => 'GeneralUserLeaderBoardMonthDonationSuccess { mainData: ${mainData.number}, steps: ${mainData.userRating != null && mainData.userRating!.steps != null ? mainData.userRating!.steps : 0}}';
}

class GeneralUserLeaderBoardMonthDonationError extends GeneralUserLeaderBoardMonthDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardMonthDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}