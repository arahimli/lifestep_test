import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/leaderboard/list.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class LeaderBoardDonationState extends Equatable {
  const LeaderBoardDonationState();

  @override
  List<Object> get props => [];
}

class LeaderBoardDonationLoading extends LeaderBoardDonationState {}

// class LeaderBoardDonationFetching extends LeaderBoardDonationState {}

class LeaderBoardDonationSuccess extends LeaderBoardDonationState {
  final UsersRatingDataModel mainData;

  const LeaderBoardDonationSuccess({required this.mainData});

  LeaderBoardDonationSuccess copyWith({
    UsersRatingDataModel? mainData,
  }) {
    return LeaderBoardDonationSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'LeaderBoardDonationSuccess { mainData: ${mainData.usersAllRating != null ? mainData.usersAllRating!.length : 0}}';
}

class LeaderBoardDonationError extends LeaderBoardDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const LeaderBoardDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}