import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/leaderboard/list.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class HomeLeaderBoardDonationState extends Equatable {
  const HomeLeaderBoardDonationState();

  @override
  List<Object> get props => [];
}

class HomeLeaderBoardDonationLoading extends HomeLeaderBoardDonationState {}

// class HomeLeaderBoardDonationFetching extends HomeLeaderBoardDonationState {}

class HomeLeaderBoardDonationSuccess extends HomeLeaderBoardDonationState {
  final List<UsersRatingModel> mainData;

  const HomeLeaderBoardDonationSuccess({required this.mainData});

  HomeLeaderBoardDonationSuccess copyWith({
    List<UsersRatingModel>? mainData,
  }) {
    return HomeLeaderBoardDonationSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'HomeLeaderBoardDonationSuccess { mainData: ${mainData.length}}';
}

class HomeLeaderBoardDonationError extends HomeLeaderBoardDonationState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const HomeLeaderBoardDonationError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}