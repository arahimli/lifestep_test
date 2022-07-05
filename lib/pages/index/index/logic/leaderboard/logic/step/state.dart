import 'package:equatable/equatable.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class HomeLeaderBoardStepState extends Equatable {
  const HomeLeaderBoardStepState();

  @override
  List<Object> get props => [];
}

class HomeLeaderBoardStepLoading extends HomeLeaderBoardStepState {}

// class HomeLeaderBoardStepFetching extends HomeLeaderBoardStepState {}

class HomeLeaderBoardStepSuccess extends HomeLeaderBoardStepState {
  final List<UsersRatingModel> mainData;

  const HomeLeaderBoardStepSuccess({required this.mainData});

  HomeLeaderBoardStepSuccess copyWith({
    List<UsersRatingModel>? mainData,
  }) {
    return HomeLeaderBoardStepSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'HomeLeaderBoardStepSuccess { mainData: ${mainData != null ? mainData.length : 0}}';
}

class HomeLeaderBoardStepError extends HomeLeaderBoardStepState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const HomeLeaderBoardStepError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}