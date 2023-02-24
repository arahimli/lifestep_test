import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/step/user_order.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

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
      'GeneralUserLeaderBoardWeekDonationSuccess { mainData: ${mainData.number}}';
}

class GeneralUserLeaderBoardWeekDonationError extends GeneralUserLeaderBoardWeekDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardWeekDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}