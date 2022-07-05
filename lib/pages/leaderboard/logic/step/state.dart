import 'package:equatable/equatable.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class LeaderBoardStepState extends Equatable {
  const LeaderBoardStepState();

  @override
  List<Object> get props => [];
}

class LeaderBoardStepLoading extends LeaderBoardStepState {}

// class LeaderBoardStepFetching extends LeaderBoardStepState {}

class LeaderBoardStepSuccess extends LeaderBoardStepState {
  final UsersRatingDataModel mainData;

  const LeaderBoardStepSuccess({required this.mainData});

  LeaderBoardStepSuccess copyWith({
    UsersRatingDataModel? mainData,
  }) {
    return LeaderBoardStepSuccess(
      mainData: mainData ?? this.mainData,
    );
  }

  @override
  List<Object> get props => [mainData];

  @override
  String toString() =>
      'LeaderBoardStepSuccess { mainData: ${mainData != null ? mainData.usersAllRating!.length : 0}}';
}

class LeaderBoardStepError extends LeaderBoardStepState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const LeaderBoardStepError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}