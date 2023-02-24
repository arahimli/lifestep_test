import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/step/user_order.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

abstract class GeneralUserLeaderBoardAllDonationState extends Equatable {
  const GeneralUserLeaderBoardAllDonationState();

  @override
  List<Object> get props => [];
}

class GeneralUserLeaderBoardAllDonationLoading extends GeneralUserLeaderBoardAllDonationState {}

// class GeneralUserLeaderBoardAllDonationFetching extends GeneralUserLeaderBoardAllDonationState {}

class GeneralUserLeaderBoardAllDonationSuccess extends GeneralUserLeaderBoardAllDonationState {
  final UserOrderModel mainData;

  const GeneralUserLeaderBoardAllDonationSuccess({required this.mainData});

  GeneralUserLeaderBoardAllDonationSuccess copyWith({
    UserOrderModel? mainData,
  }) {
    return GeneralUserLeaderBoardAllDonationSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'GeneralUserLeaderBoardAllDonationSuccess { mainData: ${mainData.number}}';
}

class GeneralUserLeaderBoardAllDonationError extends GeneralUserLeaderBoardAllDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const GeneralUserLeaderBoardAllDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}